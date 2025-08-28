import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:gphfinance/model.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';

import 'dart:io';

class DeliveryNotePdfGenerator {
  static Future<dynamic> generateDeliveryNotePdf(Invoice invoice,
      {String companyName = 'STUDIO SHODWE',
      bool returnPage = false,
      String companyAddress = 'Jl. Contoh No. 1, Jakarta',
      String companyPhone = '0812-3456-7890'}) async {
    final pdf = pw.Document();
    final dateFormat = DateFormat('dd MMMM yyyy', 'id_ID');

    var multiPage = pw.MultiPage(
      pageFormat: PdfPageFormat.a4,
      margin: const pw.EdgeInsets.all(40),
      build: (context) => [
        _buildHeader(),
        pw.SizedBox(height: 30),
        _buildInvoiceInfo(invoice, dateFormat),
        pw.SizedBox(height: 20),
        _buildItemsTable(invoice),
        pw.SizedBox(height: 30),
        _buildDeliveryInfo(),
        pw.SizedBox(height: 30),
        _buildSignatures(),
        pw.SizedBox(height: 20),
        _buildFooterNote(),
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

  static pw.Widget _buildHeader() {
    return pw.Column(
      children: [
        pw.Text(
          'SURAT JALAN',
          style: pw.TextStyle(
            fontSize: 24,
            fontWeight: pw.FontWeight.bold,
            color: PdfColors.blue800,
          ),
        ),
        pw.SizedBox(height: 10),
        pw.Divider(thickness: 2, color: PdfColors.blue800),
      ],
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
            'INFORMASI PENGIRIMAN',
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
                  pw.Text('No. Invoice: ',
                      style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
                  pw.Text('Tanggal: ',
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
                    pw.Text(invoice.id),
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

  static pw.Widget _buildItemsTable(Invoice invoice) {
    return pw.Table(
      border: pw.TableBorder.all(color: PdfColors.grey300, width: 1),
      columnWidths: {
        0: const pw.FlexColumnWidth(1),
        1: const pw.FlexColumnWidth(4),
        2: const pw.FlexColumnWidth(1),
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
                'Qty',
                style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
                textAlign: pw.TextAlign.center,
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
                  item.quantity.toString(),
                  textAlign: pw.TextAlign.center,
                ),
              ),
            ],
          );
        }).toList(),
        // Total row
        pw.TableRow(
          decoration: pw.BoxDecoration(color: PdfColors.grey100),
          children: [
            pw.Padding(
              padding: const pw.EdgeInsets.all(8),
              child: pw.Text(''),
            ),
            pw.Padding(
              padding: const pw.EdgeInsets.all(8),
              child: pw.Text(
                'TOTAL',
                style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
              ),
            ),
            pw.Padding(
              padding: const pw.EdgeInsets.all(8),
              child: pw.Text(
                invoice.totalBooks.toString(),
                style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
                textAlign: pw.TextAlign.center,
              ),
            ),
          ],
        ),
      ],
    );
  }

  static pw.Widget _buildDeliveryInfo() {
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
            'INFORMASI PENGIRIMAN',
            style: pw.TextStyle(
              fontSize: 14,
              fontWeight: pw.FontWeight.bold,
              color: PdfColors.blue800,
            ),
          ),
          pw.SizedBox(height: 15),
          pw.Row(
            children: [
              pw.Column(
                crossAxisAlignment: pw.CrossAxisAlignment.start,
                children: [
                  pw.Text('Tanggal Pengiriman :',
                      style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
                  pw.SizedBox(height: 10),
                  pw.Text('Nomor Kendaraan   :',
                      style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
                  pw.SizedBox(height: 10),
                  pw.Text('Nama Sopir           :',
                      style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
                ],
              ),
              pw.SizedBox(width: 20),
              pw.Expanded(
                child: pw.Column(
                  crossAxisAlignment: pw.CrossAxisAlignment.start,
                  children: [
                    pw.Text('_________________________'),
                    pw.SizedBox(height: 10),
                    pw.Text('_________________________'),
                    pw.SizedBox(height: 10),
                    pw.Text('_________________________'),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  static pw.Widget _buildSignatures() {
    return pw.Row(
      mainAxisAlignment: pw.MainAxisAlignment.spaceAround,
      children: [
        pw.Column(
          children: [
            pw.Text('Pengirim',
                style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
            pw.SizedBox(height: 40),
            pw.Text('_________________________'),
            pw.SizedBox(height: 5),
            pw.Text('(_________________________)'),
          ],
        ),
        pw.Column(
          children: [
            pw.Text('Sopir',
                style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
            pw.SizedBox(height: 40),
            pw.Text('_________________________'),
            pw.SizedBox(height: 5),
            pw.Text('(_________________________)'),
          ],
        ),
        pw.Column(
          children: [
            pw.Text('Penerima',
                style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
            pw.SizedBox(height: 40),
            pw.Text('_________________________'),
            pw.SizedBox(height: 5),
            pw.Text('(_________________________)'),
          ],
        ),
      ],
    );
  }

  static pw.Widget _buildFooterNote() {
    return pw.Container(
      padding: const pw.EdgeInsets.all(15),
      decoration: pw.BoxDecoration(
        color: PdfColors.grey100,
        borderRadius: pw.BorderRadius.circular(5),
      ),
      child: pw.Column(
        children: [
          pw.Text(
            'Mohon periksa kembali keadaan dan jumlah buku yang diterima.',
            style: pw.TextStyle(
              fontSize: 12,
              fontStyle: pw.FontStyle.italic,
              color: PdfColors.red,
            ),
            textAlign: pw.TextAlign.center,
          ),
          pw.SizedBox(height: 10),
          pw.Text(
            'Barang yang sudah diterima tidak dapat dikembalikan',
            style: pw.TextStyle(
              fontSize: 10,
              fontStyle: pw.FontStyle.italic,
            ),
            textAlign: pw.TextAlign.center,
          ),
        ],
      ),
    );
  }
}
