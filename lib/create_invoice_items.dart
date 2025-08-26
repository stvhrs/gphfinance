import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter/material.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gphfinance/helper/input_currency.dart';
import 'package:gphfinance/helper/rupiah_format.dart';
import 'package:provider/provider.dart';
import 'package:gphfinance/create_invoices_table.dart';
import 'package:gphfinance/model.dart';
import 'package:gphfinance/provider/provider_invoices_table.dart';
import 'package:drop_down_search_field/drop_down_search_field.dart';

class CreateInvoiceItems extends StatelessWidget {
  CreateInvoiceItems({super.key});
  final books = [
    Book(name: "Matematika Dasar", costPrice: 50000, sellingPrice: 75000),
    Book(name: "Bahasa Inggris", costPrice: 45000, sellingPrice: 68000),
    Book(name: "Pemrograman Koding", costPrice: 60000, sellingPrice: 90000),
  ];
  @override
  Widget build(BuildContext context) {
    final invoice = context.watch<Invoice>();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Invoice Details:',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        SizedBox(height: 10),
        DropDownSearchField(
          textFieldConfiguration: TextFieldConfiguration(
            autofocus: false,
            maxLines: 1,

            decoration: InputDecoration(
              prefixIcon: Icon(Icons.manage_search),
              labelText: "Tambahkan Buku",
              hintMaxLines: 1,
              border: OutlineInputBorder(),
            ),
          ),
          suggestionsCallback: (pattern) async {
            return books.where(
              (element) => element.name.toLowerCase().startsWith(pattern),
            );
          },
          itemBuilder: (context, Book suggestion) {
            return ListTile(
              leading: Icon(Icons.menu_book_rounded, color: suggestion.color),
              title: Text(suggestion.name),
              subtitle: Text('\$${suggestion.sellingPrice}'),
            );
          },
          onSuggestionSelected: (suggestion) {
            invoice.addItem(
              InvoiceItem(
                id: DateTime.now().millisecondsSinceEpoch.toString(),
                book: suggestion,
              ),
            );
          },
          displayAllSuggestionWhenTap: true,
          isMultiSelectDropdown: false,
        ),
        Column(
          children:
              invoice.items.map((item) {
                return Padding(
                  key: ValueKey(item.book.id),
                  padding: const EdgeInsets.only(top: 10),
                  child: Row(
                    children: [
                      Expanded(
                        flex: 6,

                        child: TextFormField(
                          enabled: false,
                          initialValue: item.book.name,
                          decoration: InputDecoration(
                            labelText: "Book Title",
                            // ignore: deprecated_member_use
                            fillColor: item.book.color.withOpacity(0.07),
                          ),
                        ),
                      ),
                      SizedBox(width: 10),
                      Expanded(
                        flex: 3,
                        child: TextFormField(
                          initialValue: Rupiah.toStringFormated(
                            item.sellingPrice.toDouble(),
                          ),

                          decoration: InputDecoration(
                            labelText: "Selling Price",

                            fillColor: item.book.color.withOpacity(0.07),
                          ),
                          inputFormatters: [
                            FilteringTextInputFormatter.digitsOnly,
                            CurrencyInputFormatter(),
                          ],
                          onChanged: (value) {
                            final val =
                                int.tryParse(
                                  Rupiah.toDouble(value).toString(),
                                ) ??
                                0;
                            log(val.toString());
                            item.updateSellingPrice(val);
                            invoice.refresh();
                          },
                        ),
                      ),
                      SizedBox(width: 10),

                      Expanded(
                        flex: 1,
                        child: TextFormField(
                          initialValue: item.quantity.toString(),
                          textAlign: TextAlign.center,

                          decoration: InputDecoration(
                            labelText: "Qty",
                            fillColor: item.book.color.withOpacity(0.07),
                          ),
                          inputFormatters: [
                            FilteringTextInputFormatter.digitsOnly,
                          ],
                          onChanged: (value) {
                            final val = int.tryParse(value) ?? 0;
                            item.updateQuantity(val);
                            invoice.refresh();
                          },
                        ),
                      ),
                      SizedBox(width: 10),

                      Expanded(
                        flex: 3,
                        child: TextFormField(
                          enabled: false,

                          decoration: InputDecoration(
                            fillColor: item.book.color.withOpacity(0.07),
                            labelText: Rupiah.toStringFormated(
                              item.totalPrice.toDouble(),
                            ),
                          ),

                          onChanged: (value) {},
                        ),
                      ),
                      IconButton(
                        icon: Icon(Icons.delete, color: Colors.red),
                        onPressed: () {
                          invoice.refresh();

                          invoice.removeItem(item.id);
                        },
                      ),
                    ],
                  ),
                );
              }).toList(),
        ),

        // Invoice Items List
      ],
    );
  }
}
