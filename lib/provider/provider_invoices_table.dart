import 'package:flutter/material.dart';
import 'package:gphfinance/model.dart';

class InvoicesTableProvider with ChangeNotifier {
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

  /// Total cost sales dari semua invoice (biaya tambahan)

  /// Total biaya komisi dari semua invoice
  double get totalBiayakomisi {
    return _invoices.fold(0, (sum, invoice) => sum + invoice.biayakomisi);
  }

  /// Total semua biaya (HPP + cost sales + biaya komisi)
  double get totalAllCosts {
    return totalCost + totalBiayakomisi;
  }

  /// Total profit kotor dari semua invoice (sales - HPP)
  double get totalGrossProfit {
    return totalSales - totalCost;
  }

  /// Total profit bersih dari semua invoice (sales - semua biaya)
  double get totalNetProfit {
    return totalSales - totalAllCosts;
  }

  /// Margin profit kotor dalam persentase
  double get grossProfitMargin {
    return totalSales > 0 ? (totalGrossProfit / totalSales) * 100 : 0;
  }

  /// Margin profit bersih dalam persentase
  double get netProfitMargin {
    return totalSales > 0 ? (totalNetProfit / totalSales) * 100 : 0;
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

  /// Rata-rata nilai invoice
  double get averageInvoiceValue {
    return _invoices.isNotEmpty ? totalSales / _invoices.length : 0;
  }

  /// Invoice dengan nilai tertinggi
  Invoice? get highestValueInvoice {
    if (_invoices.isEmpty) return null;
    return _invoices.reduce((a, b) => a.total > b.total ? a : b);
  }

  /// Invoice dengan nilai terendah
  Invoice? get lowestValueInvoice {
    if (_invoices.isEmpty) return null;
    return _invoices.reduce((a, b) => a.total < b.total ? a : b);
  }

  /// Add new invoice
  void addInvoice(Invoice invoice, {bool listen = true}) {
    _invoices.add(invoice);
    if (listen) notifyListeners();
  }

  void setInvoices(List<Invoice> invoices, {bool listen = true}) {
    _invoices = invoices;
    if (listen) notifyListeners();
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

  /// Filter invoices by date range
  List<Invoice> filterByDateRange(DateTime startDate, DateTime endDate) {
    return _invoices
        .where((invoice) =>
            invoice.date.isAfter(startDate.subtract(const Duration(days: 1))) &&
            invoice.date.isBefore(endDate.add(const Duration(days: 1))))
        .toList();
  }

  /// Filter invoices by status (paid/unpaid)
  List<Invoice> filterByStatus(bool paid) {
    return _invoices.where((invoice) => invoice.paid == paid).toList();
  }

  /// Filter invoices by school
  List<Invoice> filterBySchool(String school) {
    return _invoices.where((invoice) => invoice.school == school).toList();
  }

  /// Get total sales for a specific date range
  double getSalesByDateRange(DateTime startDate, DateTime endDate) {
    final filteredInvoices = filterByDateRange(startDate, endDate);
    return filteredInvoices.fold(0, (sum, invoice) => sum + invoice.total);
  }

  // /// Get total profit for a specific date range
  // double getProfitByDateRange(DateTime startDate, DateTime endDate) {
  //   final filteredInvoices = filterByDateRange(startDate, endDate);
  //   final totalSales = filteredInvoices.fold(0, (sum, invoice) => sum.toDouble() + invoice.total);
  //   final totalCosts = filteredInvoices.fold(0, (sum, invoice) =>
  //     sum + invoice.totalCostPrice + invoice.biayakomisi);
  //   return totalSales - totalCosts;
  // }

  /// Get summary statistics
  Map<String, dynamic> getSummary() {
    return {
      'totalInvoices': _invoices.length,
      'totalSales': totalSales,
      'totalCost': totalCost,
      'totalBiayakomisi': totalBiayakomisi,
      'totalGrossProfit': totalGrossProfit,
      'totalNetProfit': totalNetProfit,
      'grossProfitMargin': grossProfitMargin,
      'netProfitMargin': netProfitMargin,
      'totalPaid': totalPaid,
      'totalUnpaid': totalUnpaid,
      'paidInvoicesCount': paidInvoicesCount,
      'unpaidInvoicesCount': unpaidInvoicesCount,
      'averageInvoiceValue': averageInvoiceValue,
    };
  }
}
