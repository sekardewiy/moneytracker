import 'package:flutter/material.dart';

class IncomeItem extends StatelessWidget {
  final int id;
  final String name;
  final String category;
  final double amount;
  final DateTime date;

  const IncomeItem({
    Key? key,
    required this.id,
    required this.name,
    required this.category,
    required this.amount,
    required this.date,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: CircleAvatar(
        child: Icon(Icons.attach_money), // Icon untuk pemasukan
      ),
      title: Text(name), // Judul item pemasukan
      subtitle: Text(category), // Kategori item pemasukan
      trailing: Text('Rp${amount.toStringAsFixed(0)}'), // Jumlah pemasukan
    );
  }
}
