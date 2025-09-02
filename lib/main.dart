import 'package:flutter/material.dart';
import 'package:gphfinance/create%20invoice/create_invoices.dart';
import 'package:gphfinance/create%20invoice/pdf/pdf_view.dart';
import 'package:gphfinance/model.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:gphfinance/provider/provider_invoices_table.dart';
import 'package:gphfinance/provider/provider_stream_books.dart';
import 'package:gphfinance/provider/provider_stream_inovices.dart';
import 'package:gphfinance/sidemenu.dart';
import 'package:gphfinance/theme.dart';
import 'package:provider/provider.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: const FirebaseOptions(
        apiKey: "AIzaSyAiI8WtsByC8eNaH8_eyyu97nAOvADeMT0",
        authDomain: "gphfinance-674cb.firebaseapp.com",
        databaseURL:
            "https://gphfinance-674cb-default-rtdb.asia-southeast1.firebasedatabase.app",
        projectId: "gphfinance-674cb",
        storageBucket: "gphfinance-674cb.firebasestorage.app",
        messagingSenderId: "247872950244",
        appId: "1:247872950244:web:0130a09f33f3a3952dc1f1",
        measurementId: "G-Q06SCZ9XF1"),
  );
  await initializeDateFormatting('id_ID', null);

  runApp(MyApp());
}

bool isMobile = false;

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    isMobile = MediaQuery.of(context).size.width < 600;
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => InvoicesTableProvider()),
        ChangeNotifierProvider(create: (context) => ProviderStreamBooks()),
        ChangeNotifierProvider(create: (context) => ProviderStreamInovices()),
        ChangeNotifierProvider(create: (context) => Invoice()),
      ],
      child: MaterialApp(
        title: 'Invoice Management System',
        theme: AppTheme.theme,
        home: Home(
          title: "",
        ),
      ),
    );
  }
}
