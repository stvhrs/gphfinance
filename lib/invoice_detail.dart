import 'package:flutter/material.dart';
import 'package:gphfinance/helper/rupiah_format.dart';
import 'package:gphfinance/model.dart';

class InvoiceDetailsDialog extends StatelessWidget {
  final Invoice invoice;

  const InvoiceDetailsDialog({super.key, required this.invoice});

  @override
  Widget build(BuildContext context) {
    return Dialog(
      insetPadding: EdgeInsets.all(20),
      child: ConstrainedBox(
        constraints: BoxConstraints(maxWidth: 600),
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                // Header
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'INVOICE DETAILS',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.blue[800],
                      ),
                    ),
                    IconButton(
                      icon: Icon(Icons.close),
                      onPressed: () => Navigator.pop(context),
                    ),
                  ],
                ),
                Divider(thickness: 2),
                SizedBox(height: 16),

                // Invoice Information
                _buildSectionTitle('INVOICE INFORMATION'),
                _buildInfoRow('Invoice ID', invoice.id),
                _buildInfoRow('Date', invoice.displayDate),
                _buildInfoRow('Status', invoice.paid ? 'PAID' : 'UNPAID',
                    color: invoice.paid ? Colors.green : Colors.orange),
                SizedBox(height: 16),

                // Customer Information
                _buildSectionTitle('CUSTOMER INFORMATION'),
                _buildInfoRow('Recipient', invoice.recipient),
                _buildInfoRow('School', invoice.school),
                _buildInfoRow('Address', invoice.address),
                _buildInfoRow(
                    'Phone',
                    invoice.noHp.isNotEmpty
                        ? invoice.formattedPhoneNumber
                        : '-'),
                SizedBox(height: 16),

                // Items List
                _buildSectionTitle('ITEMS (${invoice.items.length})'),
                if (invoice.items.isEmpty)
                  Text('No items', style: TextStyle(color: Colors.grey))
                else
                  ...invoice.items.map((item) => _buildItemRow(item)).toList(),
                SizedBox(height: 16),

                // Financial Summary
                _buildSectionTitle('FINANCIAL SUMMARY'),
                _buildAmountRow('Subtotal', invoice.total),
                _buildAmountRow('Discount (${invoice.discount}%)', -invoice.totalDiscount),
                _buildAmountRow('After Discount', invoice.totalAfterDiscount),
                _buildAmountRow('Tax (${invoice.tax}%)', invoice.totalTax),
                Divider(thickness: 2),
                _buildAmountRow('TOTAL', invoice.total, isTotal: true),
                SizedBox(height: 8),
                _buildAmountRow('Down Payment', invoice.downPayment),
                _buildAmountRow('Remaining Payment', invoice.remainingPayment,
                    color: invoice.remainingPayment > 0
                        ? Colors.red
                        : Colors.green),
                SizedBox(height: 16),

                // Additional Information
                _buildSectionTitle('ADDITIONAL INFORMATION'),
                _buildInfoRow('Total Books', '${invoice.totalBooks} pcs'),
                _buildInfoRow('Total Cost Price', 'Rp${invoice.totalCostPrice}'),
                _buildInfoRow('Gross Profit', 'Rp${invoice.grossProfit.toStringAsFixed(0)}',
                    color: invoice.grossProfit >= 0 ? Colors.green : Colors.red),
                _buildInfoRow('Database Date', invoice.databaseDate),
                _buildInfoRow('Customer Info Complete', invoice.hasCustomerInfo ? 'Yes' : 'No',
                    color: invoice.hasCustomerInfo ? Colors.green : Colors.orange),
                if (invoice.noHp.isNotEmpty)
                  _buildInfoRow('Phone Valid',
                      invoice.hasValidPhoneNumber ? 'Yes' : 'No',
                      color: invoice.hasValidPhoneNumber
                          ? Colors.green
                          : Colors.red),

                SizedBox(height: 24),

                // Action Buttons
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: Text('Close'),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // Helper Widget untuk membuat judul section
  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.bold,
        color: Colors.grey[700],
      ),
    );
  }

  // Helper Widget untuk menampilkan informasi
  Widget _buildInfoRow(String label, String value, {Color? color}) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 150,
            child: Text(
              '$label:',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
          SizedBox(width: 8),
          Expanded(
            child: Text(
              value,
              style: TextStyle(color: color),
            ),
          ),
        ],
      ),
    );
  }

  // Helper Widget untuk menampilkan amount
  Widget _buildAmountRow(String label, double amount,
      {bool isTotal = false, Color? color}) {
    final amountText = Rupiah.toStringFormated(amount);
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(
              fontWeight: isTotal ? FontWeight.bold : FontWeight.normal,
            ),
          ),
          Text(
            amountText,
            style: TextStyle(
              fontWeight: isTotal ? FontWeight.bold : FontWeight.normal,
              color: color ?? (amount < 0 ? Colors.red : null),
              fontSize: isTotal ? 16 : null,
            ),
          ),
        ],
      ),
    );
  }

  // Helper Widget untuk menampilkan item
  Widget _buildItemRow(InvoiceItem item) {
    return Card(
      margin: EdgeInsets.symmetric(vertical: 4),
      child: Padding(
        padding: EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              item.book.name,
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 4),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Qty: ${item.quantity}'),
                Text('Price: Rp${item.sellingPrice}'),
                Text('Total: Rp${item.totalPrice}'),
              ],
            ),
            SizedBox(height: 4),
            Text(
              'Cost: Rp${item.book.costPrice} each',
              style: TextStyle(color: Colors.grey[600], fontSize: 12),
            ),
          ],
        ),
      ),
    );
  }
}
