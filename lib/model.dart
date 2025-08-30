import 'package:flutter/material.dart';
import 'package:gphfinance/helper/id_generator.dart';

/// BOOK MODEL WITH PROVIDER
class Book with ChangeNotifier {
  final String id;
  final String name;
  final int costPrice;
  int sellingPrice;
  final Color color;

  Book({
    required this.name,
    required this.costPrice,
    required this.sellingPrice,
    String? id,
    Color? color,
  })  : id = id ?? DateTime.now().millisecondsSinceEpoch.toString(),
        color = color ?? getColorByName(name);

  /// Get color based on book name
  static Color getColorByName(String name) {
    final lower = name.toLowerCase();

    if (lower.contains('koding')) return Colors.purple;
    if (lower.contains('inggris')) return Colors.blue;
    if (lower.contains('ips')) return Colors.brown;
    if (lower.contains('ipa') || lower.contains('ipas')) return Colors.green;
    if (lower.contains('indonesia')) return Colors.yellow.shade700;
    if (lower.contains('matematika')) return Colors.red;

    return Colors.grey;
  }

  /// Convert to JSON
  Map<dynamic, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'costPrice': costPrice,
      'sellingPrice': sellingPrice,
    };
  }

  /// Create from JSON
  static Book fromJson(Map<dynamic, dynamic> json) {
    return Book(
      id: json['id'],
      name: json['name'],
      costPrice: json['costPrice'],
      sellingPrice: json['sellingPrice'],
    );
  }

  /// Update selling price and notify UI
  void updateSellingPrice(int newPrice) {
    sellingPrice = newPrice;
    notifyListeners();
  }
}

/// INVOICE ITEM WITH PROVIDER
class InvoiceItem with ChangeNotifier {
  final String id;
  final Book book;
  int quantity;
  int sellingPrice; // Harga jual khusus untuk item ini

  InvoiceItem({
    required this.book,
    this.quantity = 1,
    int? sellingPrice, // Optional parameter untuk harga custom
    String? id,
  })  : id = id ?? DateTime.now().millisecondsSinceEpoch.toString(),
        sellingPrice = sellingPrice ?? book.sellingPrice; // Default dari book

  /// Getter for total item price
  int get totalPrice => sellingPrice * quantity;

  /// Convert to JSON
  Map<dynamic, dynamic> toJson() {
    return {
      'id': id,
      'book': book.toJson(),
      'quantity': quantity,
      'sellingPrice': sellingPrice,
    };
  }

  /// Create from JSON
  static InvoiceItem fromJson(Map<dynamic, dynamic> json) {
    return InvoiceItem(
      id: json['id'],
      book: Book.fromJson(json['book']),
      quantity: json['quantity'],
      sellingPrice: json['sellingPrice'],
    );
  }

  /// Update quantity and notify UI
  void updateQuantity(int newQuantity) {
    quantity = newQuantity;
    notifyListeners();
  }

  /// Update selling price for this specific item
  void updateSellingPrice(int newSellingPrice) {
    sellingPrice = newSellingPrice;
    notifyListeners();
  }

  /// Reset selling price to book's default selling price
  void resetSellingPrice() {
    sellingPrice = book.sellingPrice;
    notifyListeners();
  }

  /// Check if selling price is different from book's default
  bool get hasCustomPrice {
    return sellingPrice != book.sellingPrice;
  }

  /// Get price difference from book's default
  int get priceDifference {
    return sellingPrice - book.sellingPrice;
  }
}

/// INVOICE WITH PROVIDER
class Invoice with ChangeNotifier {
  String id;
  List<InvoiceItem> items;
  double discount; // percentage (%)
  double tax; // percentage (%)
  double downPayment; // down payment
  bool paid; // payment status
  DateTime date; // invoice date
  String address; // alamat
  String recipient; // penerima
  String school; // sekolah
  String noHp; // nomor handphone
  double biayakomisi; // VARIABLE BARU: Harga Pokok Penjualan (HPP)

