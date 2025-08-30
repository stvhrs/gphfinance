import 'dart:typed_data';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:intl/intl.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:pdf/pdf.dart';
import 'package:gphfinance/model.dart';
import 'package:gphfinance/helper/rupiah_format.dart';
import 'package:image/image.dart' as img;

class PurchaseOrderPdfGenerator {
  // Constants
  
  static const String _companyName = 'CV Gubuk Pustaka Harmoni';
  static const String _companyAddress = 
      'Dusun 2, Pilangrejo, Kec. Gemolong,\nKabupaten Sragen Jawa Tengah 57274';
  static const String _companyPhone = '0812-3456-7890';
  static const String _website = 'GUBUKPUSTAKAHARMONI.COM';
  static const String _email = 'cvgubukpustakaharmoni@gmail.com';
  static const String _bankAccount = '13800-2675-3595';
  static const String _directorName = 'Zulfikar Ali';
  static const String _directorPosition = 'Director';
  static const String _contactPhone = '0856 0172 1370';

  // Text Styles
  static final _textStyles = _TextStyles();
  static final _colors = _Colors();

  // Font loading
  static Future<Map<String, pw.Font>> _loadFonts() async {
    final fontData = await rootBundle.load('assets/Roboto-Regular.ttf');
    final fontDataBold = await rootBundle.load('assets/Roboto-Bold.ttf');
    
    return {
      'regular': pw.Font.ttf(fontData.buffer.asByteData()),
      'bold': pw.Font.ttf(fontDataBold.buffer.asByteData()),
    };
  }

static pw.Widget _buildSignatureSection(pw.MemoryImage ttd) {
  return pw.Column(
    crossAxisAlignment: pw.CrossAxisAlignment.start,
    children: [
      // Bagian Hormat Kami (Pengirim)
      pw.Row(
        crossAxisAlignment: pw.CrossAxisAlignment.end,
        mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
        children: [
          
          // Kolom Penerima
          pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              pw.Text(
                'Pembeli,',
                style: pw.TextStyle(
                  fontWeight: pw.FontWeight.bold,
                  fontSize: 10,
                ),
              ),
            
                
              // Garis untuk tanda tangan penerima
              pw.Container(
                width: 150,
                height: 80,
                decoration: pw.BoxDecoration(
                  border: pw.Border(
                    bottom: pw.BorderSide(width: 1, color: PdfColors.black),
                  ),
                ),
              ),
              pw.SizedBox(height: 4),
              pw.Text(
                '(tanda tangan)',
                style: pw.TextStyle(
                  fontSize: 8,
                  fontStyle: pw.FontStyle.italic,
                ),
              ),
              pw.SizedBox(height: 20),
             
            ],
          ), pw.SizedBox(width: 60),
          // Kolom Pengirim
          pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              pw.Text(
                'Hormat Kami,',
                style: pw.TextStyle(
                  fontWeight: pw.FontWeight.bold,
                  fontSize: 10,
                ),
              ),
              pw.SizedBox(height: 2),
              pw.Text(
                'CV Gubuk Pustaka Harmoni',
                style: pw.TextStyle(
                  fontSize: 10,
                ),
              ),
             
              
            
              pw.Container(
                width: 150,child:
                 pw.Column(
          mainAxisAlignment: pw.MainAxisAlignment.end,crossAxisAlignment: pw.CrossAxisAlignment.center,
          children: [
            pw.Image(ttd, width: 120, height: 40),
            pw.Text(_directorName+", "+_directorPosition, style: _textStyles.mediumBold),
           
          ],
        ) ,
                height: 80,
                decoration: pw.BoxDecoration(
                  border: pw.Border(
                    bottom: pw.BorderSide(width: 1, color: PdfColors.black),
                  ),
                ),
              ),
              pw.SizedBox(height: 4),
              pw.Text(
                '(tanda tangan)',
                style: pw.TextStyle(
                  fontSize: 8,
                  fontStyle: pw.FontStyle.italic,
                ),
              ),
              pw.SizedBox(height: 20),
           
            ],
          ),
          
          // Spacer antara kolom pengirim dan penerima
         
        ],
      ),
      
      pw.SizedBox(height: 20),
    ],
  );
}
  // Image loading with fallback
  static Future<pw.MemoryImage> _loadImage(
    String assetPath, {
    int width = 60,
    int height = 60,
  }) async {
    try {
      final ByteData data = await rootBundle.load(assetPath);
      final Uint8List bytes = data.buffer.asUint8List();
      return pw.MemoryImage(bytes);
    } catch (e) {
      print('Image not found ($assetPath): $e');
      final image = img.Image(width: width, height: height);
      final pngBytes = img.encodePng(image);
      return pw.MemoryImage(pngBytes);
    }
  }

  static Future<dynamic> generatePurchaseOrderPdf(
    Invoice invoice, {
    bool returnPage = false,
  }) async {
    final pdf = pw.Document();
    final fonts = await _loadFonts();
    final dateFmt = DateFormat('dd MMM yyyy', 'id_ID');
    
    final logo = await _loadImage('assets/logo.png', width: 35, height: 35);
    final mandiri = await _loadImage('assets/mandiri.png', width: 120, height: 30);
    final ttd = await _loadImage('assets/ttd.png', width: 120, height: 40);

    final page = pw.MultiPage(
      theme: pw.ThemeData.withFont(
        base: fonts['regular']!,
        bold: fonts['bold']!,
        fontFallback: [fonts['bold']!],
      ),
      margin: const pw.EdgeInsets.symmetric(horizontal: 48, vertical: 48),
      build: (context) => [
        _buildHeader(logo),
        pw.SizedBox(height: 24),
        _buildBillTo(invoice, dateFmt),
        pw.SizedBox(height: 18),
        _buildItemsTable(invoice),
        pw.SizedBox(height: 12),
        _buildTotals(invoice, mandiri),
      
         pw.SizedBox(height: 48),
        _buildSignatureSection(ttd),
        pw.SizedBox(height: 18),
        _buildFooter(),
        pw.Divider(),
        _buildFooterNote(),
      ],
    );

    pdf.addPage(page);
    return returnPage ? page : await pdf.save();
  }

  // Header Section
  static pw.Widget _buildHeader(pw.MemoryImage logo) {
    return pw.Column(
      children: [
        pw.Row(
          crossAxisAlignment: pw.CrossAxisAlignment.center,
          children: [
            pw.Image(logo, width: 35, height: 35),
            pw.Container(
              padding: const pw.EdgeInsets.all(8),
              child: pw.Column(
                crossAxisAlignment: pw.CrossAxisAlignment.start,
                children: [
                  pw.Text(
                    _companyName,
                    style: _textStyles.xLargeBold.copyWith(color: _colors.green800),
                  ),
                  pw.SizedBox(height: 2),
                  pw.Text(
                    "PENERBIT DAN PERCETAKAN",
                    style: _textStyles.small.copyWith(color: _colors.grey900),
                  ),
                ],
              ),
            ),
            pw.Spacer(),
            pw.Text(
              'Purchase Order',
              style: _textStyles.title.copyWith(color: _colors.green800),
            ),
          ],
        ),
        pw.Row(
          crossAxisAlignment: pw.CrossAxisAlignment.center,
          children: [
            pw.Container(width: 50, color: _colors.green800, height: 2),
            pw.Expanded(
              child: pw.Container(color: PdfColors.grey, height: 1.5),
            ),
            pw.Text(
              "   $_website",
              style: _textStyles.small.copyWith(color: _colors.grey900),
            ),
          ],
        ),
      ],
    );
  }

  // Bill To Section
  static pw.Widget _buildBillTo(Invoice invoice, DateFormat dateFmt) {
    return pw.Container(
      padding: const pw.EdgeInsets.all(16),
      decoration: pw.BoxDecoration(
        borderRadius: pw.BorderRadius.circular(8),
        color: _colors.grey200,
      ),
      child: pw.Row(
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: [
          pw.Expanded(
            child: pw.Column(
              crossAxisAlignment: pw.CrossAxisAlignment.start,
              children: [
                pw.Text('Informasi Pemesanan:', style: _textStyles.normal),
                pw.SizedBox(height: 4),
                pw.Text(
                  invoice.school.isEmpty ? '-' : invoice.school,
                  style: _textStyles.largeBold,
                ),
                pw.SizedBox(height: 6),
                pw.Text(
                  invoice.recipient.isEmpty ? '-' : invoice.recipient,
                  style: _textStyles.small,
                ),
                pw.SizedBox(height: 2),
                pw.Text(
                  invoice.noHp.isEmpty ? '-' : invoice.noHp,
                  style: _textStyles.small,
                ),
                pw.SizedBox(height: 2),
                pw.Text(
                  invoice.address.isEmpty ? '-' : invoice.address,
                  style: _textStyles.small,
                ),
              ],
            ),
          ),
          pw.Spacer(),
          pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              pw.Text(
                'No : ${invoice.id.replaceAll("INV", "PO")}',
                style: _textStyles.mediumBold,
              ),
              pw.SizedBox(height: 4),
              pw.Text(
                dateFmt.format(invoice.date),
                style: _textStyles.normal,
              ),
            ],
          ),
        ],
      ),
    );
  }

  // Items Table Section
  static pw.Widget _buildItemsTable(Invoice invoice) {
    final headers = ['No', 'Judul Buku', 'Qty', 'Harga', 'Total'];
    final data = invoice.items.asMap().entries.map((entry) {
      final i = entry.key;
      final item = entry.value;
      return [
        (i + 1).toString(),
        item.book.name,
        item.quantity.toString(),
        Rupiah.toStringFormated(item.sellingPrice.toDouble()),
        Rupiah.toStringFormated(item.totalPrice.toDouble()),
      ];
    }).toList();

    return pw.Table.fromTextArray(
      headers: headers,
      data: data,
      headerStyle: _textStyles.smallBold.copyWith(color: _colors.white),
      headerDecoration: pw.BoxDecoration(color: _colors.green800),
      cellAlignments: {
        0: pw.Alignment.center,
        1: pw.Alignment.centerLeft,
        2: pw.Alignment.center,
        3: pw.Alignment.centerRight,
        4: pw.Alignment.centerRight,
      },
      cellStyle: _textStyles.small,
      headerHeight: 24,
      cellHeight: 24,
      cellDecoration: (index, data, rowNum) {
        return pw.BoxDecoration(
          color: rowNum.isOdd ? _colors.green100 : _colors.green50,
        );
      },
      border: null,
    );
  }

  // Totals Section
  static pw.Widget _buildTotals(Invoice invoice, pw.MemoryImage mandiri) {
    return pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        pw.Row(
          crossAxisAlignment: pw.CrossAxisAlignment.end,
          children: [
            pw.Container(
              alignment: pw.Alignment.center,
              padding: const pw.EdgeInsets.symmetric(horizontal: 6),
              height: 24,
              decoration: pw.BoxDecoration(color: _colors.green800),
              child: pw.Text(
                'Pembayaran',
                style: _textStyles.mediumBold.copyWith(color: _colors.white),
              ),
            ),
            pw.Spacer(),
            pw.Container(
              width: 200,
              child: pw.Column(
                children: [
                  _buildKeyValueRow(
                    'Subtotal',
                    Rupiah.toStringFormated(invoice.subTotal.toDouble()),
                  ),
                  _buildKeyValueRow(
                    'Diskon (${invoice.discount.toStringAsFixed(0)}%)',
                    '- ${Rupiah.toStringFormated(invoice.totalDiscount)}',
                  ),
                  _buildKeyValueRow(
                    'PPN (${invoice.tax.toStringAsFixed(0)}%)',
                    '+ ${Rupiah.toStringFormated(invoice.totalTax)}',
                  ),
                  pw.Divider(),
                  pw.Container(
                    padding: const pw.EdgeInsets.symmetric(horizontal: 6),
                    height: 24,
                    decoration: pw.BoxDecoration(color: _colors.green800),
                    child: _buildKeyValueRowBold(
                      'Total',
                      Rupiah.toStringFormated(invoice.total),
                      color: _colors.white,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        pw.SizedBox(height: 8),
        pw.Image(mandiri, width: 120, height: 30),
        _buildBankInfoRow('No Rekening  :  ', _bankAccount),
        pw.Text(
          "$_companyName",
          style: _textStyles.small,
        ),
      ],
    );
  }

  // Footer Section
  static pw.Widget _buildFooter() {
    return pw.Row(
      crossAxisAlignment: pw.CrossAxisAlignment.end,
      children: [
        pw.Column(
          crossAxisAlignment: pw.CrossAxisAlignment.start,
          children: [
            pw.Text('Catatan:', style: _textStyles.smallBold),
            pw.SizedBox(height: 4),
             pw.Text(
                '• Pembayaran: 50% saat pemesanan, 50% saat pengiriman.',
                style: _textStyles.small,
              ),
              pw.Text(
                '• PO ini berlaku selama 30 hari kalender.',
                style: _textStyles.small,
              ),
              pw.Text(
                '• PGaransi: Buku dapat ditukar dalam kondisi cacat produksi.',
                style: _textStyles.small,
              ),
            pw.SizedBox(height: 12),
          ],
        ),
        pw.Spacer(),
        
      ],
    );
  }

  // Footer Note
  static pw.Widget _buildFooterNote() {
    return pw.Row(
      children: [
        pw.Text(
          "Pilangrejo, Gemolong, Sragen Regency - $_website - $_email - $_contactPhone",
          style: _textStyles.small.copyWith(color: _colors.grey700),
        ),
      ],
    );
  }

  // Helper methods
  static pw.Widget _buildKeyValueRow(String key, String value) {
    return pw.Padding(
      padding: const pw.EdgeInsets.symmetric(vertical: 2),
      child: pw.Row(
        children: [
          pw.Expanded(child: pw.Text(key, style: _textStyles.small)),
          pw.Text(value, style: _textStyles.small),
        ],
      ),
    );
  }

  static pw.Widget _buildKeyValueRowBold(String key, String value, {PdfColor? color}) {
    return pw.Padding(
      padding: const pw.EdgeInsets.symmetric(vertical: 2),
      child: pw.Row(
        children: [
          pw.Expanded(
            child: pw.Text(
              key,
              style: _textStyles.mediumBold.copyWith(color: color),
            ),
          ),
          pw.Text(
            value,
            style: _textStyles.mediumBold.copyWith(color: color),
          ),
        ],
      ),
    );
  }

  static pw.Widget _buildBankInfoRow(String label, String value) {
    return pw.Padding(
      padding: const pw.EdgeInsets.symmetric(vertical: 2),
      child: pw.Row(
        children: [
          pw.Text(label, style: _textStyles.small),
          pw.Text(
            value,
            style: _textStyles.medium.copyWith(
              color: _colors.green800,
              fontWeight: pw.FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}

// Text Styles Helper Class
class _TextStyles {
  final pw.TextStyle small = pw.TextStyle(fontSize: 9);
  final pw.TextStyle smallBold = pw.TextStyle(fontSize: 9, fontWeight: pw.FontWeight.bold);
  final pw.TextStyle normal = pw.TextStyle(fontSize: 10);
  final pw.TextStyle normalBold = pw.TextStyle(fontSize: 10, fontWeight: pw.FontWeight.bold);
  final pw.TextStyle medium = pw.TextStyle(fontSize: 11);
  final pw.TextStyle mediumBold = pw.TextStyle(fontSize: 11, fontWeight: pw.FontWeight.bold);
  final pw.TextStyle large = pw.TextStyle(fontSize: 13);
  final pw.TextStyle largeBold = pw.TextStyle(fontSize: 13, fontWeight: pw.FontWeight.bold);
  final pw.TextStyle xLarge = pw.TextStyle(fontSize: 15);
  final pw.TextStyle xLargeBold = pw.TextStyle(fontSize: 15, fontWeight: pw.FontWeight.bold);
  final pw.TextStyle title = pw.TextStyle(fontSize: 23, fontWeight: pw.FontWeight.bold);
}

// Colors Helper Class
class _Colors {
  final PdfColor green800 = PdfColors.green800;
  final PdfColor green100 = PdfColors.green100;
  final PdfColor green50 = PdfColors.green50;
  final PdfColor grey200 = PdfColors.grey200;
  final PdfColor grey400 = PdfColors.grey400;
  final PdfColor grey700 = PdfColors.grey700;
  final PdfColor grey900 = PdfColors.grey900;
  final PdfColor white = PdfColors.white;
}