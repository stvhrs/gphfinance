import 'package:flutter/material.dart';
import 'package:gphfinance/model.dart';
import 'package:provider/provider.dart';

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
            children: [Text('Subtotal:'), Text('Rp${invoice.subTotal}')],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Diskon (${invoice.discount}%):'),
              Text('-Rp${invoice.totalDiscount.toStringAsFixed(0)}'),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('PPN (${invoice.tax}%):'),
              Text('+Rp${invoice.totalTax.toStringAsFixed(0)}'),
            ],
          ),
          Divider(),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Total:', style: TextStyle(fontWeight: FontWeight.bold)),
              Text(
                'Rp${invoice.total.toStringAsFixed(0)}',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Down Payment:'),
              Text('Rp${invoice.downPayment.toStringAsFixed(0)}'),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Kekurangan:'),
              Text(
                'Rp${invoice.remainingPayment.toStringAsFixed(0)}',
                style: TextStyle(
                  color:
                      invoice.remainingPayment > 0 ? Colors.red : Colors.green,
                ),
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Status:'),
              Text(
                invoice.paid ? 'LUNAS' : 'BELUM LUNAS',
                style: TextStyle(
                  color: invoice.paid ? Colors.green : Colors.orange,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
