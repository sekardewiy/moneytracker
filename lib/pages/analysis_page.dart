import 'package:flutter/material.dart';
import 'package:money_tracker/models/transaction.dart';
import 'package:fl_chart/fl_chart.dart';

class AnalysisPage extends StatelessWidget {
  final List<Transaction> transactions;

  AnalysisPage({required this.transactions});

  @override
  Widget build(BuildContext context) {
    double totalIncome = 0.0;
    double totalExpense = 0.0;

    // Calculate total income and expense
    for (var transaction in transactions) {
      if (transaction.isIncome) {
        totalIncome += transaction.amount;
      } else {
        totalExpense += transaction.amount;
      }
    }

    // Create data for the pie chart
    var data = [
      TransactionSeries(
          'Pemasukan', totalIncome, Color.fromARGB(255, 224, 51, 120)),
      TransactionSeries('Pengeluaran', totalExpense, Colors.red),
    ];

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Analisis Keuangan',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: Colors.pinkAccent[100],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _buildPieChart(data),
            SizedBox(height: 16),
            _buildAnalysisCard(
              title: 'Total Pemasukan',
              amount: totalIncome,
              color: Color.fromARGB(255, 51, 224, 83),
              icon: Icons.arrow_upward,
            ),
            SizedBox(height: 16),
            _buildAnalysisCard(
              title: 'Total Pengeluaran',
              amount: totalExpense,
              color: Colors.red,
              icon: Icons.arrow_downward,
            ),
            SizedBox(height: 16),
            _buildAnalysisCard(
              title: 'Total Saldo',
              amount: totalIncome - totalExpense,
              color: Colors.blue,
              icon: Icons.account_balance_wallet,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPieChart(List<TransactionSeries> data) {
    List<PieChartSectionData> sections = data.map((transaction) {
      return PieChartSectionData(
        color: transaction.color,
        value: transaction.amount,
        title:
            '${transaction.category}\nRp ${transaction.amount.toStringAsFixed(0)}',
        radius: 80,
        titleStyle: TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
      );
    }).toList();

    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      child: Container(
        height: 300,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15),
          gradient: LinearGradient(
            colors: [
              Colors.pinkAccent.withOpacity(0.2),
              Colors.pink.withOpacity(0.4),
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: PieChart(
            PieChartData(
              sections: sections,
              borderData: FlBorderData(show: false),
              centerSpaceRadius: 50,
              sectionsSpace: 4,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildAnalysisCard(
      {required String title,
      required double amount,
      required Color color,
      required IconData icon}) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15),
          gradient: LinearGradient(
            colors: [color.withOpacity(0.2), color.withOpacity(0.4)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            children: [
              Icon(icon, size: 30, color: color),
              SizedBox(width: 12),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                  SizedBox(height: 4),
                  Text(
                    'Rp ${amount.toStringAsFixed(0)}',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// Model class for transaction series
class TransactionSeries {
  final String category;
  final double amount;
  final Color color;

  TransactionSeries(this.category, this.amount, this.color);
}