  Invoice({
    this.items = const [],
    this.discount = 0,
    this.tax = 11,
    this.downPayment = 0,
    this.paid = false,
    DateTime? date,
    String? id,
    this.address = '',
    this.recipient = '',
    this.school = '',
    this.noHp = '',
    this.biayakomisi = 0, // VARIABLE BARU: default 0
  })  : id = id ?? DateTime.now().millisecondsSinceEpoch.toString(),
        date = date ?? DateTime.now();

  refresh() {
    notifyListeners();
  }

  TextEditingController textEditingControllerAdreess = TextEditingController();
  TextEditingController textEditingControllerRecipient =
      TextEditingController();
  TextEditingController textEditingControllerSchool = TextEditingController();
  TextEditingController textEditingControllerNoHp = TextEditingController();
  TextEditingController textEditingControllerbiayakomisi =
      TextEditingController(); // CONTROLLER BARU

  resetCustomerInfo() {
    textEditingControllerSchool.clear();
    textEditingControllerRecipient.clear();
    textEditingControllerAdreess.clear();
    textEditingControllerNoHp.clear();
    textEditingControllerbiayakomisi.clear(); // CLEAR BARU
    address = '';
    recipient = "";
    school = "";
    noHp = "";
    biayakomisi = 0; // RESET BARU
    id = DateTime.now().millisecondsSinceEpoch.toString();
    notifyListeners();
  }

  Future<Invoice> generatedId() async {
    final newInvoice = Invoice(
      id: await SimpleIdGenerator.generateSimpleId(
        prefix: "GPH",
        type: "INV",
      ),
      discount: discount,
      tax: tax,
      downPayment: downPayment,
      paid: paid,
      date: date,
      address: address,
      recipient: recipient,
      school: school,
      noHp: noHp,
      biayakomisi: biayakomisi, // TAMBAHAN BARU
      items: [],
    );

    // copy items satu-satu
    for (var item in items) {
      newInvoice.items.add(
        InvoiceItem(
          book: item.book,
          quantity: item.quantity,
          sellingPrice: item.sellingPrice,
        ),
      );
    }

    return newInvoice;
  }

  Invoice copy() {
    final newInvoice = Invoice(
      id: id,
      discount: discount,
      tax: tax,
      downPayment: downPayment,
      paid: paid,
      date: date,
      address: address,
      recipient: recipient,
      school: school,
      noHp: noHp,
      biayakomisi: biayakomisi, // TAMBAHAN BARU
      items: [],
    );

    // copy items satu-satu
    for (var item in items) {
      newInvoice.items.add(
        InvoiceItem(
          book: item.book,
          quantity: item.quantity,
          sellingPrice: item.sellingPrice,
        ),
      );
    }

    return newInvoice;
  }

  // GETTERS ================================================================

  /// Subtotal before discount and tax
  double get subTotal {
    return items.fold(0, (sum, item) => sum + item.totalPrice);
  }

  /// Total cost price from all items (sum of all costPrice * quantity)
  double get totalCostPrice {
    return items.fold(
      0,
      (sum, item) => sum + (item.book.costPrice * item.quantity),
    );
  }

  /// Total discount value
  double get totalDiscount {
    return subTotal * (discount / 100);
  }

  /// Total after discount
  double get totalAfterDiscount {
    return subTotal - totalDiscount;
  }

  /// Total tax value
  double get totalTax {
    return totalAfterDiscount * (tax / 100);
  }

  /// Final total amount to pay
  double get total {
    return totalAfterDiscount + totalTax;
  }
   bool get isPaid {
    return downPayment == total&&downPayment!=0;
  }

  /// Remaining payment after down payment
  double get remainingPayment {
    return total - downPayment;
  }

  /// Total number of books from all items (sum of all quantity)
  int get totalBooks {
    return items.fold(0, (sum, item) => sum + item.quantity);
  }

  /// Gross profit (total sales - total cost price - cost sales)
  double get grossProfit {
    return total - totalCostPrice - biayakomisi;
  }

