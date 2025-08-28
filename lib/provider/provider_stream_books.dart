import 'package:flutter/material.dart';
import 'package:gphfinance/model.dart';

class ProviderStreamBooks with ChangeNotifier {
  List<Book> _books = [];

  List<Book> get books => _books;

  /// Add new invoice
  void addInvoice(Book invoice, {bool listen = true}) {
    _books.add(invoice);
    listen ? notifyListeners() : "";
  }

  void setbooks(List<Book> books, {bool listen = true}) {
    _books = books;
    listen ? notifyListeners() : "";
  }

  /// Remove invoice
  void removeInvoice(String invoiceId) {
    _books.removeWhere((invoice) => invoice.id == invoiceId);
    notifyListeners();
  }

  /// Update invoice
  void updateInvoice(String invoiceId, Book updatedInvoice) {
    final index = _books.indexWhere((invoice) => invoice.id == invoiceId);
    if (index != -1) {
      _books[index] = updatedInvoice;
      notifyListeners();
    }
  }

  /// Get invoice by ID
  Book? getInvoiceById(String invoiceId) {
    try {
      return _books.firstWhere((invoice) => invoice.id == invoiceId);
    } catch (e) {
      return null;
    }
  }

  /// Clear all books
  void clearbooks() {
    _books.clear();
    notifyListeners();
  }

  /// Load books from JSON list
  void loadbooksFromJson(List<Map<dynamic, dynamic>> booksJson) {
    _books = booksJson.map((json) => Book.fromJson(json)).toList();
    notifyListeners();
  }

  /// Convert all books to JSON list
  List<Map<dynamic, dynamic>> toJsonList() {
    return _books.map((invoice) => invoice.toJson()).toList();
  }
}
