import 'dart:developer';

import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gphfinance/create%20invoice/button_pushfirebase_invoices.dart';
import 'package:gphfinance/create%20invoice/cerate_invoice_summary.dart';
import 'package:gphfinance/create%20invoice/create_invoice_customer.dart';
import 'package:gphfinance/create%20invoice/create_invoice_items.dart';
import 'package:gphfinance/helper/input_currency.dart';
import 'package:gphfinance/helper/rupiah_format.dart';
import 'package:gphfinance/main.dart';
import 'package:gphfinance/provider/provider_stream_inovices.dart';
import 'package:provider/provider.dart';
import 'package:gphfinance/create%20invoice/create_invoices_table.dart';
import 'package:gphfinance/model.dart';
import 'package:gphfinance/provider/provider_invoices_table.dart';
import 'package:drop_down_search_field/drop_down_search_field.dart';

class InoviceForm extends StatelessWidget {
  bool update;
  InoviceForm({required this.update});

  @override
  Widget build(BuildContext context) {
    var invoice = context.read<Invoice>();

    return ListView(
      children: [
        CreateInvoiceCustomer(),

        // Section: Add Books to Invoice

        SizedBox(height: 10),
        // Section: Invoice Details
        CreateInvoiceItems(),
        SizedBox(height: 10),
        // Invoice Summary
        CerateInvoiceSummary(),

        // Action Buttons
        SizedBox(height: 10),

        Row(
          children: [
            update
                ? ElevatedButton(
                    onPressed: () async {
                      try {
                        // Reference to the invoice in the Firebase Realtime Database
                        final invoiceRef =
                            FirebaseDatabase.instance.ref().child('invoices');
                        final Map<String, Object?> updatedDataTyped =
                            Map<String, Object?>.from(invoice.toJson());
                        // Update the data
                        await invoiceRef
                            .child(invoice.id)
                            .update(updatedDataTyped);
                        Navigator.of(context).pop();

                        print("Invoice updated successfully.");
                      } catch (e) {
                        print("Error updating invoice: $e");
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,
                    ),
                    child: Text('Edit Invoice'),
                  )
                : ElevatedButton(
                        onPressed: () async {
                          final invoiceProvider =
                              context.read<InvoicesTableProvider>();
                          final invoiceCopy = invoice.copy();
                          invoiceProvider.addInvoice(invoiceCopy);
                          invoice.resetCustomerInfo();
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.green,
                        ),
                        child: Text('Simpan Invoice'),
                      ),
            !update && isMobile ? PushInvoicesButton() : SizedBox()
          ],
        ),
      ],
    );
  }
}

class CreateInvoices extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          children: [
            Expanded(
              flex: 3,
              child: InoviceForm(
                update: false,
              ),
            ),
            isMobile
                ? SizedBox()
                : VerticalDivider(
                    width: 8,
                  ),
            isMobile
                ? SizedBox()
                : Expanded(flex: 3, child: CreateInvoicesTable()),
          ],
        ),
      ),
    );
  }
}
