import 'package:flutter/material.dart';
import 'package:gphfinance/create%20invoice/button_pushfirebase_invoices.dart';
import 'package:gphfinance/invoice_detail.dart';
import 'package:gphfinance/model.dart';
import 'package:gphfinance/provider/provider_invoices_table.dart';
import 'package:provider/provider.dart';
import 'package:gphfinance/helper/rupiah_format.dart'; // Import formatter

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
                      Rupiah.toStringFormated(InvoicesTableProvider.totalSales),
                      Colors.green,
                    ),
                    _buildSummaryCard(
                      'Total HPP',
                      Rupiah.toStringFormated(InvoicesTableProvider.totalCost),
                      Colors.blue,
                    ),
                    _buildSummaryCard(
                      'Total Komisi',
                      Rupiah.toStringFormated(
                          InvoicesTableProvider.totalBiayakomisi),
                      Colors.blue,
                    ),
                    _buildSummaryCard(
                      'Total Profit',
                      Rupiah.toStringFormated(
                          InvoicesTableProvider.totalNetProfit),
                      Colors.purple,
                    ),
                    _buildSummaryCard(
                      'Paid',
                      Rupiah.toStringFormated(InvoicesTableProvider.totalPaid),
                      Colors.teal,
                    ),
                    _buildSummaryCard(
                      'Unpaid',
                      Rupiah.toStringFormated(
                          InvoicesTableProvider.totalUnpaid),
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
                      DataColumn(label: Text('School')),
                      DataColumn(label: Text('Items'), numeric: true),
                      DataColumn(label: Text('Subtotal'), numeric: true),
                      DataColumn(label: Text('Discount'), numeric: true),
                      DataColumn(label: Text('Tax'), numeric: true),
                      DataColumn(label: Text('Total'), numeric: true),
                      DataColumn(label: Text('Paid'), numeric: true),
                      DataColumn(label: Text('Status')),
                      DataColumn(label: Text('Actions')),
                    ],
                    rows: InvoicesTableProvider.invoices.map((invoice) {
                      return DataRow(
                        cells: [
                          DataCell(
                            Text(
                              invoice.school.isNotEmpty ? invoice.school : '-',
                            ),
                          ),
                          DataCell(Text(
                              '${invoice.items.fold(0, (sum, item) => sum + item.quantity)}')),
                          DataCell(Text(Rupiah.toStringFormated(
                              invoice.subTotal.toDouble()))),
                          DataCell(Text('${invoice.discount}%')),
                          DataCell(Text('${invoice.tax}%')),
                          DataCell(
                            Text(
                              Rupiah.toStringFormated(invoice.total.toDouble()),
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.blue,
                              ),
                            ),
                          ),
                          DataCell(
                            Text(
                              Rupiah.toStringFormated(invoice.downPayment),
                              style: TextStyle(
                                color: invoice.downPayment > 0
                                    ? Colors.green
                                    : Colors.grey,
                              ),
                            ),
                          ),
                          DataCell(
                            Chip(
                              label: Text(
                                invoice.isPaid ? 'PAID' : 'UNPAID',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 12,
                                ),
                              ),
                              backgroundColor:
                                  invoice.isPaid ? Colors.green : Colors.orange,
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
                                    showDialog(
                                      context: context,
                                      builder: (context) =>
                                          InvoiceDetailsDialog(
                                              invoice: invoice),
                                    );
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
          PushInvoicesButton()
        ],
      ),
    );
  }

  Widget _buildSummaryCard(String title, String value, Color color) {
    return Card(
      elevation: 2,
      color: Colors.white,
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
