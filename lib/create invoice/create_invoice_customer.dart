import 'package:flutter/material.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gphfinance/create%20invoice/create_invoice_items.dart';
import 'package:gphfinance/helper/input_currency.dart';
import 'package:gphfinance/helper/rupiah_format.dart';
import 'package:provider/provider.dart';
import 'package:gphfinance/create%20invoice/create_invoices_table.dart';
import 'package:gphfinance/model.dart';
import 'package:gphfinance/provider/provider_invoices_table.dart';
import 'package:drop_down_search_field/drop_down_search_field.dart';

class CreateInvoiceCustomer extends StatelessWidget {
  const CreateInvoiceCustomer({super.key});

  @override
  Widget build(BuildContext context) {
    final invoice = context.watch<Invoice>();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(
              child: TextFormField(
                controller: invoice.textEditingControllerRecipient,
                decoration: InputDecoration(
                  labelText: 'Recipient Name',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.person),
                ),
                onChanged: (value) => invoice.updateRecipient(value),
              ),
            ),
            SizedBox(
              width: 10,
            ),
            Expanded(
              child: TextFormField(
                controller: invoice.textEditingControllerSchool,
                decoration: InputDecoration(
                  labelText: 'School',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.school),
                ),
                onChanged: (value) => invoice.updateSchool(value),
              ),
            ),
            SizedBox(
              width: 10,
            ),
            Expanded(
              child: TextFormField(
                controller: invoice.textEditingControllerAdreess,
                decoration: InputDecoration(
                  labelText: 'Address',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.location_on),
                ),
                onChanged: (value) => invoice.updateAddress(value),
              ),
            ),
            SizedBox(
              width: 10,
            ),
            Expanded(
              child: TextFormField(
                controller: invoice.textEditingControllerNoHp,
                decoration: InputDecoration(
                  labelText: 'Phone',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.phone),
                ),
                onChanged: (value) => invoice.updatePhoneNumber(value),
              ),
            ),
          ],
        ),
        SizedBox(
          height: 10,
        ),
        Row(
          children: [
            Expanded(
              child: TextFormField(
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                decoration: InputDecoration(
                  labelText: 'Diskon (%)',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.discount),
                ),
                initialValue: invoice.discount.toString(),
                keyboardType: TextInputType.number,
                onChanged: (value) {
                  final val = double.tryParse(value) ?? 0;
                  invoice.updateDiscount(val);
                },
              ),
            ),
            SizedBox(
              width: 10,
            ),
            Expanded(
              child: TextFormField(
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                decoration: InputDecoration(
                  labelText: 'PPN (%)',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.receipt_long),
                ),
                initialValue: invoice.tax.toString(),
                keyboardType: TextInputType.number,
                onChanged: (value) {
                  final val = double.tryParse(value) ?? 0;
                  invoice.updateTax(val);
                },
              ),
            ),
            SizedBox(
              width: 10,
            ),
            Expanded(
              child: TextFormField(
                inputFormatters: [
                  FilteringTextInputFormatter.digitsOnly,
                  CurrencyInputFormatter(),
                ],
                decoration: InputDecoration(
                  labelText: 'Down Payment',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.payment),
                ),
                initialValue: invoice.downPayment.toString(),
                keyboardType: TextInputType.number,
                onChanged: (value) {
                  invoice.updateDownPayment(Rupiah.toDouble(value));
                },
              ),
            ),
            SizedBox(
              width: 10,
            ),
            Expanded(
              child: TextFormField(
                inputFormatters: [
                  FilteringTextInputFormatter.digitsOnly,
                  CurrencyInputFormatter(),
                ],
                decoration: InputDecoration(
                  labelText: 'Biaya Komisi',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.money_off_csred_rounded),
                ),
                initialValue: invoice.biayakomisi.toString(),
                keyboardType: TextInputType.number,
                onChanged: (value) {
                  invoice.updatebiayakomisi(Rupiah.toDouble(value));
                },
              ),
            ),
          ],
        ),
      ],
    );
  }
}
