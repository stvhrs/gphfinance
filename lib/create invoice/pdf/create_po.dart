import 'package:flutter/material.dart';
import 'package:gphfinance/model.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';

import 'dart:io';

import 'package:flutter/services.dart' show ByteData, Uint8List, rootBundle;
import 'package:image/image.dart' as img;

class PurchaseOrderPdfGenerator {
  static Future<dynamic> generatePurchaseOrderPdf(
    Invoice invoice, {
    Uint8List? directorSignature,
    bool returnPage = false,
    String companyName = 'PT. BUKU EDUKASI INDONESIA',
    String companyAddress = 'Jl. Pendidikan No. 123, Jakarta Selatan',
    String companyPhone = '(021) 1234-5678',
    String companyEmail = 'info@bukuedukasi.com',
  }) async {
    final pdf = pw.Document();
    final dateFormat = DateFormat('dd MMMM yyyy', 'id_ID');
    final currencyFormat =
        NumberFormat.currency(locale: 'id_ID', symbol: 'Rp ', decimalDigits: 0);

    // Load logo (you can replace this with your actual logo)
    final logo = await _loadLogoImage();

    var multiPage = pw.MultiPage(
      pageFormat: PdfPageFormat.a4,
      margin: const pw.EdgeInsets.all(40),
      build: (context) => [
        _buildHeader(logo, companyName),
        pw.SizedBox(height: 20),
        _buildCompanyInfo(companyAddress, companyPhone, companyEmail),
        pw.SizedBox(height: 30),
        _buildInvoiceInfo(invoice, dateFormat),
        pw.SizedBox(height: 20),
        _buildItemsTable(invoice, currencyFormat),
        pw.SizedBox(height: 20),
        _buildTotals(invoice, currencyFormat),
        pw.SizedBox(height: 30),
        _buildDirectorSignature(directorSignature),
        pw.SizedBox(height: 20),
        _buildTermsAndConditions(),
      ],
    );
    pdf.addPage(
      multiPage,
    );
    if (returnPage) {
      return multiPage;
    }
     else {
      return pdf.save();
    }
  }

  static Future<pw.MemoryImage> _loadLogoImage() async {
    try {
      // Load a placeholder logo - replace with your actual logo asset
      final ByteData data = await rootBundle.load('assets/logo.png');
      final Uint8List bytes = data.buffer.asUint8List();
      return pw.MemoryImage(bytes);
    } catch (e) {
      // If no logo is available, create a simple text placeholder
      // In a real app, you would use your actual logo
      print('Logo not found: $e');

      // Create a simple placeholder image
      final image = img.Image(width: 60, height: 60);

      final pngBytes = img.encodePng(image);
      return pw.MemoryImage(pngBytes);
    }
  }

  static pw.Widget _buildHeader(pw.MemoryImage logo, String companyName) {
    return pw.Row(
      mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
      children: [
        pw.Image(logo, width: 120, height: 60),
        pw.Column(
          crossAxisAlignment: pw.CrossAxisAlignment.end,
          children: [
            pw.Text(
              'PURCHASE ORDER',
              style: pw.TextStyle(
                fontSize: 24,
                fontWeight: pw.FontWeight.bold,
                color: PdfColors.blue800,
              ),
            ),
            pw.SizedBox(height: 5),
            pw.Text(
              companyName,
              style: pw.TextStyle(
                fontSize: 12,
                fontWeight: pw.FontWeight.bold,
              ),
            ),
          ],
        ),
      ],
    );
  }

  static pw.Widget _buildCompanyInfo(
      String address, String phone, String email) {
    return pw.Container(
      padding: const pw.EdgeInsets.all(15),
      decoration: pw.BoxDecoration(
        border: pw.Border.all(color: PdfColors.grey300, width: 1),
        borderRadius: pw.BorderRadius.circular(5),
      ),
      child: pw.Row(
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: [
          pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              pw.Text('Alamat:',
                  style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
              pw.Text(address),
              pw.SizedBox(height: 8),
              pw.Text('Telepon:',
                  style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
              pw.Text(phone),
            ],
          ),
          pw.SizedBox(width: 40),
          pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              pw.Text('Email:',
                  style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
              pw.Text(email),
              pw.SizedBox(height: 8),
              pw.Text('Website:',
                  style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
              pw.Text('www.bukuedukasi.com'),
            ],
          ),
        ],
      ),
    );
  }

