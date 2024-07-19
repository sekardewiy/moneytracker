import 'package:cloud_firestore/cloud_firestore.dart';

class Transaction {
  final String id;
  final String name;
  final String category;
  final DateTime date;
  final double amount;
  final bool isIncome;

  Transaction({
    required this.id,
    required this.name,
    required this.category,
    required this.date,
    required this.amount,
    required this.isIncome,
  });

  // Konversi objek Transaction menjadi Map untuk disimpan di Firestore
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'category': category,
      'date': date,
      'amount': amount,
      'isIncome': isIncome,
    };
  }

  // Buat objek Transaction dari snapshot Firestore
  factory Transaction.fromFirestore(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
    return Transaction(
      id: doc.id,
      name: data['name'],
      category: data['category'],
      date: (data['date'] as Timestamp).toDate(),
      amount: data['amount'].toDouble(),
      isIncome: data['isIncome'],
    );
  }
}
