import 'package:flutter/material.dart';

class AppTheme {
  static ThemeData theme = ThemeData(
    // textTheme: TextTheme(bodyMedium: TextStyle(fontSize: 11)),
    inputDecorationTheme: InputDecorationTheme(
      prefixIconColor: Colors.grey.shade600,hintStyle:  
       TextStyle(fontSize: 12.0), // Ukuran teks

      filled: true,
      // labelStyle: TextStyle(fontSize: 12, color: Colors.grey.shade600),
      fillColor: Colors.grey[200],
// background abu-abu
      contentPadding: EdgeInsets.symmetric(horizontal: 8, vertical: 6),
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
