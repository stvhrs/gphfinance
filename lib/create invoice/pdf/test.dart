import 'dart:typed_data';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:pdf/pdf.dart';
import 'package:gphfinance/model.dart';
import 'package:gphfinance/helper/rupiah_format.dart';
import 'package:image/image.dart' as img;

enum DocumentType {
  invoice,
  nota,
  purchaseOrder,
  suratJalan,
  allDocuments, // Tambahkan enum untuk semua dokumen
}

class AllPDF {
  // Constants
  static const String _companyName = 'CV Gubuk Pustaka Harmoni';

  static const String _website = 'GUBUKPUSTAKAHARMONI.COM';
  static const String _email = 'cvgubukpustakaharmoni@gmail.com';
  static const String _bankAccount = '13800-2675-3595';
  static const String _directorName = 'Zulfikar Ali';
  static const String _directorPosition = 'Direktur';
  static const String _contactPhone = '0856 0172 1370';

  // Text Styles
  static final _textStyles = _TextStyles();
  static final _colors = _Colors();
  Future<Uint8List> generateAllDocuments(List<Invoice> invoices) async {
    final pdf = pw.Document();
    final fonts = await AllPDF._loadFonts();
    final dateFmt = DateFormat('dd MMM yyyy', 'id_ID');
    final logo =
        await AllPDF._loadImage('assets/logo.png', width: 35, height: 35);
    final mandiri =
        await AllPDF._loadImage('assets/mandiri.png', width: 120, height: 30);
    final ttd =
        await AllPDF._loadImage('assets/ttd.png', width: 120, height: 40);

    for (final invoice in invoices) {
      pdf.addPage(AllPDF._buildInvoicePage(
          invoice, dateFmt, fonts, logo, mandiri, ttd));
      pdf.addPage(AllPDF._buildNotaPage(invoice, dateFmt, fonts, logo, ttd,
          invoice.isPaid ? await AllPDF._loadLunasImage() : null));
      pdf.addPage(AllPDF._buildPurchaseOrderPage(
          invoice, dateFmt, fonts, logo, mandiri, ttd));
      pdf.addPage(
          AllPDF._buildSuratJalanPage(invoice, dateFmt, fonts, logo, ttd));
    }

    return await pdf.save();
  }

  // Main function to generate documents
  static Future<dynamic> generateDocument({
    required DocumentType type,
    required Invoice invoice,
    bool returnPage = false,
  }) async {
    final fonts = await _loadFonts();
    final dateFmt = DateFormat('dd MMM yyyy', 'id_ID');
    final logo = await _loadImage('assets/logo.png', width: 35, height: 35);
    final mandiri =
        await _loadImage('assets/mandiri.png', width: 120, height: 30);
    final ttd = await _loadImage('assets/ttd.png', width: 120, height: 40);
    final lunas = invoice.isPaid ? await _loadLunasImage() : null;

    final pdf = pw.Document();

    if (type == DocumentType.allDocuments) {
      // Generate semua dokumen dalam satu file PDF
      pdf.addPage(
          _buildInvoicePage(invoice, dateFmt, fonts, logo, mandiri, ttd));
      pdf.addPage(_buildNotaPage(invoice, dateFmt, fonts, logo, ttd, lunas));
      pdf.addPage(
          _buildPurchaseOrderPage(invoice, dateFmt, fonts, logo, mandiri, ttd));
      pdf.addPage(_buildSuratJalanPage(invoice, dateFmt, fonts, logo, ttd));
    } else {
      // Generate dokumen tunggal
      pw.MultiPage page;

      switch (type) {
        case DocumentType.invoice:
          page = _buildInvoicePage(invoice, dateFmt, fonts, logo, mandiri, ttd);
          break;
        case DocumentType.nota:
          page = _buildNotaPage(invoice, dateFmt, fonts, logo, ttd, lunas);
          break;
        case DocumentType.purchaseOrder:
          page = _buildPurchaseOrderPage(
              invoice, dateFmt, fonts, logo, mandiri, ttd);
          break;
        case DocumentType.suratJalan:
          page = _buildSuratJalanPage(invoice, dateFmt, fonts, logo, ttd);
          break;
        default:
          throw Exception('Unknown document type');
      }

      if (returnPage) {
        return page;
      }
      pdf.addPage(page);
    }

    return await pdf.save();
  }

