import 'package:flutter/material.dart';
import 'package:gphfinance/create_invoices.dart';
import 'package:gphfinance/model.dart';
// main.dart
import 'package:flutter/material.dart';
import 'package:gphfinance/provider/provider_invoices_table.dart';
import 'package:gphfinance/theme.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => InvoicesTableProvider()),
        ChangeNotifierProvider(create: (context) => Invoice()),
      ],
      child: MaterialApp(
        title: 'Invoice Management System',
        theme: AppTheme.theme,
        home: CreateInvoices(),
      ),
    );
  }
}
