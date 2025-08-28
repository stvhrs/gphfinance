// lib/pages/invoice_preview_button.dart
import 'package:flutter/material.dart';
import 'package:gphfinance/create%20invoice/create_pdf.dart';
import 'package:printing/printing.dart';
import 'package:gphfinance/model.dart';

class InvoicePreviewButton extends StatelessWidget {
  final Invoice invoice;
  const InvoicePreviewButton({super.key, required this.invoice});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton.icon(
      icon: const Icon(Icons.picture_as_pdf),
      label: const Text('Print Dokumen'),
      onPressed: () async {
        await Printing.layoutPdf(
          onLayout: (format) async => await InvoicePdfService.generate(invoice, companyName: 'GPH'),
        );
      },
    );
  }
}
