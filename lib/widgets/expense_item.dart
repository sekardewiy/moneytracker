import 'package:flutter/material.dart';

class ExpenseItem extends StatelessWidget {
  final int id;
  final String name;
  final String category;
  final double amount;
  final DateTime date;
  final IconData icon;

  ExpenseItem({
    required this.id,
    required this.name,
    required this.category,
    required this.amount,
    required this.date,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(icon), // Icon untuk kategori pengeluaran
      title: Text(name), // Judul item pengeluaran
      subtitle: Text(category), // Kategori item pengeluaran
      trailing: Text('Rp${amount.toStringAsFixed(0)}'), // Jumlah pengeluaran
    );
  }
}
