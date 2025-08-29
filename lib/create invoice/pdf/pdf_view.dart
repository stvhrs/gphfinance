import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:gphfinance/create%20invoice/pdf/create_alldocument.dart';
import 'package:gphfinance/create%20invoice/pdf/create_invoice_pdf.dart';
import 'package:gphfinance/create%20invoice/pdf/create_nota.dart';
import 'package:gphfinance/create%20invoice/pdf/create_po.dart';
import 'package:gphfinance/create%20invoice/pdf/create_surat_jalan.dart';
import 'package:gphfinance/model.dart';
import 'package:printing/printing.dart';

class PdfView extends StatefulWidget {
  final String documentType;
  final Invoice invoice;

  const PdfView({super.key, required this.documentType, required this.invoice});

  @override
  State<PdfView> createState() => _TahunPrintState();
}

class _TahunPrintState extends State<PdfView> {
  void _showPrintedToast(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Document printed successfully'),
      ),
    );
  }

  void _showSharedToast(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Document shared successfully'),
      ),
    );
  }

  Future<Uint8List> _generatePdf() async {
    switch (widget.documentType) {
      case "Create Delivery Note":
        return await DeliveryNotePdfGenerator.generateDeliveryNotePdf(widget.invoice);
      case "Create Payment Receipt":
        return await PaymentReceiptPdfGenerator.generatePaymentReceiptPdf(widget.invoice);
      case "Create PO":
        return await PurchaseOrderPdfGenerator.generatePurchaseOrderPdf(widget.invoice);
      case "Create Invoice":
        return await InvoicePdfService.generate(widget.invoice);
      default:
        return await CombinedPdfGenerator.generateCombinedPdf(widget.invoice);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Theme(
        data: ThemeData(
          iconTheme: const IconThemeData(
            color: Colors.white,
          ),
          primaryColor: const Color.fromARGB(255, 59, 59, 65),
        ),
        child: PdfPreview(
                loadingWidget: const Text('Loading...'),
                onError: (context, error) => const Text('Error...'),
                maxPageWidth: 800,
                pdfFileName: widget.invoice.id,
                canDebug: false,
                allowSharing: false,
                build: (format)async{
                  switch (widget.documentType) {
      case "Create Delivery Note":
        return await DeliveryNotePdfGenerator.generateDeliveryNotePdf(widget.invoice);
      case "Create Payment Receipt":
        return await PaymentReceiptPdfGenerator.generatePaymentReceiptPdf(widget.invoice);
      case "Create PO":
        return await PurchaseOrderPdfGenerator.generatePurchaseOrderPdf(widget.invoice);
      case "Create Invoice":
        return await InvoicePdfService.generate(widget.invoice);
      default:
        return await CombinedPdfGenerator.generateCombinedPdf(widget.invoice);
    }
                },  // Use the generated Uint8List data
                onPrinted: _showPrintedToast,
                canChangeOrientation: false,
                canChangePageFormat: false,
              
          
        ),
      ),
    );
  }
}
