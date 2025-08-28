import 'dart:typed_data';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:intl/intl.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:pdf/pdf.dart';
import 'package:gphfinance/model.dart';
import 'package:gphfinance/helper/rupiah_format.dart';
import 'package:image/image.dart' as img;

class InvoicePdfService {
  // Define text style variables
  static final _textStyleSmall = pw.TextStyle(fontSize: 9);
  static final _textStyleSmallBold =
      pw.TextStyle(fontSize: 9, fontWeight: pw.FontWeight.bold);
  static final _textStyleNormal = pw.TextStyle(fontSize: 10);
  static final _textStyleNormalBold =
      pw.TextStyle(fontSize: 10, fontWeight: pw.FontWeight.bold);
  static final _textStyleMedium = pw.TextStyle(fontSize: 11);
  static final _textStyleMediumBold =
      pw.TextStyle(fontSize: 11, fontWeight: pw.FontWeight.bold);
  static final _textStyleLarge = pw.TextStyle(fontSize: 13);
  static final _textStyleLargeBold =
      pw.TextStyle(fontSize: 13, fontWeight: pw.FontWeight.bold);
  static final _textStyleXLarge = pw.TextStyle(fontSize: 15);
  static final _textStyleXLargeBold =
      pw.TextStyle(fontSize: 15, fontWeight: pw.FontWeight.bold);
  static final _textStyleTitle =
      pw.TextStyle(fontSize: 23, fontWeight: pw.FontWeight.bold);

  // Color variables
  static final _colorGreen800 = PdfColors.green800;
  static final _colorGreen100 = PdfColors.green100;
  static final _colorGreen50 = PdfColors.green50;
  static final _colorGrey200 = PdfColors.grey200;
  static final _colorGrey400 = PdfColors.grey400;
  static final _colorGrey700 = PdfColors.grey700;
  static final _colorGrey900 = PdfColors.grey900;
  static final _colorWhite = PdfColors.white;

  static Future<pw.MemoryImage> _loadLogoImage() async {
    try {
      final ByteData data = await rootBundle.load('assets/logo.png');
      final Uint8List bytes = data.buffer.asUint8List();
      return pw.MemoryImage(bytes);
    } catch (e) {
      print('Logo not found: $e');
      final image = img.Image(width: 60, height: 60);
      final pngBytes = img.encodePng(image);
      return pw.MemoryImage(pngBytes);
    }
  }

  static Future<pw.MemoryImage> _loadMandiriImage() async {
    try {
      final ByteData data = await rootBundle.load('assets/mandiri.png');
      final Uint8List bytes = data.buffer.asUint8List();
      return pw.MemoryImage(bytes);
    } catch (e) {
      print('Logo not found: $e');
      final image = img.Image(width: 120, height: 60);
      final pngBytes = img.encodePng(image);
      return pw.MemoryImage(pngBytes);
    }
  }

  static Future<pw.MemoryImage> _loadTtdImage() async {
    try {
      final ByteData data = await rootBundle.load('assets/ttd.png');
      final Uint8List bytes = data.buffer.asUint8List();
      return pw.MemoryImage(bytes);
    } catch (e) {
      print('Logo not found: $e');
      final image = img.Image(width: 120, height: 60);
      final pngBytes = img.encodePng(image);
      return pw.MemoryImage(pngBytes);
    }
  }

