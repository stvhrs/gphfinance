import 'dart:typed_data';
import 'package:gphfinance/create%20invoice/pdf/create_invoice_pdf.dart';
import 'package:gphfinance/create%20invoice/pdf/create_nota.dart';
import 'package:gphfinance/create%20invoice/pdf/create_po.dart';
import 'package:gphfinance/create%20invoice/pdf/create_surat_jalan.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:pdf/pdf.dart';
import 'package:gphfinance/model.dart';
import 'package:intl/intl.dart';

class CombinedPdfGenerator {
  static Future<Uint8List> generateCombinedPdf(Invoice invoice) async {
    final pdf = pw.Document();

    // Generate PDF for Invoice
    pw.Page invoicePdf =
        await InvoicePdfService.generate(invoice, returnPage: true);

    // // Generate PDF for Purchase Order
    // pw.Page purchaseOrderPdf =
    //     await PurchaseOrderPdfGenerator.generatePurchaseOrderPdf(invoice, returnPage: true);

    // // Generate PDF for Payment Receipt
    // pw.Page paymentReceiptPdf =
    //     await PaymentReceiptPdfGenerator.generatePaymentReceiptPdf(invoice, returnPage: true);


    // // Generate PDF for Delivery Note
    // pw.Page deliveryNotePdf =
    //     await DeliveryNotePdfGenerator.generateDeliveryNotePdf(invoice, returnPage: true);

    // Add Invoice to the combined PDF
    pdf.addPage(invoicePdf);
    // pdf.addPage(purchaseOrderPdf);
    // pdf.addPage(paymentReceiptPdf);
    // pdf.addPage(deliveryNotePdf);


    return pdf.save(); // Return the combined PDF as Uint8List
  }
}
