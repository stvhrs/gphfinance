import 'package:flutter/material.dart';
import 'package:gphfinance/model.dart';

class ProviderStreamInovices with ChangeNotifier {
  List<Invoice> _invoices = [];
  Invoice? _selectedInvoce;

  List<Invoice> get invoices => _invoices;
  Invoice? get selectedInvoce => _selectedInvoce;

  void selectinvoce(Invoice invoce) {
    _selectedInvoce = invoce;
    notifyListeners();
  }

  /// Total harga dari semua invoice (total penjualan)
  double get totalSales {
    return _invoices.fold(0, (sum, invoice) => sum + invoice.total);
  }

  /// Total cost dari semua invoice (total HPP)
  double get totalCost {
    return _invoices.fold(0, (sum, invoice) => sum + invoice.totalCostPrice);
  }

  /// Total Komisi - VARIABLE BARU
  double get totalkomisi {
    return _invoices.fold(0, (sum, invoice) => sum + invoice.biayakomisi);
  }

  /// Total cost sales dari semua invoice
  double get totalCostSales {
    return _invoices.fold(0, (sum, invoice) => sum + invoice.biayakomisi);
  }

  /// Total semua biaya (HPP + cost sales + Komisi)
  double get totalAllCosts {
    return totalCost + totalCostSales + totalkomisi;
  }

  /// Total profit kotor (sales - HPP)
  double get totalGrossProfit {
    return totalSales - totalCost;
  }

  /// Total profit bersih (sales - semua biaya)
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

  /// Invoice dengan biaya Komisi tertinggi - METHOD BARU
  Invoice? get highestkomisiInvoice {
    if (_invoices.isEmpty) return null;
    return _invoices.reduce((a, b) => a.biayakomisi > b.biayakomisi ? a : b);
  }

  /// Rata-rata biaya Komisi per invoice - METHOD BARU
  double get averagekomisiPerInvoice {
    return _invoices.isNotEmpty ? totalkomisi / _invoices.length : 0;
  }

  /// Persentase biaya Komisi terhadap total sales - METHOD BARU
  double get komisiToSalesRatio {
    return totalSales > 0 ? (totalkomisi / totalSales) * 100 : 0;
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

  /// Filter invoices dengan biaya Komisi di atas threshold - METHOD BARU
  List<Invoice> filterBykomisiThreshold(double threshold) {
    return _invoices
        .where((invoice) => invoice.biayakomisi >= threshold)
        .toList();
  }

  /// Get total sales for a specific date range
  double getSalesByDateRange(DateTime startDate, DateTime endDate) {
    final filteredInvoices = filterByDateRange(startDate, endDate);
    return filteredInvoices.fold(0, (sum, invoice) => sum + invoice.total);
  }

  /// Get Total Komisi for a specific date range - METHOD BARU
  double getkomisiByDateRange(DateTime startDate, DateTime endDate) {
    final filteredInvoices = filterByDateRange(startDate, endDate);
    return filteredInvoices.fold(
        0, (sum, invoice) => sum + invoice.biayakomisi);
  }

  // /// Get total profit for a specific date range
  // double getProfitByDateRange(DateTime startDate, DateTime endDate) {
  //   final filteredInvoices = filterByDateRange(startDate, endDate);
  //   final totalSales = filteredInvoices.fold(0, (sum, invoice) => sum + invoice.total);
  //   final totalCosts = filteredInvoices.fold(0, (sum, invoice) =>
  //     sum + invoice.totalCostPrice  + invoice.biayakomisi);
  //   return totalSales - totalCosts;
  // }

  /// Get summary statistics termasuk Komisi - METHOD BARU
  Map<String, dynamic> getSummary() {
    return {
      'totalInvoices': _invoices.length,
      'totalSales': totalSales,
      'totalCost': totalCost,
      'totalCostSales': totalCostSales,
      'totalkomisi': totalkomisi,
      'totalGrossProfit': totalGrossProfit,
      'totalNetProfit': totalNetProfit,
      'grossProfitMargin': grossProfitMargin,
      'netProfitMargin': netProfitMargin,
      'totalPaid': totalPaid,
      'totalUnpaid': totalUnpaid,
      'paidInvoicesCount': paidInvoicesCount,
      'unpaidInvoicesCount': unpaidInvoicesCount,
      'averageInvoiceValue': averageInvoiceValue,
      'averagekomisiPerInvoice': averagekomisiPerInvoice,
      'komisiToSalesRatio': komisiToSalesRatio,
    };
  }

  /// Get Komisi analysis - METHOD BARU
  Map<String, dynamic> getkomisiAnalysis() {
    final highestkomisi = highestkomisiInvoice;

    return {
      'totalkomisi': totalkomisi,
      'averagekomisiPerInvoice': averagekomisiPerInvoice,
      'komisiToSalesRatio': komisiToSalesRatio,
      'highestkomisiInvoice': highestkomisi?.id,
      'highestkomisiAmount': highestkomisi?.biayakomisi ?? 0,
      'invoicesWithkomisi': _invoices.where((i) => i.biayakomisi > 0).length,
      'percentageWithkomisi': _invoices.isNotEmpty
          ? (_invoices.where((i) => i.biayakomisi > 0).length /
                  _invoices.length) *
              100
          : 0,
    };
  }

  /// Export data Komisi untuk reporting - METHOD BARU
  List<Map<String, dynamic>> exportkomisiData() {
    return _invoices
        .map((invoice) => {
              'invoiceId': invoice.id,
              'date': invoice.displayDate,
              'school': invoice.school,
              'recipient': invoice.recipient,
              'totalSales': invoice.total,
              'totalCost': invoice.totalCostPrice,
              'biayakomisi': invoice.biayakomisi,
              'netProfit': invoice.netProfit,
              'komisiPercentage': invoice.total > 0
                  ? (invoice.biayakomisi / invoice.total) * 100
                  : 0,
              'paidStatus': invoice.paid ? 'Paid' : 'Unpaid',
            })
        .toList();
  }
}
