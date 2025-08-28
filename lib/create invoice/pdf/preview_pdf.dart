// lib/pages/invoice_preview_button.dart
import 'package:flutter/material.dart';
import 'package:gphfinance/create%20invoice/pdf/create_invoice_pdf.dart';
import 'package:gphfinance/create%20invoice/pdf/create_nota.dart';
import 'package:gphfinance/create%20invoice/pdf/create_po.dart';
import 'package:gphfinance/create%20invoice/pdf/create_surat_jalan.dart';
import 'package:printing/printing.dart';
import 'package:gphfinance/model.dart';

class InvoicePreviewButton extends StatelessWidget {
  final Invoice invoice;
  const InvoicePreviewButton({super.key, required this.invoice});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        ElevatedButton.icon(
          label: const Text('INV'),
          onPressed: () async {
            await Printing.layoutPdf(
                onLayout: (format) async =>
                   await InvoicePdfService.generate(invoice, companyName: 'GPH'));
           
          },
        ),
        ElevatedButton.icon(
          label: const Text('SJ'),
          onPressed: () async {
            await Printing.layoutPdf(
                onLayout: (format) async =>
                   await DeliveryNotePdfGenerator.generateDeliveryNotePdf(invoice,));
            // Printing.sharePdf(
            //     filename: invoice.id,
            //     bytes: await InvoicePdfService.generate(invoice,
            //         companyName: 'GPH'));
          },
        ),   ElevatedButton.icon(
          label: const Text('PO'),
          onPressed: () async {
            await Printing.layoutPdf(
                onLayout: (format) async =>
                   await PurchaseOrderPdfGenerator.generatePurchaseOrderPdf(invoice));
            // Printing.sharePdf(
            //     filename: invoice.id,
            //     bytes: await PurchaseOrderPdfGenerator.generatePurchaseOrderPdf(invoice,
            //         companyName: 'GPH'));
          },
        ),
         ElevatedButton.icon(
          label: const Text('NT'),
          onPressed: () async {
            await Printing.layoutPdf(
                onLayout: (format) async =>
                  await PaymentReceiptPdfGenerator.generatePaymentReceiptPdf(invoice));
            // Printing.sharePdf(
            //     filename: invoice.id,
            //     bytes: await  PaymentReceiptPdfGenerator.generatePaymentReceiptPdf(invoice,
            //         companyName: 'GPH'));
          },
        ),
      ],
    );
  }
}