  // Font loading
  static Future<Map<String, pw.Font>> _loadFonts() async {
    final fontData = await rootBundle.load('assets/Roboto-Regular.ttf');
    final fontDataBold = await rootBundle.load('assets/Roboto-Bold.ttf');

    return {
      'regular': pw.Font.ttf(fontData.buffer.asByteData()),
      'bold': pw.Font.ttf(fontDataBold.buffer.asByteData()),
    };
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

  static Future<pw.MemoryImage> _loadLunasImage() async {
    try {
      final ByteData data = await rootBundle.load('assets/lunas.png');
      final Uint8List bytes = data.buffer.asUint8List();
      return pw.MemoryImage(bytes);
    } catch (e) {
      print('Lunas image not found: $e');
      final image = img.Image(width: 60, height: 60);
      final pngBytes = img.encodePng(image);
      return pw.MemoryImage(pngBytes);
    }
  }

  // Page builders for each document type
  static pw.MultiPage _buildInvoicePage(
    Invoice invoice,
    DateFormat dateFmt,
    Map<String, pw.Font> fonts,
    pw.MemoryImage logo,
    pw.MemoryImage mandiri,
    pw.MemoryImage ttd,
  ) {
    return pw.MultiPage(
      theme: pw.ThemeData.withFont(
        base: fonts['regular']!,
        bold: fonts['bold']!,
        fontFallback: [fonts['bold']!],
      ),
      margin: const pw.EdgeInsets.symmetric(horizontal: 48, vertical: 48),
      build: (context) => [
        _buildHeader(logo, 'INVOICE'),
        pw.SizedBox(height: 24),
        _buildBillTo(invoice, dateFmt, 'Kepada:', 'No : ${invoice.id}'),
        pw.SizedBox(height: 18),
        _buildItemsTable(invoice, true),
        pw.SizedBox(height: 12),
        _buildTotals(invoice, mandiri),
        pw.SizedBox(height: 12),
        _buildFooter(ttd, _getInvoiceNotes()),
        pw.Divider(),
        _buildFooterNote(),
      ],
    );
  }

  static pw.MultiPage _buildNotaPage(
    Invoice invoice,
    DateFormat dateFmt,
    Map<String, pw.Font> fonts,
    pw.MemoryImage logo,
    pw.MemoryImage ttd,
    pw.MemoryImage? lunas,
  ) {
    return pw.MultiPage(
      theme: pw.ThemeData.withFont(
        base: fonts['regular']!,
        bold: fonts['bold']!,
        fontFallback: [fonts['bold']!],
      ),
      margin: const pw.EdgeInsets.symmetric(horizontal: 48, vertical: 48),
      build: (context) => [
        _buildHeader(logo, 'Nota Pembayaran'),
        pw.SizedBox(height: 24),
        _buildBillTo(invoice, dateFmt, 'Kepada:',
            'No : ${invoice.id.replaceAll("INV", "NT")}'),
        pw.SizedBox(height: 18),
        _buildItemsTable(invoice, true),
        pw.SizedBox(height: 12),
        _buildTotalsNota(invoice, lunas),
        pw.SizedBox(height: 48),
        _buildSignatureSection(ttd),
        pw.SizedBox(height: 18),
        _buildFooter(ttd, _getNotaNotes(), showSignature: false),
        pw.Divider(),
        _buildFooterNote(),
      ],
    );
  }

  static pw.MultiPage _buildPurchaseOrderPage(
    Invoice invoice,
    DateFormat dateFmt,
    Map<String, pw.Font> fonts,
    pw.MemoryImage logo,
    pw.MemoryImage mandiri,
    pw.MemoryImage ttd,
  ) {
    return pw.MultiPage(
      theme: pw.ThemeData.withFont(
        base: fonts['regular']!,
        bold: fonts['bold']!,
        fontFallback: [fonts['bold']!],
      ),
      margin: const pw.EdgeInsets.symmetric(horizontal: 48, vertical: 48),
      build: (context) => [
        _buildHeader(logo, 'Purchase Order'),
        pw.SizedBox(height: 24),
        _buildBillTo(invoice, dateFmt, 'Informasi Pemesanan:',
            'No : ${invoice.id.replaceAll("INV", "PO")}'),
        pw.SizedBox(height: 18),
        _buildItemsTable(invoice, true),
        pw.SizedBox(height: 12),
        _buildTotals(invoice, mandiri),
        pw.SizedBox(height: 48),
        _buildSignatureSection(ttd),
        pw.SizedBox(height: 18),
        _buildFooter(ttd, _getPONotes(), showSignature: false),
        pw.Divider(),
        _buildFooterNote(),
      ],
    );
  }

  static pw.MultiPage _buildSuratJalanPage(
    Invoice invoice,
    DateFormat dateFmt,
    Map<String, pw.Font> fonts,
    pw.MemoryImage logo,
    pw.MemoryImage ttd,
  ) {
    return pw.MultiPage(
      theme: pw.ThemeData.withFont(
        base: fonts['regular']!,
        bold: fonts['bold']!,
        fontFallback: [fonts['bold']!],
      ),
      margin: const pw.EdgeInsets.symmetric(horizontal: 48, vertical: 48),
      build: (context) => [
        _buildHeader(logo, 'SURAT JALAN'),
        pw.SizedBox(height: 24),
        _buildBillTo(invoice, dateFmt, 'Penerima:',
            'No : ${invoice.id.replaceAll("INV", "SJ")}'),
        pw.SizedBox(height: 18),
        _buildItemsTable(invoice, false),
        pw.SizedBox(height: 12),
        _buildJumlahBuku(invoice),
        pw.SizedBox(height: 96),
        _buildPlat(),
        pw.SizedBox(height: 64),
        _formTTD(),
        pw.SizedBox(height: 64),
        _buildFooter(ttd, _getSJNotes()),
        pw.Divider(),
        _buildFooterNote(),
      ],
    );
  }

  // Header Section
  static pw.Widget _buildHeader(pw.MemoryImage logo, String title) {
    return pw.Column(
      children: [
        pw.Row(crossAxisAlignment: pw.CrossAxisAlignment.center, children: [
          pw.Image(logo, width: 35, height: 35),
          pw.Container(
            padding: const pw.EdgeInsets.all(8),
            child: pw.Column(
                crossAxisAlignment: pw.CrossAxisAlignment.start,
                children: [
                  pw.Text(
                    _companyName,
                    style: _textStyles.xLargeBold
                        .copyWith(color: _colors.green800),
                  ),
                  pw.SizedBox(height: 2),
                  pw.Text(
                    "PENERBIT DAN PERCETAKAN",
                    style: _textStyles.small.copyWith(color: _colors.grey900),
                  ),
                ]),
          ),
          pw.Spacer(),
          pw.Text(
            title,
            style: _textStyles.title.copyWith(color: _colors.green800),
          ),
        ]),
        pw.Row(crossAxisAlignment: pw.CrossAxisAlignment.center, children: [
          pw.Container(width: 50, color: _colors.green800, height: 2),
          pw.Expanded(
            child: pw.Container(color: PdfColors.grey, height: 1.5),
          ),
          pw.Text(
            "   $_website",
            style: _textStyles.small.copyWith(color: _colors.grey900),
          ),
        ]),
      ],
    );
  }

  // Bill To Section
  static pw.Widget _buildBillTo(Invoice invoice, DateFormat dateFmt,
      String title, String documentNumber) {
    return pw.Container(
      padding: const pw.EdgeInsets.all(16),
      decoration: pw.BoxDecoration(
        borderRadius: pw.BorderRadius.circular(8),
        color: _colors.grey200,
      ),
      child: pw.Row(crossAxisAlignment: pw.CrossAxisAlignment.start, children: [
        pw.Expanded(
          child: pw.Column(
              crossAxisAlignment: pw.CrossAxisAlignment.start,
              children: [
                pw.Text(title, style: _textStyles.normal),
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
              ]),
        ),
        pw.Spacer(),
        pw.Column(crossAxisAlignment: pw.CrossAxisAlignment.start, children: [
          pw.Text(documentNumber, style: _textStyles.mediumBold),
          pw.SizedBox(height: 4),
          pw.Text(dateFmt.format(invoice.date), style: _textStyles.normal),
        ]),
      ]),
    );
  }

  // Items Table Section
  static pw.Widget _buildItemsTable(Invoice invoice, bool includePrices) {
    final headers = includePrices
        ? ['No', 'Judul Buku', 'Qty', 'Harga', 'Total']
        : ['No', 'Judul Buku', 'Qty'];

    final data = invoice.items.asMap().entries.map((entry) {
      final i = entry.key;
      final item = entry.value;

      if (includePrices) {
        return [
          (i + 1).toString(),
          item.book.name,
          item.quantity.toString(),
          Rupiah.toStringFormated(item.sellingPrice.toDouble()),
          Rupiah.toStringFormated(item.totalPrice.toDouble()),
        ];
      } else {
        return [
          (i + 1).toString(),
          item.book.name,
          item.quantity.toString(),
        ];
      }
    }).toList();

    return pw.Table.fromTextArray(
      headers: headers,
      data: data,
      headerStyle: _textStyles.smallBold.copyWith(color: _colors.white),
      headerDecoration: pw.BoxDecoration(color: _colors.green800),
      cellAlignments: includePrices
          ? {
              0: pw.Alignment.center,
              1: pw.Alignment.centerLeft,
              2: pw.Alignment.center,
              3: pw.Alignment.centerRight,
              4: pw.Alignment.centerRight,
            }
          : {
              0: pw.Alignment.center,
              1: pw.Alignment.centerLeft,
              2: pw.Alignment.center,
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

  // Totals Sections
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
        pw.Text(_companyName, style: _textStyles.small),
      ],
    );
  }

  static pw.Widget _buildTotalsNota(Invoice invoice, pw.MemoryImage? lunas) {
    return pw.Row(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        !invoice.isPaid ? pw.SizedBox() : pw.Image((lunas!), width: 150),
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
              _buildKeyValueRow(
                'Uang Muka / Di Bayar',
                '- ${Rupiah.toStringFormated(invoice.downPayment)}',
              ),
              pw.Divider(),
              pw.Container(
                padding: const pw.EdgeInsets.symmetric(horizontal: 6),
                height: 24,
                decoration: pw.BoxDecoration(color: _colors.green800),
                child: _buildKeyValueRowBold(
                  'Total',
                  Rupiah.toStringFormated(invoice.remainingPayment),
                  color: _colors.white,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  // Jumlah Buku Section
  static pw.Widget _buildJumlahBuku(Invoice invoice) {
    return pw.Row(
      crossAxisAlignment: pw.CrossAxisAlignment.end,
      children: [
        pw.Spacer(),
        pw.Container(
          width: 200,
          child: pw.Column(
            children: [
              _buildKeyValueRow('Jumlah Buku', invoice.totalBooks.toString()),
              pw.Divider(),
            ],
          ),
        ),
      ],
    );
  }

  // Plat Section (Custom)
  static pw.Widget _buildPlat() {
    return pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        _build('Tanggal Pengiriman  :  ', "_______________"),
        _build('Nomor Kendaraan     :  ', "_______________"),
      ],
    );
  }

  static pw.Widget _build(String label, String value) {
    return pw.Padding(
      padding: const pw.EdgeInsets.symmetric(vertical: 2),
      child: pw.Row(
        children: [
          pw.Text(label),
          pw.Text(value),
        ],
      ),
    );
  }

  static pw.Widget _formTTD() {
    return pw.Row(
      mainAxisAlignment: pw.MainAxisAlignment.spaceAround,
      children: [
        pw.Column(
          children: [
            pw.Text('Pengirim',
                style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
            pw.SizedBox(height: 60),
            pw.Text('(_________________________)'),
          ],
        ),
        pw.Column(
          children: [
            pw.Text('Sopir',
                style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
            pw.SizedBox(height: 60),
            pw.Text('(_________________________)'),
          ],
        ),
        pw.Column(
          children: [
            pw.Text('Penerima',
                style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
            pw.SizedBox(height: 60),
            pw.Text('(_________________________)'),
          ],
        ),
      ],
    );
  }

  // Signature Section
  static pw.Widget _buildSignatureSection(pw.MemoryImage ttd) {
    return pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        pw.Row(
          crossAxisAlignment: pw.CrossAxisAlignment.end,
          mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
          children: [
            pw.Column(
              crossAxisAlignment: pw.CrossAxisAlignment.start,
              children: [
                pw.Text('Hormat Kami,',
                    style: pw.TextStyle(
                        fontWeight: pw.FontWeight.bold, fontSize: 10)),
                pw.SizedBox(height: 2),
                pw.Text('CV Gubuk Pustaka Harmoni',
                    style: pw.TextStyle(fontSize: 10)),
                pw.Container(
                  width: 150,
                  child: pw.Column(
                    mainAxisAlignment: pw.MainAxisAlignment.end,
                    crossAxisAlignment: pw.CrossAxisAlignment.center,
                    children: [
                      pw.Image(ttd, width: 120, height: 40),
                      pw.Text(_directorName + ", " + _directorPosition,
                          style: _textStyles.mediumBold),
                    ],
                  ),
                  height: 80,
                  decoration: pw.BoxDecoration(
                    border: pw.Border(
                        bottom:
                            pw.BorderSide(width: 1, color: PdfColors.black)),
                  ),
                ),
                pw.SizedBox(height: 4),
                pw.Text('(tanda tangan)',
                    style: pw.TextStyle(
                        fontSize: 8, fontStyle: pw.FontStyle.italic)),
                pw.SizedBox(height: 20),
              ],
            ),
            pw.SizedBox(width: 60),
            pw.Column(
              crossAxisAlignment: pw.CrossAxisAlignment.start,
              children: [
                pw.Text('Tanda Tangan Pembeli,',
                    style: pw.TextStyle(
                        fontWeight: pw.FontWeight.bold, fontSize: 10)),
                pw.Container(
                  width: 150,
                  height: 80,
                  decoration: pw.BoxDecoration(
                    border: pw.Border(
                        bottom:
                            pw.BorderSide(width: 1, color: PdfColors.black)),
                  ),
                ),
                pw.SizedBox(height: 4),
                pw.Text('(tanda tangan)',
                    style: pw.TextStyle(
                        fontSize: 8, fontStyle: pw.FontStyle.italic)),
                pw.SizedBox(height: 20),
              ],
            ),
          ],
        ),
        pw.SizedBox(height: 20),
      ],
    );
  }

  // Footer Sections
  static pw.Widget _buildFooter(pw.MemoryImage ttd, List<String> notes,
      {bool showSignature = true}) {
    return pw.Row(
      crossAxisAlignment: pw.CrossAxisAlignment.end,
      children: [
        pw.Column(
          crossAxisAlignment: pw.CrossAxisAlignment.start,
          children: [
            pw.Text('Catatan:', style: _textStyles.smallBold),
            pw.SizedBox(height: 4),
            for (var note in notes)
              pw.Text('• $note', style: _textStyles.small),
            pw.SizedBox(height: 12),
          ],
        ),
        pw.Spacer(),
        if (showSignature)
          pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.center,
            children: [
              pw.Image(ttd, width: 120, height: 40),
              pw.Text(_directorName, style: _textStyles.mediumBold),
              pw.Text(_directorPosition, style: _textStyles.normalBold),
            ],
          ),
      ],
    );
  }

  // Notes for different document types
  static List<String> _getInvoiceNotes() {
    return [
      'Pembayaran harus diterima dalam waktu 30 hari setelah tanggal invoice.',
      'Harap simpan invoice ini sebagai bukti pembayaran.',
      'Pembayaran dianggap sah setelah dana diterima.',
    ];
  }

  static List<String> _getNotaNotes() {
    return [
      'Nota pembayaran ini merupakan bukti sah transaksi. Mohon simpan nota ini dengan baik untuk keperluan klaim atau penukaran.',
      'Pembayaran dianggap lunas setelah dana diterima penuh.',
      'Harga yang tertera pada nota sudah final dan termasuk PPN (jika ada).',
    ];
  }

  static List<String> _getPONotes() {
    return [
      'Pembayaran: 50% saat pemesanan, 50% saat pengiriman.',
      'PO ini berlaku selama 30 hari kalender.',
      'Garansi: Buku dapat ditukar dalam kondisi cacat produksi.',
    ];
  }

  static List<String> _getSJNotes() {
    return [
      'Mohon periksa kembali keadaan dan jumlah buku yang diterima.',
      'Barang yang sudah diterima tidak dapat dikembalikan',
    ];
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

  static pw.Widget _buildKeyValueRowBold(String key, String value,
      {PdfColor? color}) {
    return pw.Padding(
      padding: const pw.EdgeInsets.symmetric(vertical: 2),
      child: pw.Row(
        children: [
          pw.Expanded(
              child: pw.Text(key,
                  style: _textStyles.mediumBold.copyWith(color: color))),
          pw.Text(value, style: _textStyles.mediumBold.copyWith(color: color)),
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
                color: _colors.green800, fontWeight: pw.FontWeight.bold),
          ),
        ],
      ),
    );
  }
}

// Text Styles Helper Class
class _TextStyles {
  final pw.TextStyle small = pw.TextStyle(fontSize: 9);
  final pw.TextStyle smallBold =
      pw.TextStyle(fontSize: 9, fontWeight: pw.FontWeight.bold);
  final pw.TextStyle normal = pw.TextStyle(fontSize: 10);
  final pw.TextStyle normalBold =
      pw.TextStyle(fontSize: 10, fontWeight: pw.FontWeight.bold);
  final pw.TextStyle medium = pw.TextStyle(fontSize: 11);
  final pw.TextStyle mediumBold =
      pw.TextStyle(fontSize: 11, fontWeight: pw.FontWeight.bold);
  final pw.TextStyle large = pw.TextStyle(fontSize: 13);
  final pw.TextStyle largeBold =
      pw.TextStyle(fontSize: 13, fontWeight: pw.FontWeight.bold);
  final pw.TextStyle xLarge = pw.TextStyle(fontSize: 15);
  final pw.TextStyle xLargeBold =
      pw.TextStyle(fontSize: 15, fontWeight: pw.FontWeight.bold);
  final pw.TextStyle title =
      pw.TextStyle(fontSize: 23, fontWeight: pw.FontWeight.bold);
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
