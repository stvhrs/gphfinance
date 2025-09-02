import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gphfinance/helper/input_currency.dart';
import 'package:gphfinance/helper/rupiah_format.dart';
import 'package:provider/provider.dart';
import 'package:gphfinance/model.dart';
import 'package:gphfinance/provider/provider_invoices_table.dart';

class CreateInvoiceCustomer extends StatelessWidget {
  const CreateInvoiceCustomer({super.key});

  @override
  Widget build(BuildContext context) {
    final invoice = context.watch<Invoice>();
    final isMobile = MediaQuery.of(context).size.width < 600;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (isMobile)
          _buildMobileLayout(invoice)
        else
          _buildDesktopLayout(invoice),
      ],
    );
  }

  Widget _buildDesktopLayout(Invoice invoice) {
    return Column(
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
            SizedBox(width: 10),
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
            SizedBox(width: 10),
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
            SizedBox(width: 10),
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
        SizedBox(height: 10),
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
            SizedBox(width: 10),
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
            SizedBox(width: 10),
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
            SizedBox(width: 10),
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

  Widget _buildMobileLayout(Invoice invoice) {
    return Column(
      children: [
        // Recipient Info Section
        TextFormField(
          controller: invoice.textEditingControllerRecipient,
          decoration: InputDecoration(
            labelText: 'Recipient Name',
            border: OutlineInputBorder(),
            prefixIcon: Icon(Icons.person),
          ),
          onChanged: (value) => invoice.updateRecipient(value),
        ),
        SizedBox(height: 10),
        TextFormField(
          controller: invoice.textEditingControllerSchool,
          decoration: InputDecoration(
            labelText: 'School',
            border: OutlineInputBorder(),
            prefixIcon: Icon(Icons.school),
          ),
          onChanged: (value) => invoice.updateSchool(value),
        ),
        SizedBox(height: 10),
        TextFormField(
          controller: invoice.textEditingControllerAdreess,
          decoration: InputDecoration(
            labelText: 'Address',
            border: OutlineInputBorder(),
            prefixIcon: Icon(Icons.location_on),
          ),
          onChanged: (value) => invoice.updateAddress(value),
        ),
        SizedBox(height: 10),
        TextFormField(
          controller: invoice.textEditingControllerNoHp,
          decoration: InputDecoration(
            labelText: 'Phone',
            border: OutlineInputBorder(),
            prefixIcon: Icon(Icons.phone),
          ),
          onChanged: (value) => invoice.updatePhoneNumber(value),
        ),
        
        SizedBox(height: 20),
        
        // Financial Section
        TextFormField(
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
        SizedBox(height: 10),
        TextFormField(
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
        SizedBox(height: 10),
        TextFormField(
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
        SizedBox(height: 10),
        TextFormField(
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
      ],
    );
  }
}