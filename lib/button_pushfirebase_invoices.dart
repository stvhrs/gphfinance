import 'package:flutter/material.dart';
import 'package:gphfinance/model.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:gphfinance/provider/provider_invoices_table.dart';
import 'package:provider/provider.dart';

class PushInvoicesButton extends StatefulWidget {


  @override
  State<PushInvoicesButton> createState() => _PushInvoicesButtonState();
}

class _PushInvoicesButtonState extends State<PushInvoicesButton> {
  bool _isLoading = false;

  Future<void> _pushInvoices() async {
    var invoices = context.read<InvoicesTableProvider>().invoices;
    setState(() => _isLoading = true);

    try {
      final dbRef = FirebaseDatabase.instance.ref("invoices");

      // Looping pakai set
      final futures = invoices.map((invoice) {
        return dbRef.child( DateTime.now().millisecondsSinceEpoch.toString()).set(invoice.toJson());
      });

      await Future.wait(futures);

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Invoices berhasil dipush (${invoices.length})"),
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Gagal push invoices: $e")));
    } finally {
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: _isLoading ? null : _pushInvoices,
      style: ElevatedButton.styleFrom(
        padding: EdgeInsets.symmetric(horizontal: 24, vertical: 14),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
      child:
          _isLoading
              ? SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(
                  color: Colors.white,
                  strokeWidth: 2,
                ),
              )
              : Text("Push Invoices"),
    );
  }
}
