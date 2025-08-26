import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gphfinance/cerate_invoice_summary.dart';
import 'package:gphfinance/create_invoice_customer.dart';
import 'package:gphfinance/create_invoice_items.dart';
import 'package:gphfinance/helper/input_currency.dart';
import 'package:gphfinance/helper/rupiah_format.dart';
import 'package:provider/provider.dart';
import 'package:gphfinance/create_invoices_table.dart';
import 'package:gphfinance/model.dart';
import 'package:gphfinance/provider/provider_invoices_table.dart';
import 'package:drop_down_search_field/drop_down_search_field.dart';


class CreateInvoices extends StatelessWidget {
  
  final List<Book> availableBooks = [
    Book(name: "Matematika Dasar", costPrice: 50000, sellingPrice: 75000),
    Book(name: "Bahasa Inggris", costPrice: 45000, sellingPrice: 68000),
    Book(name: "Pemrograman Koding", costPrice: 60000, sellingPrice: 90000),
  ];
  @override
  Widget build(BuildContext context) {
    final invoice = context.watch<Invoice>();

    return Scaffold(
      appBar: AppBar(
        title: Text('Invoice Management'),
        backgroundColor: Colors.blue,
      ),
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
                        onPressed: () {
                          final invoiceProvider =
                              context.read<InvoicesTableProvider>();
                          final invoiceCopy = invoice.copy();
                          invoiceProvider.addInvoice(invoiceCopy);

                          // Show success message
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text('Invoice berhasil ditambahkan!'),
                              backgroundColor: Colors.green,
                            ),
                          );
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
            VerticalDivider(width: 8,)
            ,
            VerticalDivider(width: 8,)
,
            Expanded(flex: 3, child: CreateInvoicesTable()),
          ],
        ),
      ),
    );
  }

 
}
