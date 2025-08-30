import 'package:flutter/material.dart';
import 'package:gphfinance/model.dart';
import 'package:provider/provider.dart';
import 'package:gphfinance/helper/rupiah_format.dart'; // Import formatter

class CerateInvoiceSummary extends StatelessWidget {
  const CerateInvoiceSummary({super.key});

  @override
  Widget build(BuildContext context) {
    final invoice = context.watch<Invoice>();

    return Container(
      padding: EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.grey[200],
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Summary:',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Subtotal:'), 
              Text(Rupiah.toStringFormated(invoice.subTotal.toDouble()))
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Diskon (${invoice.discount}%):'),
              Text('-${Rupiah.toStringFormated(invoice.totalDiscount)}'),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('PPN (${invoice.tax}%):'),
              Text('+${Rupiah.toStringFormated(invoice.totalTax)}'),
            ],
          ),
          Divider(),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Total:', style: TextStyle(fontWeight: FontWeight.bold)),
              Text(
                Rupiah.toStringFormated(invoice.total.toDouble()),
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Down Payment:'),
              Text(Rupiah.toStringFormated(invoice.downPayment)),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Kekurangan:'),
              Text(
                Rupiah.toStringFormated(invoice.remainingPayment),
                style: TextStyle(
                  color: invoice.remainingPayment > 0 ? Colors.red : Colors.green,
                ),
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Status:'),
              Text(
                invoice.isPaid ? 'LUNAS' : 'BELUM LUNAS',
                style: TextStyle(
                  color: invoice.isPaid ? Colors.green : Colors.orange,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}