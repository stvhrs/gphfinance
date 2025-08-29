import 'package:flutter/material.dart';
import 'package:gphfinance/create%20invoice/pdf/create_invoice_pdf.dart';
import 'package:gphfinance/create%20invoice/pdf/create_nota.dart';
import 'package:gphfinance/create%20invoice/pdf/create_po.dart';
import 'package:gphfinance/create%20invoice/pdf/create_surat_jalan.dart';
import 'package:gphfinance/create%20invoice/pdf/pdf_view.dart';
import 'package:printing/printing.dart';
import 'package:gphfinance/model.dart';

class InvoicePreviewButton extends StatelessWidget {
  final Invoice invoice;
  const InvoicePreviewButton({super.key, required this.invoice});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        PopupMenuButton<String>(
          onSelected: (String result) async {
            // Handle the menu item selection
            print("Selected: $result");

            // Switch case to handle different PDF generation based on selection
             Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => PdfView(documentType: result,invoice: invoice,),
                ));
          },
          itemBuilder: (BuildContext context) => [
            // "Create Invoice" menu item
            PopupMenuItem<String>(
              value: "Create All Document",
              child: Row(
                children: [
                  Icon(Icons.folder, color: Colors.black),
                  SizedBox(width: 10),
                  Text("Create All Document"),
                ],
              ),
            ),
            PopupMenuItem<String>(
              value: "Create Invoice",
              child: Row(
                children: [
                  Icon(Icons.folder, color: Colors.black),
                  SizedBox(width: 10),
                  Text("Create Invoice"),
                ],
              ),
            ),
            // "Create PO" menu item
            PopupMenuItem<String>(
              value: "Create PO",
              child: Row(
                children: [
                  Icon(Icons.add, color: Colors.black),
                  SizedBox(width: 10),
                  Text("Create PO"),
                ],
              ),
            ),
            // "Create Payment Receipt" menu item
            PopupMenuItem<String>(
              value: "Create Payment Receipt",
              child: Row(
                children: [
                  Icon(Icons.payment, color: Colors.black),
                  SizedBox(width: 10),
                  Text("Create Payment Receipt"),
                ],
              ),
            ),
            // "Create Delivery Note" menu item
            PopupMenuItem<String>(
              value: "Create Delivery Note",
              child: Row(
                children: [
                  Icon(Icons.delivery_dining, color: Colors.black),
                  SizedBox(width: 10),
                  Text("Create Delivery Note"),
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }
}
