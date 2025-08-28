import 'package:flutter/material.dart';
import 'package:gphfinance/model.dart';

class ProviderStreamInovices with ChangeNotifier {
  List<Invoice> _invoices = [];

  List<Invoice> get invoices => _invoices;

  /// Total harga dari semua invoice (total penjualan)
  double get totalSales {
    return _invoices.fold(0, (sum, invoice) => sum + invoice.total);
  }

  /// Total cost dari semua invoice (total HPP)
  double get totalCost {
    return _invoices.fold(0, (sum, invoice) => sum + invoice.totalCostPrice);
  }

  /// Total profit dari semua invoice
  double get totalProfit {
    return totalSales - totalCost;
  }

  /// Total yang sudah dibayar (down payment)
  double get totalPaid {
    return _invoices.fold(0, (sum, invoice) => sum + invoice.downPayment);
  }

  /// Total yang belum dibayar
  double get totalUnpaid {
    return totalSales - totalPaid;
  }

  /// Jumlah invoice lunas
  int get paidInvoicesCount {
    return _invoices.where((invoice) => invoice.paid).length;
  }

  /// Jumlah invoice belum lunas
  int get unpaidInvoicesCount {
    return _invoices.where((invoice) => !invoice.paid).length;
  }

  /// Add new invoice
  void addInvoice(Invoice invoice, {bool listen = true}) {
    _invoices.add(invoice);
    listen ? notifyListeners() : "";
  }

  void setInvoices(List<Invoice> invoices, {bool listen = true}) {
    _invoices = invoices;
    listen ? notifyListeners() : "";
  }

  /// Remove invoice
  void removeInvoice(String invoiceId) {
    _invoices.removeWhere((invoice) => invoice.id == invoiceId);
    notifyListeners();
  }

  /// Update invoice
  void updateInvoice(String invoiceId, Invoice updatedInvoice) {
    final index = _invoices.indexWhere((invoice) => invoice.id == invoiceId);
    if (index != -1) {
      _invoices[index] = updatedInvoice;
      notifyListeners();
    }
  }

  /// Get invoice by ID
  Invoice? getInvoiceById(String invoiceId) {
    try {
      return _invoices.firstWhere((invoice) => invoice.id == invoiceId);
    } catch (e) {
      return null;
    }
  }

  /// Clear all invoices
  void clearInvoices() {
    _invoices.clear();
    notifyListeners();
  }

  /// Load invoices from JSON list
  void loadInvoicesFromJson(List<Map<dynamic, dynamic>> invoicesJson) {
    _invoices = invoicesJson.map((json) => Invoice.fromJson(json)).toList();
    notifyListeners();
  }

  /// Convert all invoices to JSON list
  List<Map<dynamic, dynamic>> toJsonList() {
    return _invoices.map((invoice) => invoice.toJson()).toList();
  }
}
