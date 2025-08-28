import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:gphfinance/book/bookForm.dart';
import 'package:gphfinance/helper/rupiah_format.dart';
import 'package:gphfinance/model.dart';
import 'package:gphfinance/provider/provider_stream_books.dart';
import 'package:gphfinance/provider/provider_stream_inovices.dart';
import 'package:provider/provider.dart';

class BookTableStream extends StatefulWidget {
  @override
  _BookTableStreamState createState() => _BookTableStreamState();
}

class _BookTableStreamState extends State<BookTableStream> {
  final DatabaseReference _dbRef =
      FirebaseDatabase.instance.ref().child("books");

  final int _rowsPerPage = 20;
  int _currentPage = 0;
  List<Book> _allbooks = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
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
                  return Center(child: Text("No Books found"));
                }

                // Process data
                Map<dynamic, dynamic> booksMap =
                    snapshot.data!.snapshot.value as Map<dynamic, dynamic>;

                _allbooks = booksMap.entries.map((entry) {
                  final Map<dynamic, dynamic> data =
                      Map<dynamic, dynamic>.from(entry.value);
                  return Book.fromJson(data);
                }).toList();

                // Sort by date descending (newest first)
                _allbooks.sort((a, b) => b.id.compareTo(a.id));

                // Update provider
                WidgetsBinding.instance.addPostFrameCallback((_) {
                  context.read<ProviderStreamBooks>().setbooks(_allbooks);
                });

                // Get current page data
                final totalPages = (_allbooks.length / _rowsPerPage).ceil();
                final startIndex = _currentPage * _rowsPerPage;
                final endIndex = startIndex + _rowsPerPage;
                final currentPagebooks = _allbooks.sublist(
                  startIndex,
                  endIndex > _allbooks.length ? _allbooks.length : endIndex,
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
                              DataColumn(label: Text("Nama")),
                              DataColumn(label: Text("Cost Price")),
                              DataColumn(label: Text("Selling Price")),
                              DataColumn(label: Text("Actions")),
                            ],
                            rows: [
                              ...currentPagebooks.asMap().entries.map((entry) {
                                final index = entry.key;
                                final book = entry.value;
                                final globalIndex = startIndex + index + 1;

                                return DataRow(cells: [
                                  DataCell(Text(globalIndex.toString())),
                                  DataCell(
                                    ConstrainedBox(
                                      constraints:
                                          BoxConstraints(maxWidth: 150),
                                      child: Text(
                                        book.name,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                  ),
                                  DataCell(
                                    ConstrainedBox(
                                      constraints:
                                          BoxConstraints(maxWidth: 150),
                                      child: Text(
                                        Rupiah.toStringFormated(
                                            book.costPrice.toDouble()),
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                  ),
                                  DataCell(Text(Rupiah.toStringFormated(
                                      book.sellingPrice.toDouble()))),
                                  DataCell(
                                    Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                       
                                        IconButton(
                                          icon: Icon(Icons.edit,
                                              size: 18, color: Colors.green),
                                          onPressed: ()async {
                                            final result = await showDialog(
                                              context: context,
                                              builder: (context) =>
                                                  AddEditBookDialog(
                                                product: book,
                                              ),
                                            );
                                            if (result == true) {
                                              // refresh list book kalau perlu
                                            }
                                          },
                                        ),
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
        endIndex > _allbooks.length ? _allbooks.length : endIndex;

    return Container(
      padding: EdgeInsets.all(12),
      color: Colors.grey.shade100,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            'Showing $startIndex to $actualEndIndex of ${_allbooks.length} books',
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
}
