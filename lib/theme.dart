import 'package:flutter/material.dart';

class AppTheme {
  static ThemeData theme = ThemeData(
    inputDecorationTheme: InputDecorationTheme(prefixIconColor: Colors.grey.shade600,
      filled: true,
      labelStyle: TextStyle(color:  Colors.grey.shade600),
      fillColor:                       Colors.grey[200],
// background abu-abu
      contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 14),
      border: UnderlineInputBorder(
        borderSide: BorderSide(color: Colors.grey, width: 4),
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(15), // hanya top kiri & kanan
        ),
      ),
      enabledBorder: UnderlineInputBorder(
        borderSide: BorderSide(color: Colors.grey, width: 1),
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(15),
        ),
      ),
      focusedBorder: UnderlineInputBorder(
        borderSide: BorderSide(color: Colors.green, width: 2),
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(15),
        ),
      ),
    ),
  );
}
