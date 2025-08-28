import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:gphfinance/helper/rupiah_format.dart';
import 'package:gphfinance/model.dart';

class AddEditBookDialog extends StatefulWidget {
  final Book? product;

  const AddEditBookDialog({super.key, this.product});

  @override
  State<AddEditBookDialog> createState() => _AddEditBookDialogState();
}

class _AddEditBookDialogState extends State<AddEditBookDialog> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _costPriceController = TextEditingController();
  final _sellingPriceController = TextEditingController();
  final DatabaseReference _booksRef =
      FirebaseDatabase.instance.ref().child('books');

  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    if (widget.product != null) {
      _nameController.text = widget.product!.name;
      _costPriceController.text = widget.product!.costPrice.toString();
      _sellingPriceController.text = widget.product!.sellingPrice.toString();
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _costPriceController.dispose();
    _sellingPriceController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(widget.product == null ? 'Add Book' : 'Edit Book'),
      content: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(labelText: 'Book Name'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter book name';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _costPriceController,
                decoration: const InputDecoration(labelText: 'Cost Price'),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter cost price';
                  }
                  if (double.tryParse(value) == null) {
                    return 'Please enter a valid number';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _sellingPriceController,
                decoration: const InputDecoration(labelText: 'Selling Price'),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter selling price';
                  }
                  if (double.tryParse(value) == null) {
                    return 'Please enter a valid number';
                  }
                  return null;
                },
              ),
            ],
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: _isLoading ? null : () => Navigator.pop(context),
          child: const Text('Cancel'),
        ),
        ElevatedButton(
          onPressed: _isLoading ? null : _submitForm,
          child: _isLoading
              ? const SizedBox(
                  width: 20, height: 20, child: CircularProgressIndicator())
              : Text(widget.product == null ? 'Add' : 'Update'),
        ),
      ],
    );
  }

  void _submitForm() async {
    if (_formKey.currentState!.validate()) {
      setState(() => _isLoading = true);

      try {
        final product = Book(
          id: widget.product?.id,
          name: _nameController.text,
          costPrice: Rupiah.toDouble(_costPriceController.text).toInt(),
          sellingPrice: Rupiah.toDouble(_sellingPriceController.text).toInt(),
        );

        if (widget.product == null) {
          // Add new book
          final newRef = _booksRef.push();
          await newRef.set({
            'id': newRef.key,
            'name': product.name,
            'costPrice': product.costPrice,
            'sellingPrice': product.sellingPrice,
            'createdAt': ServerValue.timestamp,
          });
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Book added successfully')),
          );
        } else {
          // Update existing book
          await _booksRef.child(product.id!).update({
            'name': product.name,
            'costPrice': product.costPrice,
            'sellingPrice': product.sellingPrice,
            'updatedAt': ServerValue.timestamp,
          });
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Book updated successfully')),
          );
        }

        Navigator.pop(context, true); // return true biar bisa refresh list
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: $e')),
        );
      } finally {
        setState(() => _isLoading = false);
      }
    }
  }
}
