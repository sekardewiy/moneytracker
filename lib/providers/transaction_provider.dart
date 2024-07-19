import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:money_tracker/models/transaction.dart' as MoneyTransaction;

class TransactionProvider {
  static Future<List<MoneyTransaction.Transaction>> getTransactions() async {
    // Mengambil koleksi 'transactions' dari Firestore
    var snapshot = await FirebaseFirestore.instance.collection('transactions').get();

    // Mengonversi data snapshot Firestore menjadi list transaksi
    List<MoneyTransaction.Transaction> transactions = snapshot.docs.map((doc) {
      return MoneyTransaction.Transaction(
        id: doc.id,
        name: doc['name'],
        category: doc['category'],
        date: (doc['date'] as Timestamp).toDate(),
        amount: doc['amount'].toDouble(),
        isIncome: doc['isIncome'],
      );
    }).toList();

    return transactions;
  }
}
