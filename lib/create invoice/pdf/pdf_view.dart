import 'package:flutter/material.dart';
import 'package:gphfinance/create%20invoice/pdf/create_alldocument.dart';
import 'package:gphfinance/create%20invoice/pdf/create_invoice_pdf.dart';
import 'package:gphfinance/model.dart';

import 'package:printing/printing.dart';

class PdfView extends StatefulWidget {
  // final Invoice invoice;

  // const PdfView(
  //   this.invoice,
  // );

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

  @override
  Widget build(BuildContext context) {
    var invoice = Invoice.fromJson({
      "address": "Jln Citrosancakan",
      "date": "2025-08-28T23:18:40.813",
      "discount": 0,
      "downPayment": 0,
      "id": "GPH-INV-20250828-0007",
      "items": [
        {
          "book": {
            "costPrice": 20000,
            "id": "book1",
            "name": "SD Koding Kelas 6 ",
            "sellingPrice": 40000
          },
          "id": "1756397950927",
          "quantity": 2,
          "sellingPrice": 40000
        }, {
          "book": {
            "costPrice": 20000,
            "id": "book1",
            "name": "SD Koding Kelas 6 ",
            "sellingPrice": 40000
          },
          "id": "1756397950927",
          "quantity": 2,
          "sellingPrice": 400000000
        }
      ],
      "paid": false,
      "recipient": "Steve Harris, AMD",
      "school": "SMP KEREN 02",
      "noHp": "0815172137123",
      "tax": 11
    });
    return Scaffold(
      body: Theme(
        data: ThemeData(
            iconTheme: const IconThemeData(
              color: Colors.white,
            ),
            primaryColor: const Color.fromARGB(255, 59, 59, 65)),
        child: PdfPreview(
          loadingWidget: const Text('Loading...'),
          onError: (context, error) => const Text('Error...'),
          maxPageWidth: 800,
          pdfFileName: invoice.id,
          canDebug: false,allowSharing: false,
          build: (format) => CombinedPdfGenerator.generateCombinedPdf(invoice),
          onPrinted: _showPrintedToast,
          canChangeOrientation: false,
          canChangePageFormat: false,
          // onShared: _showSharedToast,
        ),
      ),
    );
  }
}
