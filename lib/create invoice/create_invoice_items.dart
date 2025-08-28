import 'dart:developer';

import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter/material.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gphfinance/helper/input_currency.dart';
import 'package:gphfinance/helper/rupiah_format.dart';
import 'package:gphfinance/provider/provider_stream_books.dart';
import 'package:provider/provider.dart';
import 'package:gphfinance/create%20invoice/create_invoices_table.dart';
import 'package:gphfinance/model.dart';
import 'package:gphfinance/provider/provider_invoices_table.dart';
import 'package:drop_down_search_field/drop_down_search_field.dart';

class CreateInvoiceItems extends StatelessWidget {
  CreateInvoiceItems({super.key});

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
            // Mengambil snapshot dari path "books"
            DataSnapshot snapshot =
                await FirebaseDatabase.instance.ref().child("books").get();

            // Memeriksa apakah snapshot memiliki data
           
              // Mengonversi data ke Map
              Map<dynamic, dynamic> booksMap =
                  Map<dynamic, dynamic>.from(snapshot.value as Map);

              // Mengonversi Map menjadi List<Book>
              List<Book> books = booksMap.entries.map((entry) {
                // Mengambil key sebagai ID buku
                String bookId = entry.key as String;

                // Mengonversi value menjadi Map<String, dynamic>
                Map<String, dynamic> bookData =
                    Map<String, dynamic>.from(entry.value as Map);

                // Menambahkan ID ke data buku
                bookData['id'] = bookId;

                // Membuat objek Book dari data
                return Book.fromJson(bookData);
              }).toList();

              // Filter buku berdasarkan pola pencarian
              return books
                  .where((book) =>
                      book.name.toLowerCase().contains(pattern.toLowerCase()))
                  .toList();
          },
          itemBuilder: (context, Book suggestion) {
            return ListTile(
              leading: Icon(Icons.menu_book_rounded, color: suggestion.color),
              title: Text(suggestion.name),
              subtitle: Text('\$${suggestion.sellingPrice}'),
            );
          },
          onSuggestionSelected: (suggestion) {
            if (!invoice.items
                .map(
                  (e) => e.book.name,
                )
                .toList()
                .contains(suggestion.name)) {
              invoice.addItem(
                InvoiceItem(
                  id: suggestion.id,
                  book: suggestion,
                ),
              );
            }
          },
          displayAllSuggestionWhenTap: true,
          isMultiSelectDropdown: false,
        ),
        Column(
          children: invoice.items.map((item) {
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
                        final val = int.tryParse(
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