  static Future<dynamic> generate(Invoice invoice,
      {String companyName = 'Gubuk Pustaka Harmoni',
      bool returnPage = false,
      String companyAddress =
          'Dusun 2, Pilangrejo, Kec. Gemolong,\nKabupaten Sragen Jawa Tengah 57274',
      String companyPhone = '0812-3456-7890'}) async {
    final pdf = pw.Document();
    final fontData = await rootBundle.load('assets/Roboto-Regular.ttf');
    final fontData2 = await rootBundle.load('assets/Roboto-Bold.ttf');
    final customFont = pw.Font.ttf(fontData.buffer.asByteData());
    final customFont2 = pw.Font.ttf(fontData2.buffer.asByteData());
    final dateFmt = DateFormat('dd MMM yyyy', 'id_ID');
    var logo = await _loadLogoImage();
    var mandiri = await _loadMandiriImage();
    var ttd = await _loadTtdImage();

    pw.Widget buildHeader() {
      return pw.Column(children: [
        pw.Row(
          crossAxisAlignment: pw.CrossAxisAlignment.center,
          children: [
            pw.Image(logo, width: 35, height: 35),
            pw.Container(
              padding: const pw.EdgeInsets.all(8),
              decoration: pw.BoxDecoration(
                borderRadius: pw.BorderRadius.circular(8),
              ),
              child: pw.Column(
                crossAxisAlignment: pw.CrossAxisAlignment.start,
                children: [
                  pw.Text(companyName,
                      style:
                          _textStyleXLargeBold.copyWith(color: _colorGreen800)),
                  pw.SizedBox(height: 2),
                  pw.Text("PENERBIT DAN PERCETAKAN",
                      style: _textStyleSmall.copyWith(color: _colorGrey900)),
                ],
              ),
            ),
            pw.Spacer(),
            pw.Text('INVOICE',
                style: _textStyleTitle.copyWith(color: _colorGreen800)),
          ],
        ),
        pw.Row(crossAxisAlignment: pw.CrossAxisAlignment.center, children: [
          pw.Container(width: 50, color: _colorGreen800, height: 2),
          pw.Expanded(
            child: pw.Container(color: PdfColors.grey, height: 1.5),
          ),
          pw.Text("   GUBUKPUSTAKAHARMONI.COM",
              style: _textStyleSmall.copyWith(color: _colorGrey900))
        ]),
      ]);
    }

    pw.Widget buildBillTo() {
      return pw.Container(
        padding: const pw.EdgeInsets.all(16),
        decoration: pw.BoxDecoration(
          borderRadius: pw.BorderRadius.circular(8),
          color: _colorGrey200,
        ),
        child: pw.Row(
          crossAxisAlignment: pw.CrossAxisAlignment.start,
          children: [
            pw.Expanded(
              child: pw.Column(
                crossAxisAlignment: pw.CrossAxisAlignment.start,
                children: [
                  pw.Text('Kepada:', style: _textStyleNormal),
                  pw.SizedBox(height: 4),
                  pw.Text(invoice.school.isEmpty ? '-' : invoice.school,
                      style: _textStyleLargeBold),
                  pw.SizedBox(height: 6),
                  pw.Text(invoice.recipient.isEmpty ? '-' : invoice.recipient,
                      style: _textStyleSmall),
                  pw.SizedBox(height: 2),
                  pw.Text(invoice.noHp.isEmpty ? '-' : invoice.noHp,
                      style: _textStyleSmall),
                  pw.SizedBox(height: 2),
                  pw.Text(invoice.address.isEmpty ? '-' : invoice.address,
                      style: _textStyleSmall),
                ],
              ),
            ),
            pw.Spacer(),
            pw.Column(
              crossAxisAlignment: pw.CrossAxisAlignment.start,
              children: [
                pw.Text('Invoice no : ${invoice.id}',
                    style: _textStyleMediumBold),
                pw.SizedBox(height: 4),
                pw.Text(dateFmt.format(invoice.date), style: _textStyleNormal),
              ],
            ),
          ],
        ),
      );
    }

    pw.Widget buildItemsTable() {
      final headers = ['No', 'Judul Buku', 'Qty', 'Harga', 'Total'];
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
        headerStyle: _textStyleSmallBold.copyWith(color: _colorWhite),
        headerDecoration: pw.BoxDecoration(color: _colorGreen800),
        cellAlignments: {
          0: pw.Alignment.center,
          1: pw.Alignment.centerLeft,
          2: pw.Alignment.center,
          3: pw.Alignment.centerRight,
          4: pw.Alignment.centerRight,
        },
        cellStyle: _textStyleSmall,
        headerHeight: 24,
        cellHeight: 24,
        cellDecoration: (index, data, rowNum) {
          return pw.BoxDecoration(
              color: rowNum.isOdd ? _colorGreen100 : _colorGreen50);
        },
        border: null,
      );
    }

    pw.Widget buildTotals() {
      return pw.Column(
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: [
          pw.Row(crossAxisAlignment: pw.CrossAxisAlignment.end, children: [
            pw.Container(
                alignment: pw.Alignment.center,
                padding: pw.EdgeInsets.symmetric(horizontal: 6),
                height: 24,
                decoration: pw.BoxDecoration(color: _colorGreen800),
                child: pw.Text('Pembayaran',
                    style: _textStyleMediumBold.copyWith(color: _colorWhite))),
            pw.Spacer(),
            pw.Container(
              width: 200,
              child: pw.Column(
                children: [
                  _kv('Subtotal',
                      Rupiah.toStringFormated(invoice.subTotal.toDouble())),
                  _kv('Diskon (${invoice.discount.toStringAsFixed(0)}%)',
                      '- ${Rupiah.toStringFormated(invoice.totalDiscount)}'),
                  _kv('PPN (${invoice.tax.toStringAsFixed(0)}%)',
                      '+ ${Rupiah.toStringFormated(invoice.totalTax)}'),
                  pw.Divider(),
                  pw.Container(
                      padding: pw.EdgeInsets.symmetric(horizontal: 6),
                      height: 24,
                      decoration: pw.BoxDecoration(color: _colorGreen800),
                      child: _kvBold(
                          'Total', Rupiah.toStringFormated(invoice.total))),
                ],
              ),
            )
          ]),
          pw.SizedBox(height: 8),
          pw.Image(mandiri, width: 120, height: 30),
          _rek("No Rekening  :  ", "13800-2675-3595"),
          pw.Text("CV Gubuk Pustaka Harmoni", style: _textStyleSmall)
        ],
      );
    }

