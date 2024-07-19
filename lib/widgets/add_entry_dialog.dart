import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AddEntryDialog extends StatefulWidget {
  final bool isExpense;
  final void Function(IconData, String, String, double, DateTime) onAddPressed;

  AddEntryDialog({
    Key? key,
    required this.isExpense,
    required this.onAddPressed,
  }) : super(key: key);

  @override
  _AddEntryDialogState createState() => _AddEntryDialogState();
}

class _AddEntryDialogState extends State<AddEntryDialog> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _categoryController = TextEditingController();
  final TextEditingController _amountController = TextEditingController();
  DateTime _selectedDate = DateTime.now();

  @override
  void dispose() {
    _nameController.dispose();
    _categoryController.dispose();
    _amountController.dispose();
    super.dispose();
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  Future<void> _addTransactionToFirestore(String name, String category, double amount, DateTime date) async {
    try {
      // Mengirim data transaksi ke Firestore
      await FirebaseFirestore.instance.collection('transactions').add({
        'name': name,
        'category': category,
        'amount': amount,
        'date': date,
        'isExpense': widget.isExpense,
      });

      // Panggil callback onAddPressed untuk melakukan sesuatu setelah berhasil menambahkan transaksi
      widget.onAddPressed(
        widget.isExpense ? Icons.money_off : Icons.attach_money,
        name,
        category,
        amount,
        date,
      );

      // Tutup dialog setelah data berhasil ditambahkan
      Navigator.of(context).pop();
    } catch (e) {
      // Handle error jika terjadi masalah saat mengirim ke Firestore
      print('Error adding transaction: $e');
      // Anda dapat menambahkan logika lain di sini, seperti menampilkan pesan kesalahan kepada pengguna
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(widget.isExpense ? 'Tambah Pengeluaran' : 'Tambah Penghasilan'),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            TextField(
              controller: _nameController,
              decoration: InputDecoration(labelText: 'Nama'),
            ),
            TextField(
              controller: _categoryController,
              decoration: InputDecoration(labelText: 'Kategori'),
            ),
            TextField(
              controller: _amountController,
              decoration: InputDecoration(labelText: 'Jumlah'),
              keyboardType: TextInputType.number,
            ),
            ListTile(
              title: Text("Tanggal: ${_selectedDate.toLocal()}".split(' ')[0]),
              trailing: Icon(Icons.keyboard_arrow_down),
              onTap: () => _selectDate(context),
            ),
          ],
        ),
      ),
      actions: <Widget>[
        TextButton(
          onPressed: () {
            final String name = _nameController.text;
            final String category = _categoryController.text;
            final double amount = double.tryParse(_amountController.text) ?? 0.0;
            final DateTime date = _selectedDate;

            // Panggil fungsi untuk menambahkan transaksi ke Firestore
            _addTransactionToFirestore(name, category, amount, date);
          },
          child: Text('Tambah'),
        ),
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: Text('Batal'),
        ),
      ],
    );
  }
}
