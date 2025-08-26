import 'package:intl/intl.dart';

class Rupiah {
  static String toStringFormated(double i) {
    if (i.isNegative) {
      return "( ${NumberFormat.currency(locale: "id_ID", decimalDigits: 0, symbol: 'Rp ').format(i).replaceAll('-', '')} )";
    } else {
      return NumberFormat.currency(
        locale: "id_ID",
        decimalDigits: 0,
        symbol: 'Rp ',
      ).format(i).replaceAll('-', '').toString();
    }
  }

  static double toDouble(String s) {
    return NumberFormat.currency(
      locale: 'id_ID',
      symbol: 'Rp ',
    ).parse(s).toDouble();
  }
}
