import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gphfinance/create%20invoice/cerate_invoice_summary.dart';
import 'package:gphfinance/create%20invoice/create_invoice_customer.dart';
import 'package:gphfinance/create%20invoice/create_invoice_items.dart';
import 'package:gphfinance/helper/input_currency.dart';
import 'package:gphfinance/helper/rupiah_format.dart';
import 'package:gphfinance/provider/provider_stream_inovices.dart';
import 'package:provider/provider.dart';
import 'package:gphfinance/create%20invoice/create_invoices_table.dart';
import 'package:gphfinance/model.dart';
import 'package:gphfinance/provider/provider_invoices_table.dart';
import 'package:drop_down_search_field/drop_down_search_field.dart';

class CreateInvoices extends StatelessWidget {
  
  @override
  Widget build(BuildContext context) {
    final invoice = context.watch<Invoice>();

    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          children: [
            Expanded(
              flex: 3,
              child: ListView(
                children: [
                  // Customer Information Section
                  // Customer Information Section + Diskon + PPN + Bayar
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
                      ElevatedButton(
                        onPressed: () async{
                           final stream =
                              context.read<ProviderStreamInovices>().invoices.length;
                          final invoiceProvider =
                              context.read<InvoicesTableProvider>();
                          final invoiceCopy =  invoice.copy();
                          invoiceProvider.addInvoice(invoiceCopy);
                          invoice.resetCustomerInfo();
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.green,
                        ),
                        child: Text('Simpan Invoice'),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            VerticalDivider(
              width: 8,
            ),
            VerticalDivider(
              width: 8,
            ),
            Expanded(flex: 3, child: CreateInvoicesTable()),
          ],
        ),
      ),
    );
  }
}
