// lib/services/invoice_pdf_service.dart
import 'dart:typed_data';
import 'package:intl/intl.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:pdf/pdf.dart';
import 'package:gphfinance/model.dart';
import 'package:gphfinance/helper/rupiah_format.dart';

class InvoicePdfService {
  static Future<Uint8List> generate(Invoice invoice,
      {String companyName = 'GPH',
      String companyAddress = 'Jl. Contoh No. 1, Jakarta',
      String companyPhone = '0812-3456-7890'}) async {
    final pdf = pw.Document();

    final dateFmt = DateFormat('dd MMM yyyy', 'id_ID');

    pw.Widget buildHeader() {
      return pw.Row(
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: [
          pw.Container(
            padding: const pw.EdgeInsets.all(8),
            decoration: pw.BoxDecoration(
              borderRadius: pw.BorderRadius.circular(8),
              border: pw.Border.all(color: PdfColors.blue),
            ),
            child: pw.Column(
              crossAxisAlignment: pw.CrossAxisAlignment.start,
              children: [
                pw.Text(companyName,
                    style: pw.TextStyle(
                        fontSize: 18,
                        fontWeight: pw.FontWeight.bold,
                        color: PdfColors.blue)),
                pw.SizedBox(height: 4),
                pw.Text(companyAddress),
                pw.Text('Tel: $companyPhone'),
              ],
            ),
          ),
          pw.Spacer(),
          pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.end,
            children: [
              pw.Text('INVOICE',
                  style: pw.TextStyle(
                      fontSize: 22, fontWeight: pw.FontWeight.bold)),
              pw.SizedBox(height: 8),
              pw.Text('No: ${invoice.id}'),
              pw.Text('Tanggal: ${invoice.date}'),
            ],
          ),
        ],
      );
    }