  static pw.Widget _buildInvoiceInfo(Invoice invoice, DateFormat dateFormat) {
    return pw.Container(
      padding: const pw.EdgeInsets.all(15),
      decoration: pw.BoxDecoration(
        border: pw.Border.all(color: PdfColors.grey300, width: 1),
        borderRadius: pw.BorderRadius.circular(5),
      ),
      child: pw.Column(
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: [
          pw.Text(
            'INFORMASI PEMESANAN',
            style: pw.TextStyle(
              fontSize: 14,
              fontWeight: pw.FontWeight.bold,
              color: PdfColors.blue800,
            ),
          ),
          pw.SizedBox(height: 15),
          pw.Row(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              pw.Column(
                crossAxisAlignment: pw.CrossAxisAlignment.start,
                children: [
                  pw.Text('No. PO: ',
                      style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
                  pw.Text('Tanggal PO: ',
                      style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
                  pw.Text('Penerima: ',
                      style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
                  pw.Text('Sekolah: ',
                      style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
                  pw.Text('Alamat: ',
                      style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
                ],
              ),
              pw.SizedBox(width: 20),
              pw.Expanded(
                child: pw.Column(
                  crossAxisAlignment: pw.CrossAxisAlignment.start,
                  children: [
                    pw.Text('PO-${invoice.id}'),
                    pw.Text(dateFormat.format(invoice.date)),
                    pw.Text(
                        invoice.recipient.isNotEmpty ? invoice.recipient : '-'),
                    pw.Text(invoice.school.isNotEmpty ? invoice.school : '-'),
                    pw.Text(invoice.address.isNotEmpty ? invoice.address : '-'),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  static pw.Widget _buildItemsTable(
      Invoice invoice, NumberFormat currencyFormat) {
    return pw.Table(
      border: pw.TableBorder.all(color: PdfColors.grey300, width: 1),
      columnWidths: {
        0: const pw.FlexColumnWidth(1),
        1: const pw.FlexColumnWidth(3),
        2: const pw.FlexColumnWidth(1.5),
        3: const pw.FlexColumnWidth(1.5),
        4: const pw.FlexColumnWidth(1.5),
      },
      children: [
        // Table header
        pw.TableRow(
          decoration: pw.BoxDecoration(color: PdfColors.grey200),
          children: [
            pw.Padding(
              padding: const pw.EdgeInsets.all(8),
              child: pw.Text(
                'No',
                style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
                textAlign: pw.TextAlign.center,
              ),
            ),
            pw.Padding(
              padding: const pw.EdgeInsets.all(8),
              child: pw.Text(
                'Nama Buku',
                style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
              ),
            ),
            pw.Padding(
              padding: const pw.EdgeInsets.all(8),
              child: pw.Text(
                'Harga Satuan',
                style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
                textAlign: pw.TextAlign.right,
              ),
            ),
            pw.Padding(
              padding: const pw.EdgeInsets.all(8),
              child: pw.Text(
                'Qty',
                style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
                textAlign: pw.TextAlign.center,
              ),
            ),
            pw.Padding(
              padding: const pw.EdgeInsets.all(8),
              child: pw.Text(
                'Total',
                style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
                textAlign: pw.TextAlign.right,
              ),
            ),
          ],
        ),
        // Table items
        ...invoice.items.asMap().entries.map((entry) {
          int index = entry.key + 1;
          InvoiceItem item = entry.value;

          return pw.TableRow(
            children: [
              pw.Padding(
                padding: const pw.EdgeInsets.all(8),
                child: pw.Text(
                  index.toString(),
                  textAlign: pw.TextAlign.center,
                ),
              ),
              pw.Padding(
                padding: const pw.EdgeInsets.all(8),
                child: pw.Text(item.book.name),
              ),
              pw.Padding(
                padding: const pw.EdgeInsets.all(8),
                child: pw.Text(
                  currencyFormat.format(item.sellingPrice),
                  textAlign: pw.TextAlign.right,
                ),
              ),
              pw.Padding(
                padding: const pw.EdgeInsets.all(8),
                child: pw.Text(
                  item.quantity.toString(),
                  textAlign: pw.TextAlign.center,
                ),
              ),
              pw.Padding(
                padding: const pw.EdgeInsets.all(8),
                child: pw.Text(
                  currencyFormat.format(item.totalPrice),
                  textAlign: pw.TextAlign.right,
                ),
              ),
            ],
          );
        }).toList(),
      ],
    );
  }

  static pw.Widget _buildTotals(Invoice invoice, NumberFormat currencyFormat) {
    return pw.Container(
      alignment: pw.Alignment.centerRight,
      child: pw.Column(
        crossAxisAlignment: pw.CrossAxisAlignment.end,
        children: [
          pw.Row(
            mainAxisAlignment: pw.MainAxisAlignment.end,
            children: [
              pw.SizedBox(
                width: 150,
                child: pw.Text('Subtotal: ',
                    style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
              ),
              pw.SizedBox(width: 10),
              pw.SizedBox(
                width: 100,
                child: pw.Text(currencyFormat.format(invoice.subTotal),
                    textAlign: pw.TextAlign.right),
              ),
            ],
          ),
          pw.SizedBox(height: 5),
          pw.Row(
            mainAxisAlignment: pw.MainAxisAlignment.end,
            children: [
              pw.SizedBox(
                width: 150,
                child: pw.Text('Diskon (${invoice.discount}%): ',
                    style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
              ),
              pw.SizedBox(width: 10),
              pw.SizedBox(
                width: 100,
                child: pw.Text(currencyFormat.format(invoice.totalDiscount),
                    textAlign: pw.TextAlign.right),
              ),
            ],
          ),
          pw.SizedBox(height: 5),
          pw.Row(
            mainAxisAlignment: pw.MainAxisAlignment.end,
            children: [
              pw.SizedBox(
                width: 150,
                child: pw.Text('Pajak (${invoice.tax}%): ',
                    style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
              ),
              pw.SizedBox(width: 10),
              pw.SizedBox(
                width: 100,
                child: pw.Text(currencyFormat.format(invoice.totalTax),
                    textAlign: pw.TextAlign.right),
              ),
            ],
          ),
          pw.Divider(),
          pw.Row(
            mainAxisAlignment: pw.MainAxisAlignment.end,
            children: [
              pw.SizedBox(
                width: 150,
                child: pw.Text('TOTAL: ',
                    style: pw.TextStyle(
                        fontSize: 14, fontWeight: pw.FontWeight.bold)),
              ),
              pw.SizedBox(width: 10),
              pw.SizedBox(
                width: 100,
                child: pw.Text(
                  currencyFormat.format(invoice.total),
                  style: const pw.TextStyle(fontSize: 14),
                  textAlign: pw.TextAlign.right,
                ),
              ),
            ],
          ),
          pw.SizedBox(height: 10),
          pw.Row(
            mainAxisAlignment: pw.MainAxisAlignment.end,
            children: [
              pw.SizedBox(
                width: 150,
                child: pw.Text('DP: ',
                    style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
              ),
              pw.SizedBox(width: 10),
              pw.SizedBox(
                width: 100,
                child: pw.Text(currencyFormat.format(invoice.downPayment),
                    textAlign: pw.TextAlign.right),
              ),
            ],
          ),
          pw.SizedBox(height: 5),
          pw.Row(
            mainAxisAlignment: pw.MainAxisAlignment.end,
            children: [
              pw.SizedBox(
                width: 150,
                child: pw.Text('Sisa: ',
                    style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
              ),
              pw.SizedBox(width: 10),
              pw.SizedBox(
                width: 100,
                child: pw.Text(
                  currencyFormat.format(invoice.remainingPayment),
                  textAlign: pw.TextAlign.right,
                  style: pw.TextStyle(
                      color: invoice.remainingPayment > 0
                          ? PdfColors.red
                          : PdfColors.green),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  static pw.Widget _buildDirectorSignature(Uint8List? signatureImage) {
    return pw.Column(
      children: [
        pw.Row(
          mainAxisAlignment: pw.MainAxisAlignment.end,
          children: [
            pw.Column(
              children: [
                pw.Text(
                    'Jakarta, ${DateFormat('dd MMMM yyyy', 'id_ID').format(DateTime.now())}'),
                pw.SizedBox(height: 40),
                if (signatureImage != null)
                  pw.Image(pw.MemoryImage(signatureImage),
                      width: 150, height: 80)
                else
                  pw.Container(
                    width: 150,
                    height: 80,
                    decoration: pw.BoxDecoration(
                      border: pw.Border.all(color: PdfColors.grey),
                    ),
                    child: pw.Center(
                      child: pw.Text('Tanda Tangan Direktur',
                          style: const pw.TextStyle(fontSize: 10)),
                    ),
                  ),
                pw.SizedBox(height: 10),
                pw.Text(
                  '(_________________________)',
                  style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
                ),
                pw.Text(
                  'Direktur',
                  style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
                ),
                pw.Text('PT. BUKU EDUKASI INDONESIA'),
              ],
            ),
          ],
        ),
      ],
    );
  }

  static pw.Widget _buildTermsAndConditions() {
    return pw.Container(
      padding: const pw.EdgeInsets.all(15),
      decoration: pw.BoxDecoration(
        border: pw.Border.all(color: PdfColors.grey300, width: 1),
        borderRadius: pw.BorderRadius.circular(5),
      ),
      child: pw.Column(
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: [
          pw.Text(
            'SYARAT DAN KETENTUAN',
            style: pw.TextStyle(
              fontSize: 14,
              fontWeight: pw.FontWeight.bold,
              color: PdfColors.blue800,
            ),
          ),
          pw.SizedBox(height: 10),
          pw.Text('1. Pembayaran: 50% saat pemesanan, 50% saat pengiriman'),
          pw.Text('2. Waktu pengiriman: 7-14 hari kerja setelah konfirmasi PO'),
          pw.Text(
              '3. Garansi: Buku dapat ditukar dalam kondisi cacat produksi'),
          pw.Text(
              '4. Complain: Dilayani maksimal 3 hari setelah penerimaan barang'),
          pw.Text('5. PO ini berlaku selama 30 hari kalender'),
        ],
      ),
    );
  }
}
