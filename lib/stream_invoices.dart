import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:gphfinance/create%20invoice/create_invoices.dart';
import 'package:gphfinance/create%20invoice/pdf/preview_pdf.dart';
import 'package:gphfinance/helper/rupiah_format.dart';
import 'package:gphfinance/invoice_detail.dart';
import 'package:gphfinance/model.dart';
import 'package:gphfinance/provider/provider_invoices_table.dart';
import 'package:gphfinance/provider/provider_stream_inovices.dart';
import 'package:provider/provider.dart';

class InvoicesTableStream extends StatefulWidget {
  @override
  _InvoicesTableStreamState createState() => _InvoicesTableStreamState();
}

class _InvoicesTableStreamState extends State<InvoicesTableStream> {
  final DatabaseReference _dbRef =
      FirebaseDatabase.instance.ref().child("invoices");

  final int _rowsPerPage = 20;
  int _currentPage = 0;
  List<Invoice> _allInvoices = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Consumer<ProviderStreamInovices>(
            builder: (context, ProviderStreamInovices, child) {
              return Padding(
                padding: const EdgeInsets.all(8.0),
                child: Wrap(
                  spacing: 12,
                  runSpacing: 12,
                  children: [
                    // Total Sales
                    _buildSummaryCard(
                      'Total Sales',
                      Rupiah.toStringFormated(ProviderStreamInovices
                          .totalSales), // Memformat total sales menjadi Rupiah
                      Colors.green,
                    ),
                    // Total HPP
                    _buildSummaryCard(
                      'Total HPP',
                      Rupiah.toStringFormated(ProviderStreamInovices
                          .totalCost), // Memformat total cost menjadi Rupiah
                      Colors.blue,
                    ),
                    // Total komisi
                    _buildSummaryCard(
                      'Total komisi',
                      Rupiah.toStringFormated(ProviderStreamInovices
                          .totalkomisi), // Memformat total komisi menjadi Rupiah
                      Colors.blue,
                    ),
                    // Total Profit
                    _buildSummaryCard(
                      'Total Profit',
                      Rupiah.toStringFormated(ProviderStreamInovices
                          .totalNetProfit), // Memformat total profit menjadi Rupiah
                      Colors.purple,
                    ),
                    // Total Paid
                    _buildSummaryCard(
                      'Paid',
                      Rupiah.toStringFormated(ProviderStreamInovices
                          .totalPaid), // Memformat total paid menjadi Rupiah
                      Colors.teal,
                    ),
                    // Total Unpaid
                    _buildSummaryCard(
                      'Unpaid',
                      Rupiah.toStringFormated(ProviderStreamInovices
                          .totalUnpaid), // Memformat total unpaid menjadi Rupiah
                      Colors.orange,
                    ),
                    // Total Invoices
                    _buildSummaryCard(
                      'Invoices',
                      ProviderStreamInovices.invoices.length
                          .toString(), // Menampilkan jumlah invoice (bukan angka dengan format)
                      Colors.indigo,
                    ),
                    // Paid Invoices
                    _buildSummaryCard(
                      'Paid Invoices',
                      ProviderStreamInovices.paidInvoicesCount
                          .toString(), // Menampilkan jumlah invoice lunas
                      Colors.green,
                    ),
                    // Unpaid Invoices
                    _buildSummaryCard(
                      'Unpaid Invoices',
                      ProviderStreamInovices.unpaidInvoicesCount
                          .toString(), // Menampilkan jumlah invoice belum lunas
                      Colors.red,
                    ),
                  ],
                ),
              );
            },
          ),
          Divider(),
          Expanded(
            child: StreamBuilder(
              stream: _dbRef.onValue,
              builder: (context, AsyncSnapshot<DatabaseEvent> snapshot) {
                if (snapshot.hasError) {
                  return Center(child: Text("Error: ${snapshot.error}"));
                }

                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                }

                if (!snapshot.hasData ||
                    snapshot.data!.snapshot.value == null) {
                  return Center(child: Text("No invoices found"));
                }

                // Process data
                Map<dynamic, dynamic> invoicesMap =
                    snapshot.data!.snapshot.value as Map<dynamic, dynamic>;

                _allInvoices = invoicesMap.entries.map((entry) {
                  final Map<dynamic, dynamic> data =
                      Map<dynamic, dynamic>.from(entry.value);
                  return Invoice.fromJson(data);
                }).toList();

                // Sort by date descending (newest first)
                _allInvoices.sort((a, b) => b.date.compareTo(a.date));

                // Update provider
                WidgetsBinding.instance.addPostFrameCallback((_) {
                  context
                      .read<ProviderStreamInovices>()
                      .setInvoices(_allInvoices);
                });

                // Get current page data
                final totalPages = (_allInvoices.length / _rowsPerPage).ceil();
                final startIndex = _currentPage * _rowsPerPage;
                final endIndex = startIndex + _rowsPerPage;
                final currentPageInvoices = _allInvoices.sublist(
                  startIndex,
                  endIndex > _allInvoices.length
                      ? _allInvoices.length
                      : endIndex,
                );

                return Column(
                  children: [
                    // Pagination Controls
                    _buildPaginationControls(totalPages),

                    Expanded(
                      child: SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: SingleChildScrollView(
                          scrollDirection: Axis.vertical,
                          child: DataTable(
                            headingRowColor: MaterialStateColor.resolveWith(
                              (states) => Colors.grey.shade200,
                            ),
                            border:
                                TableBorder.all(color: Colors.grey.shade300),
                            columns: const [
                              DataColumn(label: Text("No")),
                              DataColumn(label: Text("Date")),
                              DataColumn(label: Text("Recipient")),
                              DataColumn(label: Text("School")),
                              DataColumn(label: Text("Books"), numeric: true),
                              DataColumn(
                                  label: Text("SubTotal"), numeric: true),
                              DataColumn(
                                  label: Text("Discount"), numeric: true),
                              DataColumn(label: Text("Tax"), numeric: true),
                              DataColumn(label: Text("Total"), numeric: true),
                              DataColumn(label: Text("HPP"), numeric: true),
                              DataColumn(
                                  label: Text("Biaya komisi"), numeric: true),
                              DataColumn(label: Text("Profit"), numeric: true),
                              DataColumn(
                                  label: Text("DownPayment"), numeric: true),
                              DataColumn(label: Text("Status")),
                              DataColumn(label: Text("Actions")),
                            ],
                            rows: [
                              ...currentPageInvoices
                                  .asMap()
                                  .entries
                                  .map((entry) {
                                final index = entry.key;
                                final invoice = entry.value;
                                final globalIndex = startIndex + index + 1;

                                return DataRow(cells: [
                                  DataCell(Text(globalIndex.toString())),
                                  DataCell(Text(invoice.displayDate)),
                                  DataCell(
                                    ConstrainedBox(
                                      constraints:
                                          BoxConstraints(maxWidth: 150),
                                      child: Text(
                                        invoice.recipient,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                  ),
                                  DataCell(
                                    ConstrainedBox(
                                      constraints:
                                          BoxConstraints(maxWidth: 150),
                                      child: Text(
                                        invoice.school,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                  ),
                                  DataCell(Text(invoice.totalBooks.toString())),
                                  DataCell(Text("Rp${invoice.subTotal}")),
                                  DataCell(Text("${invoice.discount}%")),
                                  DataCell(Text("${invoice.tax}%")),
                                  DataCell(
                                    Text(
                                      "Rp${invoice.total.toStringAsFixed(0)}",
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: Colors.blue,
                                      ),
                                    ),
                                  ),
                                  DataCell(Text("Rp${invoice.totalCostPrice}")),
                                  DataCell(Text("Rp${invoice.biayakomisi}")),
                                  DataCell(Text("Rp${invoice.netProfit}")),
                                  DataCell(
                                    Text(
                                      "Rp${invoice.downPayment.toStringAsFixed(0)}",
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
                                        invoice.paid ? "PAID" : "UNPAID",
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 12,
                                        ),
                                      ),
                                      backgroundColor: invoice.paid
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
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        IconButton(
                                          icon:
                                              Icon(Icons.visibility, size: 18),
                                          onPressed: () {
                                            _showInvoiceDetails(invoice);
                                          },
                                        ),
                                        IconButton(
                                          icon: Icon(Icons.edit,
                                              size: 18, color: Colors.blue),
                                          onPressed: () {
                                            _editInvoice(invoice);
                                          },
                                        ),
                                        InvoicePreviewButton(invoice: invoice)
                                      ],
                                    ),
                                  ),
                                ]);
                              }),
                            ],
                          ),
                        ),
                      ),
                    ),

                    // Bottom pagination info
                    _buildPaginationInfo(totalPages),
                  ],
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  void _showInvoiceDetails(Invoice invoice) {
    showDialog(
      context: context,
      builder: (context) => InvoiceDetailsDialog(invoice: invoice),
    );
  }

  Widget _buildPaginationControls(int totalPages) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          IconButton(
            icon: Icon(Icons.first_page),
            onPressed: _currentPage > 0
                ? () => setState(() => _currentPage = 0)
                : null,
          ),
          IconButton(
            icon: Icon(Icons.chevron_left),
            onPressed:
                _currentPage > 0 ? () => setState(() => _currentPage--) : null,
          ),

          // Page numbers
          ...List.generate(totalPages, (index) {
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 4.0),
              child: InkWell(
                onTap: () => setState(() => _currentPage = index),
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: _currentPage == index
                        ? Colors.blue
                        : Colors.grey.shade300,
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Text(
                    '${index + 1}',
                    style: TextStyle(
                      color:
                          _currentPage == index ? Colors.white : Colors.black,
                      fontWeight: _currentPage == index
                          ? FontWeight.bold
                          : FontWeight.normal,
                    ),
                  ),
                ),
              ),
            );
          }),

          IconButton(
            icon: Icon(Icons.chevron_right),
            onPressed: _currentPage < totalPages - 1
                ? () => setState(() => _currentPage++)
                : null,
          ),
          IconButton(
            icon: Icon(Icons.last_page),
            onPressed: _currentPage < totalPages - 1
                ? () => setState(() => _currentPage = totalPages - 1)
                : null,
          ),
        ],
      ),
    );
  }

  Widget _buildPaginationInfo(int totalPages) {
    final startIndex = _currentPage * _rowsPerPage + 1;
    final endIndex = (_currentPage + 1) * _rowsPerPage;
    final actualEndIndex =
        endIndex > _allInvoices.length ? _allInvoices.length : endIndex;

    return Container(
      padding: EdgeInsets.all(12),
      color: Colors.grey.shade100,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            'Showing $startIndex to $actualEndIndex of ${_allInvoices.length} invoices',
            style: TextStyle(fontSize: 12),
          ),
          Text(
            'Page ${_currentPage + 1} of $totalPages',
            style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }

  void _editInvoice(Invoice invoice) {
    context.read<Invoice>().updateFromInvoice(invoice);
    Navigator.of(context).push(MaterialPageRoute(
      builder: (context) => Scaffold(
          body: SizedBox(
        width: 1000,
        child: InoviceForm(
          update: true,
        ),
      )),
    ));
    // showDialog(
    //   context: context,
    //   builder: (BuildContext context) {
    //     context.read<Invoice>().updateFromInvoice(invoice);
    //     return Dialog(
    //       backgroundColor: Colors.white,
    //       shape: RoundedRectangleBorder(
    //         borderRadius: BorderRadius.circular(16),
    //       ),
    //       elevation: 10,
    //       child: Padding(
    //         padding: const EdgeInsets.all(24.0),
    //         child: SizedBox(
    //             width: 1000,
    //             child: InoviceForm(
    //               update: true,
    //             )),
    //       ), // Your CreateInvoices widget inside the dialog
    //     );
    //   },
    // );
  }
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