    pw.Widget buildFooter() {
      return pw.Row(crossAxisAlignment: pw.CrossAxisAlignment.end, children: [
        pw.Column(
          crossAxisAlignment: pw.CrossAxisAlignment.start,
          children: [
            pw.Text('Catatan:', style: _textStyleSmallBold),
            pw.SizedBox(height: 4),
            pw.Text(
                '• Pembayaran harus diterima dalam waktu 30 hari setelah tanggal invoice.',
                style: _textStyleSmall),
            pw.Text('• Harap simpan invoice ini sebagai bukti pembayaran.',
                style: _textStyleSmall),
            pw.Text('• Pembayaran dianggap sah setelah dana diterima.',
                style: _textStyleSmall),
            pw.SizedBox(height: 12),
          ],
        ),
        pw.Spacer(),
        pw.Column(crossAxisAlignment: pw.CrossAxisAlignment.center, children: [
          pw.Image(ttd, width: 120, height: 40),
          pw.Text('Zulfikar Ali', style: _textStyleMediumBold),
          pw.Text('Director', style: _textStyleNormalBold),
        ])
      ]);
    }

    var page = pw.MultiPage(
      theme: pw.ThemeData.withFont(
          bold: customFont2, base: customFont, fontFallback: [customFont2]),
      margin: const pw.EdgeInsets.symmetric(horizontal: 48, vertical: 48),
      build: (context) => [
        buildHeader(),
        pw.SizedBox(height: 24),
        buildBillTo(),
        pw.SizedBox(height: 18),
        buildItemsTable(),
        pw.SizedBox(height: 12),
        buildTotals(),
        pw.SizedBox(height: 12),
        buildFooter(),
        pw.Divider(),
        pw.Row(children: [
          pw.Text(
              "Pilangrejo, Gemolong, Sragen Regency - gubukpustakaharmoni.com - cvgubukpustakaharmoni@gmail.com - 0856 0172 1370",
              style: _textStyleSmall.copyWith(color: _colorGrey700))
        ]),
      ],
    );
    pdf.addPage(page);
    if (returnPage) {
      return page;
    } else {
      return pdf.save();
    }
  }

  // helpers
  static pw.Widget _kv(String k, String v) => pw.Padding(
        padding: const pw.EdgeInsets.symmetric(vertical: 2),
        child: pw.Row(
          children: [
            pw.Expanded(child: pw.Text(k, style: _textStyleSmall)),
            pw.Text(v, style: _textStyleSmall)
          ],
        ),
      );

  static pw.Widget _rek(String k, String v) => pw.Padding(
        padding: const pw.EdgeInsets.symmetric(vertical: 2),
        child: pw.Row(
          children: [
            pw.Text(k, style: _textStyleSmall),
            pw.Text(v,
                style: _textStyleMedium.copyWith(
                    color: _colorGreen800, fontWeight: pw.FontWeight.bold))
          ],
        ),
      );

  static pw.Widget _kvBold(String k, String v) => pw.Padding(
        padding: const pw.EdgeInsets.symmetric(vertical: 2),
        child: pw.Row(
          children: [
            pw.Expanded(
                child: pw.Text(k,
                    style: _textStyleMediumBold.copyWith(color: _colorWhite))),
            pw.Text(v,
                style: _textStyleMediumBold.copyWith(color: _colorWhite)),
          ],
        ),
      );

  static pw.Widget _kvColor(String k, String v, PdfColor color) => pw.Padding(
        padding: const pw.EdgeInsets.symmetric(vertical: 2),
        child: pw.Row(
          children: [
            pw.Expanded(
                child:
                    pw.Text(k, style: _textStyleSmall.copyWith(color: color))),
            pw.Text(v,
                style: _textStyleSmall.copyWith(
                    color: color, fontWeight: pw.FontWeight.bold)),
          ],
        ),
      );
}
