import 'package:flutter/material.dart';
import 'package:gphfinance/model.dart';
import 'package:gphfinance/provider/provider_invoices_table.dart';
import 'package:provider/provider.dart';

class CreateInvoicesTable extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          // Summary Cards
          Consumer<InvoicesTableProvider>(
            builder: (context, InvoicesTableProvider, child) {
              return Padding(
                padding: const EdgeInsets.all(8.0),
                child: Wrap(
                  spacing: 12,
                  runSpacing: 12,
                  children: [
                    _buildSummaryCard(
                      'Total Sales',
                      'Rp${InvoicesTableProvider.totalSales.toStringAsFixed(0)}',
                      Colors.green,
                    ),
                    _buildSummaryCard(
                      'Total Cost',
                      'Rp${InvoicesTableProvider.totalCost.toStringAsFixed(0)}',
                      Colors.blue,
                    ),
                    _buildSummaryCard(
                      'Total Profit',
                      'Rp${InvoicesTableProvider.totalProfit.toStringAsFixed(0)}',
                      Colors.purple,
                    ),
                    _buildSummaryCard(
                      'Paid',
                      'Rp${InvoicesTableProvider.totalPaid.toStringAsFixed(0)}',
                      Colors.teal,
                    ),
                    _buildSummaryCard(
                      'Unpaid',
                      'Rp${InvoicesTableProvider.totalUnpaid.toStringAsFixed(0)}',
                      Colors.orange,
                    ),
                    _buildSummaryCard(
                      'Invoices',
                      '${InvoicesTableProvider.invoices.length} items',
                      Colors.indigo,
                    ),
                    _buildSummaryCard(
                      'Paid Invoices',
                      '${InvoicesTableProvider.paidInvoicesCount}',
                      Colors.green,
                    ),
                    _buildSummaryCard(
                      'Unpaid Invoices',
                      '${InvoicesTableProvider.unpaidInvoicesCount}',
                      Colors.red,
                    ),
                  ],
                ),
              );
            },
          ),

          Divider(),

          // Invoice Table
          Expanded(
            child: Consumer<InvoicesTableProvider>(
              builder: (context, InvoicesTableProvider, child) {
                if (InvoicesTableProvider.invoices.isEmpty) {
                  return Center(
                    child: Text(
                      'No invoices found',
                      style: TextStyle(fontSize: 18, color: Colors.grey),
                    ),
                  );
                }

                return SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: DataTable(
                    columnSpacing: 20,
                    columns: [
                      DataColumn(label: Text('ID')),
                      DataColumn(label: Text('Date')),
                      DataColumn(label: Text('School'), numeric: true),
                      DataColumn(label: Text('Items'), numeric: true),
                      DataColumn(label: Text('Subtotal'), numeric: true),
                      DataColumn(label: Text('Discount'), numeric: true),
                      DataColumn(label: Text('Tax'), numeric: true),
                      DataColumn(label: Text('Total'), numeric: true),
                      DataColumn(label: Text('Paid'), numeric: true),
                      DataColumn(label: Text('Status'), numeric: true),
                      DataColumn(label: Text('Actions'), numeric: true),
                    ],
                    rows:
                        InvoicesTableProvider.invoices.map((invoice) {
                          return DataRow(
                            cells: [
                              DataCell(
                                Tooltip(
                                  message: invoice.id,
                                  child: Text(invoice.id.substring(0, 8)),
                                ),
                              ),
                              DataCell(Text(invoice.displayDate)),
                              DataCell(
                                Text(
                                  invoice.recipient.isNotEmpty
                                      ? invoice.school
                                      : '-',
                                ),
                              ),
                              DataCell(Text('${invoice.items.fold(0,  (sum, item) => sum + item.quantity)}')),
                              DataCell(Text('Rp${invoice.subTotal}')),
                              DataCell(Text('${invoice.discount}%')),
                              DataCell(Text('${invoice.tax}%')),
                              DataCell(
                                Text(
                                  'Rp${invoice.total.toStringAsFixed(0)}',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.blue,
                                  ),
                                ),
                              ),
                              DataCell(
                                Text(
                                  'Rp${invoice.downPayment.toStringAsFixed(0)}',
                                  style: TextStyle(
                                    color:
                                        invoice.downPayment > 0
                                            ? Colors.green
                                            : Colors.grey,
                                  ),
                                ),
                              ),
                              DataCell(
                                Chip(
                                  label: Text(
                                    invoice.paid ? 'PAID' : 'UNPAID',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 12,
                                    ),
                                  ),
                                  backgroundColor:
                                      invoice.paid
                                          ? Colors.green
                                          : Colors.orange,
                                  padding: EdgeInsets.symmetric(
                                    horizontal: 8,
                                    vertical: 2,
                                  ),
                                ),
                              ),
                              DataCell(
                                Row(
                                  children: [
                                    IconButton(
                                      icon: Icon(Icons.visibility, size: 18),
                                      onPressed: () {
                                        _viewInvoiceDetails(context, invoice);
                                      },
                                    ),
                                    IconButton(
                                      icon: Icon(
                                        Icons.edit,
                                        size: 18,
                                        color: Colors.blue,
                                      ),
                                      onPressed: () {
                                        _editInvoice(context, invoice);
                                      },
                                    ),
                                    IconButton(
                                      icon: Icon(
                                        Icons.delete,
                                        size: 18,
                                        color: Colors.red,
                                      ),
                                      onPressed: () {
                                        _deleteInvoice(
                                          context,
                                          InvoicesTableProvider,
                                          invoice,
                                        );
                                      },
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          );
                        }).toList(),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSummaryCard(String title, String value, Color color) {
    return Card(
      color: color.withOpacity(0.1),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: TextStyle(
                fontSize: 12,
                color: color,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 4),
            Text(
              value,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: color,
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _viewInvoiceDetails(BuildContext context, Invoice invoice) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Invoice Details'),
          content: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('ID: ${invoice.id}'),
                Text('Date: ${invoice.displayDate}'),
                Text('Recipient: ${invoice.recipient}'),
                Text('School: ${invoice.school}'),
                Text('Address: ${invoice.address}'),
                Divider(),
                Text('Items: ${invoice.items.length}'),
                Text('Subtotal: Rp${invoice.subTotal}'),
                Text(
                  'Discount: ${invoice.discount}% (Rp${invoice.totalDiscount.toStringAsFixed(0)})',
                ),
                Text(
                  'Tax: ${invoice.tax}% (Rp${invoice.totalTax.toStringAsFixed(0)})',
                ),
                Text('Total: Rp${invoice.total.toStringAsFixed(0)}'),
                Text('Paid: Rp${invoice.downPayment.toStringAsFixed(0)}'),
                Text(
                  'Remaining: Rp${invoice.remainingPayment.toStringAsFixed(0)}',
                ),
                Text('Status: ${invoice.paid ? 'PAID' : 'UNPAID'}'),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text('Close'),
            ),
          ],
        );
      },
    );
  }

  void _editInvoice(BuildContext context, Invoice invoice) {
    // Navigate to edit invoice screen
  }

  void _deleteInvoice(
    BuildContext context,
    InvoicesTableProvider InvoicesTableProvider,
    Invoice invoice,
  ) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Delete Invoice?'),
          content: Text('Are you sure you want to delete this invoice?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                InvoicesTableProvider.removeInvoice(invoice.id);
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Invoice deleted successfully')),
                );
              },
              child: Text('Delete', style: TextStyle(color: Colors.red)),
            ),
          ],
        );
      },
    );
  }
}