  /// Gross profit margin (gross profit / total sales)
  double get grossProfitMargin {
    return total > 0 ? (grossProfit / total) * 100 : 0;
  }

  /// Net profit (gross profit - additional costs)
  double get netProfit {
    return grossProfit;
  }

  /// Total cost (cost of goods + cost sales)
  double get totalCost {
    return totalCostPrice + biayakomisi;
  }

  /// Date format for display (example: "12 Jan 2024")
  String get displayDate {
    return "${date.day} ${_getMonthName(date.month)} ${date.year}";
  }

  /// Date format for database (example: "2024-01-12")
  String get databaseDate {
    return "${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}";
  }

  /// Check if all required customer info is filled
  bool get hasCustomerInfo {
    return address.isNotEmpty &&
        recipient.isNotEmpty &&
        school.isNotEmpty &&
        noHp.isNotEmpty;
  }

  /// Check if phone number is valid (minimal 10 digit)
  bool get hasValidPhoneNumber {
    return noHp.length >= 10 && RegExp(r'^[0-9+]+$').hasMatch(noHp);
  }

  /// Format phone number for display
  String get formattedPhoneNumber {
    if (noHp.isEmpty) return '-';
    if (noHp.startsWith('0')) {
      return '+62 ${noHp.substring(1)}';
    }
    return noHp;
  }

  /// Format cost sales untuk display
  String get formattedbiayakomisi {
    return 'Rp${biayakomisi.toStringAsFixed(0)}';
  }

  // METHODS ================================================================

  /// Convert to JSON
  Map<dynamic, dynamic> toJson() {
    return {
      'id': id,
      'items': items.map((item) => item.toJson()).toList(),
      'discount': discount,
      'tax': tax,
      'downPayment': downPayment,
      'paid': paid,
      'date': date.toIso8601String(),
      'address': address,
      'recipient': recipient,
      'school': school,
      'noHp': noHp,
      'biayakomisi': biayakomisi, // TAMBAHAN BARU
    };
  }

  /// Create from JSON
  static Invoice fromJson(Map<dynamic, dynamic> json) {
    return Invoice(
      id: json['id'],
      items: (json['items'] as List)
          .map((item) => InvoiceItem.fromJson(item))
          .toList(),
      discount: json['discount'],
      tax: json['tax'],
      downPayment: json['downPayment'],
      paid: json['paid'],
      date: DateTime.parse(json['date']),
      address: json['address'] ?? '',
      recipient: json['recipient'] ?? '',
      school: json['school'] ?? '',
      noHp: json['noHp'] ?? '',
      biayakomisi: json['biayakomisi'] ?? 0, // TAMBAHAN BARU
    );
  }

  /// Add item to invoice
  void addItem(InvoiceItem item) {
    items = [...items, item];
    notifyListeners();
  }

  /// Remove item from invoice
  void removeItem(String itemId) {
    items.removeWhere((i) => i.id == itemId);
    notifyListeners();
  }

  /// Update discount value
  void updateDiscount(double newDiscount) {
    discount = newDiscount;
    notifyListeners();
  }

  /// Update tax value
  void updateTax(double newTax) {
    tax = newTax;
    notifyListeners();
  }

  /// Update down payment value
  void updateDownPayment(double newDownPayment) {
    downPayment = newDownPayment;
    notifyListeners();
    // Auto update paid status if downPayment >= total
    if (downPayment >= total) {
      paid = true;
    } else if (paid && downPayment < total) {
      paid = false;
    }
  }

  /// Update paid status
  void updatePaidStatus(bool isPaid) {
    paid = isPaid;
    // If set to paid, set downPayment equal to total
    if (paid) {
      downPayment = total;
    }
    notifyListeners();
  }

  /// Pay remaining amount (set paid to true and downPayment = total)
  void payInFull() {
    downPayment = total;
    paid = true;
    notifyListeners();
  }

  /// Update invoice date
  void updateDate(DateTime newDate) {
    date = newDate;
    notifyListeners();
  }

