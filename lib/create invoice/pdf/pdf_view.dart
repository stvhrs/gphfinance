import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:gphfinance/create%20invoice/pdf/create_alldocument.dart';
import 'package:gphfinance/create%20invoice/pdf/create_invoice_pdf.dart';
import 'package:gphfinance/create%20invoice/pdf/create_nota.dart';
import 'package:gphfinance/create%20invoice/pdf/create_po.dart';
import 'package:gphfinance/create%20invoice/pdf/create_surat_jalan.dart';
import 'package:gphfinance/create%20invoice/pdf/test.dart';
import 'package:gphfinance/model.dart';
import 'package:printing/printing.dart';

class PdfView extends StatefulWidget {
  final String documentType;
  final Invoice invoice;

  const PdfView({super.key, required this.documentType, required this.invoice});

  @override
  State<PdfView> createState() => _PdfViewState();
}

class _PdfViewState extends State<PdfView> {
   Uint8List? _cachedPdf;
  bool _shared = false; // supaya share hanya sekali

  void _showPrintedToast(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Document printed successfully')),
    );
  }

  Future<Uint8List> _generatePdf() async {
    if (_cachedPdf != null) return _cachedPdf!; // pakai cache

    Uint8List data;
    switch (widget.documentType) {
      case "Create Delivery Note":
        data = await DeliveryNotePdfGenerator.generateDeliveryNotePdf(widget.invoice);
         _sharePdf(data, widget.invoice.id.replaceAll("INV", "SJ"));
        break;

      case "Create Payment Receipt":
        data = await PaymentReceiptPdfGenerator.generatePaymentReceiptPdf(widget.invoice);
         _sharePdf(data, widget.invoice.id.replaceAll("INV", "NT"));
        break;

      case "Create PO":
        data = await PurchaseOrderPdfGenerator.generatePurchaseOrderPdf(widget.invoice);
         _sharePdf(data, widget.invoice.id.replaceAll("INV", "PO"));
        break;

      case "Create Invoice":
        data = await InvoicePdfService.generate(widget.invoice);
         _sharePdf(data, widget.invoice.id);
        break;

      default:
        data = await AllPDF.generateDocument(
          invoice: widget.invoice,
          type: DocumentType.allDocuments,
        );
         _sharePdf(data, widget.invoice.id);
        break;
    }

    // simpan cache
    _cachedPdf = data;

    // jalankan share hanya sekali
    if (!_shared) {
      _shared = true;
      // contoh: _sharePdf(data, widget.invoice.id);
    }

    return data;
  }

  void _sharePdf(Uint8List data, String filename) async {
    await Printing.sharePdf(bytes: data, filename: filename);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Theme(
        data: ThemeData(
          iconTheme: const IconThemeData(color: Colors.white),
          primaryColor: const Color.fromARGB(255, 59, 59, 65),
        ),
        child: PdfPreview(
          loadingWidget: const Text('Loading...'),
          onError: (context, error) => const Text('Error...'),
          maxPageWidth: 800,
          pdfFileName: widget.invoice.id,
          canDebug: false,
          allowSharing: false,
          build: (format) async => _generatePdf(),
          onPrinted: _showPrintedToast,
          canChangeOrientation: false,
          canChangePageFormat: false,
        ),
      ),
    );
  }
}