    pw.Widget buildBillTo() {
      return pw.Container(
        padding: const pw.EdgeInsets.all(8),
        decoration: pw.BoxDecoration(
          borderRadius: pw.BorderRadius.circular(8),
          color: PdfColors.grey200,
        ),
        child: pw.Row(
          crossAxisAlignment: pw.CrossAxisAlignment.start,
          children: [
            pw.Expanded(
              child: pw.Column(
                crossAxisAlignment: pw.CrossAxisAlignment.start,
                children: [
                  pw.Text('Kepada:',
                      style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
                  pw.SizedBox(height: 4),
                  pw.Text(invoice.recipient.isEmpty ? '-' : invoice.recipient),
                  pw.Text(invoice.school.isEmpty ? '-' : invoice.school),
                  pw.Text(invoice.address.isEmpty ? '-' : invoice.address),
                ],
              ),
            ),
            pw.SizedBox(width: 16),
            pw.Expanded(
              child: pw.Column(
                crossAxisAlignment: pw.CrossAxisAlignment.start,
                children: [
                  pw.Text('Ringkasan:',
                      style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
                  pw.SizedBox(height: 4),
                  pw.Text('Status: ${invoice.paid ? 'PAID' : 'UNPAID'}'),
                  pw.Text('Total Buku: ${invoice.totalBooks}'),
                ],
              ),
            ),
          ],
        ),
      );
    }

    pw.Widget buildItemsTable() {
      final headers = ['No', 'Nama Buku', 'Qty', 'Harga', 'Total'];
      final data = <List<String>>[];

      for (var i = 0; i < invoice.items.length; i++) {
        final it = invoice.items[i];
        data.add([
          (i + 1).toString(),
          it.book.name,
          it.quantity.toString(),
          Rupiah.toStringFormated(it.sellingPrice.toDouble()),
          Rupiah.toStringFormated(it.totalPrice.toDouble()),
        ]);
      }

      return pw.Table.fromTextArray(
        headers: headers,
        data: data,
        headerStyle: pw.TextStyle(
            fontWeight: pw.FontWeight.bold, color: PdfColors.white),
        headerDecoration: const pw.BoxDecoration(color: PdfColors.blue),
        cellAlignments: {
          0: pw.Alignment.centerRight,
          1: pw.Alignment.centerLeft,
          2: pw.Alignment.centerRight,
          3: pw.Alignment.centerRight,
          4: pw.Alignment.centerRight,
        },
        cellStyle: const pw.TextStyle(fontSize: 10),
        headerHeight: 28,
        cellHeight: 24,
        border: null,
        rowDecoration: const pw.BoxDecoration(
            border: pw.Border(bottom: pw.BorderSide(color: PdfColors.grey300))),
      );
    }

    pw.Widget buildTotals() {
      return pw.Container(
        alignment: pw.Alignment.centerRight,
        child: pw.Container(
          width: 260,
          padding: const pw.EdgeInsets.all(10),
          decoration: pw.BoxDecoration(
            borderRadius: pw.BorderRadius.circular(8),
            border: pw.Border.all(color: PdfColors.grey400),
          ),
          child: pw.Column(
            children: [
              _kv('Subtotal',
                  Rupiah.toStringFormated(invoice.subTotal.toDouble())),
              _kv('Diskon (${invoice.discount.toStringAsFixed(0)}%)',
                  '- ${Rupiah.toStringFormated(invoice.totalDiscount)}'),
              _kv('PPN (${invoice.tax.toStringAsFixed(0)}%)',
                  '+ ${Rupiah.toStringFormated(invoice.totalTax)}'),
              pw.Divider(),
              _kvBold('Total', Rupiah.toStringFormated(invoice.total)),
              _kv('Bayar Muka', Rupiah.toStringFormated(invoice.downPayment)),
              _kvColor(
                  'Sisa',
                  Rupiah.toStringFormated(invoice.remainingPayment),
                  invoice.remainingPayment > 0
                      ? PdfColors.red
                      : PdfColors.green),
            ],
          ),
        ),
      );
    }

    pw.Widget buildFooter() {
      return pw.Column(
        crossAxisAlignment: pw.CrossAxisAlignment.stretch,
        children: [
          pw.SizedBox(height: 12),
          pw.Text('Catatan:',
              style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
          pw.SizedBox(height: 4),
          pw.Text('• Harap simpan invoice ini sebagai bukti pembayaran.'),
          pw.Text('• Pembayaran dianggap sah setelah dana diterima.'),
          pw.SizedBox(height: 12),
          pw.Divider(),
          pw.Center(
            child: pw.Text('$companyName — Terima kasih!',
                style: pw.TextStyle(color: PdfColors.grey700)),
          ),
        ],
      );
    }

    pdf.addPage(
      pw.MultiPage(
        margin: const pw.EdgeInsets.all(24),
        build: (context) => [
          buildHeader(),
          pw.SizedBox(height: 16),
          buildBillTo(),
          pw.SizedBox(height: 16),
          buildItemsTable(),
          pw.SizedBox(height: 12),
          buildTotals(),
          buildFooter(),
        ],
      ),
    );

    return pdf.save();
  }

  // helpers
  static pw.Widget _kv(String k, String v) => pw.Padding(
        padding: const pw.EdgeInsets.symmetric(vertical: 2),
        child: pw.Row(
          children: [pw.Expanded(child: pw.Text(k)), pw.Text(v)],
        ),
      );

  static pw.Widget _kvBold(String k, String v) => pw.Padding(
        padding: const pw.EdgeInsets.symmetric(vertical: 2),
        child: pw.Row(
          children: [
            pw.Expanded(
                child: pw.Text(k,
                    style: pw.TextStyle(fontWeight: pw.FontWeight.bold))),
            pw.Text(v, style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
          ],
        ),
      );

  static pw.Widget _kvColor(String k, String v, PdfColor color) => pw.Padding(
        padding: const pw.EdgeInsets.symmetric(vertical: 2),
        child: pw.Row(
          children: [
            pw.Expanded(child: pw.Text(k, style: pw.TextStyle(color: color))),
            pw.Text(v,
                style:
                    pw.TextStyle(color: color, fontWeight: pw.FontWeight.bold)),
          ],
        ),
      );
}