  /// Update address
  void updateAddress(String newAddress) {
    address = newAddress;
    notifyListeners();
  }

  /// Update recipient
  void updateRecipient(String newRecipient) {
    recipient = newRecipient;
    notifyListeners();
  }

  /// Update school
  void updateSchool(String newSchool) {
    school = newSchool;
    notifyListeners();
  }

  /// Update phone number
  void updatePhoneNumber(String newNoHp) {
    noHp = newNoHp;
    notifyListeners();
  }

  /// Update cost sales - METHOD BARU
  void updatebiayakomisi(double newbiayakomisi) {
    biayakomisi = newbiayakomisi;
    notifyListeners();
  }

  /// Update cost sales from string - METHOD BARU
  void updatebiayakomisiFromString(String value) {
    final cleanedValue = value.replaceAll(RegExp(r'[^0-9]'), '');
    if (cleanedValue.isNotEmpty) {
      biayakomisi = double.parse(cleanedValue);
    } else {
      biayakomisi = 0;
    }
    notifyListeners();
  }

  /// Update all customer info at once
  void updateCustomerInfo({
    String? address,
    String? recipient,
    String? school,
    String? noHp,
    double? biayakomisi, // PARAMETER BARU
  }) {
    if (address != null) this.address = address;
    if (recipient != null) this.recipient = recipient;
    if (school != null) this.school = school;
    if (noHp != null) this.noHp = noHp;
    if (biayakomisi != null) this.biayakomisi = biayakomisi; // TAMBAHAN BARU
    notifyListeners();
  }

  /// Clear all customer info
  void clearCustomerInfo() {
    address = '';
    recipient = '';
    school = '';
    noHp = '';
    biayakomisi = 0; // TAMBAHAN BARU
    notifyListeners();
  }

  /// Validate phone number
  String? validatePhoneNumber() {
    if (noHp.isEmpty) {
      return 'Nomor HP harus diisi';
    }
    if (noHp.length < 10) {
      return 'Nomor HP minimal 10 digit';
    }
    if (!RegExp(r'^[0-9+]+$').hasMatch(noHp)) {
      return 'Nomor HP hanya boleh mengandung angka dan tanda +';
    }
    return null;
  }

  /// Validate cost sales - METHOD BARU
  String? validatebiayakomisi() {
    if (biayakomisi < 0) {
      return 'Cost sales tidak boleh negatif';
    }
    return null;
  }

  /// Helper method to get month name
  String _getMonthName(int month) {
    const months = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec',
    ];
    return months[month - 1];
  }

  void updateFromInvoice(Invoice otherInvoice) {
    id = otherInvoice.id;
    items = List<InvoiceItem>.from(otherInvoice.items);
    discount = otherInvoice.discount;
    tax = otherInvoice.tax;
    downPayment = otherInvoice.downPayment;
    paid = otherInvoice.paid;
    date = otherInvoice.date;
    address = otherInvoice.address;
    recipient = otherInvoice.recipient;
    school = otherInvoice.school;
    noHp = otherInvoice.noHp;
    biayakomisi = otherInvoice.biayakomisi; // TAMBAHAN BARU

    // Update text editing controllers
    textEditingControllerAdreess.text = otherInvoice.address;
    textEditingControllerRecipient.text = otherInvoice.recipient;
    textEditingControllerSchool.text = otherInvoice.school;
    textEditingControllerNoHp.text = otherInvoice.noHp;
    textEditingControllerbiayakomisi.text =
        otherInvoice.biayakomisi.toString(); // TAMBAHAN BARU

    notifyListeners();
  }

  /// Calculate break-even point - METHOD BARU
  double get breakEvenPoint {
    return totalCostPrice + biayakomisi;
  }

  /// Calculate profit percentage - METHOD BARU
  double get profitPercentage {
    return total > 0 ? (grossProfit / total) * 100 : 0;
  }

  /// Check if invoice is profitable - METHOD BARU
  bool get isProfitable {
    return grossProfit > 0;
  }
}
