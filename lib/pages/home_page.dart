import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../widgets/add_entry_dialog.dart';
import '../widgets/expense_item.dart';
import '../widgets/income_item.dart';
import 'package:money_tracker/main.dart';

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  CalendarFormat _calendarFormat = CalendarFormat.month;
  DateTime _selectedDay = DateTime.now();
  DateTime _focusedDay = DateTime.now();
  bool _isDropdownExpanded = false;
  bool _isIncomeDropdownExpanded = false;
  List<Map<String, dynamic>> _expenses = [];
  List<Map<String, dynamic>> _incomes = [];
  List<Map<String, dynamic>> _savingsGoals = [];

  final TextEditingController _savingsTitleController = TextEditingController();
  final TextEditingController _savingsTargetAmountController = TextEditingController();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  void dispose() {
    _savingsTitleController.dispose();
    _savingsTargetAmountController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    _fetchSavingsGoals();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Padding(
          padding: const EdgeInsets.only(left: 16.0),
          child: Text(
            'Buku',
            style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
          ),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16.0),
            child: Row(
              children: [
                IconButton(
                  icon: Icon(Icons.calendar_today, color: Colors.white),
                  onPressed: () {
                    _selectDate(context);
                  },
                ),
                IconButton(
                  icon: Icon(Icons.add_circle_outline, color: Colors.white),
                  onPressed: () {
                    _showAddSavingsDialog(context);
                  },
                ),
              ],
            ),
          ),
        ],
        backgroundColor: Colors.pinkAccent[100],
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.pink[50]!, Colors.pink[100]!],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Column(
          children: [
            TableCalendar(
              firstDay: DateTime.utc(2010, 10, 16),
              lastDay: DateTime.utc(2030, 3, 14),
              focusedDay: _focusedDay,
              calendarFormat: _calendarFormat,
              onFormatChanged: (format) {
                setState(() {
                  _calendarFormat = format;
                });
              },
              onPageChanged: (focusedDay) {
                setState(() {
                  _focusedDay = focusedDay;
                });
              },
              selectedDayPredicate: (day) {
                return isSameDay(_selectedDay, day);
              },
              onDaySelected: (selectedDay, focusedDay) {
                setState(() {
                  _selectedDay = selectedDay;
                  _focusedDay = focusedDay;
                });
              },
              calendarStyle: CalendarStyle(
                selectedDecoration: BoxDecoration(
                  color: Colors.pinkAccent,
                  shape: BoxShape.circle,
                ),
                todayDecoration: BoxDecoration(
                  color: Colors.pink,
                  shape: BoxShape.circle,
                ),
                selectedTextStyle: TextStyle(color: Colors.white),
                todayTextStyle: TextStyle(color: Colors.white),
              ),
            ),
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                      child: Text(
                        'Tabungan Impian',
                        style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.pink),
                      ),
                    ),
                    // List untuk Tabungan Impian
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: _savingsGoals.map((goal) {
                        return SavingsGoalItem(
                          title: goal['title'],
                          targetAmount: goal['targetAmount'],
                          currentAmount: goal['currentAmount'],
                          onAddAmount: (double amountToAdd) {
                            _addAmountToSavings(goal, amountToAdd);
                            _updateSavingsGoalInFirestore(goal); // Update Firestore
                          },
                        );
                      }).toList(),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showAddSelectionDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AddEntryDialog(
        isExpense: true, // Sesuaikan dengan kondisi yang sesuai
        onAddPressed: (icon, name, category, amount, date) {
          // Implementasi logika untuk menangani saat entri ditambahkan
          _addEntry(icon, name, category, amount, date);
        },
      ),
    );
  }

  void _selectDate(BuildContext context) async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _selectedDay,
      firstDate: DateTime(DateTime.now().year - 5),
      lastDate: DateTime(DateTime.now().year + 5),
    );

    if (picked != null && picked != _selectedDay) {
      setState(() {
        _selectedDay = picked;
      });
    }
  }

  void _addEntry(IconData icon, String name, String category, double amount, DateTime date) {
    setState(() {
      _expenses.add({
        'id': _expenses.length + 1,
        'icon': icon,
        'name': name,
        'category': category,
        'amount': amount,
        'date': date,
      });
    });
  }

  void _showAddSavingsDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => _buildAddSavingsDialog(context),
    );
  }

  Widget _buildAddSavingsDialog(BuildContext context) {
    return AlertDialog(
      title: Text('Tambah Tabungan Impian'),
      content: Container(
        color: Colors.pink[50], // Background color
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              decoration: InputDecoration(
                labelText: 'Nama Tabungan',
                labelStyle: TextStyle(color: Colors.white), // Text color
                border: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.white),
                ),
              ),
              controller: _savingsTitleController,
            ),
            SizedBox(height: 16),
            TextField(
              decoration: InputDecoration(
                labelText: 'Target Amount',
                labelStyle: TextStyle(color: Colors.white), // Text color
                border: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.white),
                ),
              ),
              controller: _savingsTargetAmountController,
              keyboardType: TextInputType.number,
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: Text(
            'Batal',
            style: TextStyle(color: Colors.pinkAccent), // Button color
          ),
        ),
        TextButton(
          onPressed: () {
            final newSavings = {
              'title': _savingsTitleController.text,
              'targetAmount': double.tryParse(_savingsTargetAmountController.text) ?? 0.0,
              'currentAmount': 0.0,
            };
            _addSavingsGoalToFirestore(newSavings); // Menambahkan tabungan ke Firestore
            setState(() {
              _savingsGoals.add(newSavings);
            });
            Navigator.of(context).pop();
          },
          child: Text(
            'Tambah',
            style: TextStyle(color: Colors.pinkAccent), // Button color
          ),
        ),
      ],
    );
  }

  void _addAmountToSavings(Map<String, dynamic> goal, double amountToAdd) {
    setState(() {
      goal['currentAmount'] += amountToAdd;
    });
  }

  void _fetchSavingsGoals() async {
    try {
      QuerySnapshot snapshot = await _firestore.collection('savingsGoals').get();
      setState(() {
        _savingsGoals = snapshot.docs.map((doc) {
          final data = doc.data() as Map<String, dynamic>;
          data['id'] = doc.id; // Menyimpan ID dokumen di dalam data tabungan
          return data;
        }).toList();
      });
    } catch (e) {
      print('Error fetching savings goals: $e');
    }
  }

  void _addSavingsGoalToFirestore(Map<String, dynamic> savingsGoal) async {
    try {
      final docRef = await _firestore.collection('savingsGoals').add(savingsGoal);
      // Simpan ID dokumen di koleksi
      setState(() {
        savingsGoal['id'] = docRef.id; // Simpan ID dokumen di dalam data tabungan
      });
    } catch (e) {
      print('Error adding savings goal: $e');
    }
  }

  void _updateSavingsGoalInFirestore(Map<String, dynamic> goal) async {
    try {
      final docId = _savingsGoals.firstWhere((element) => element['title'] == goal['title'])['id'];
      await _firestore.collection('savingsGoals').doc(docId).update({
        'currentAmount': goal['currentAmount'],
      });
    } catch (e) {
      print('Error updating savings goal: $e');
    }
  }
}

class SavingsGoalItem extends StatelessWidget {
  final String title;
  final double targetAmount;
  final double currentAmount;
  final ValueChanged<double> onAddAmount;

  SavingsGoalItem({
    required this.title,
    required this.targetAmount,
    required this.currentAmount,
    required this.onAddAmount,
  });

  @override
  Widget build(BuildContext context) {
    double progress = currentAmount / targetAmount;

    return Card(
      margin: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            LinearProgressIndicator(
              value: progress,
              backgroundColor: Colors.pink[50],
              valueColor: AlwaysStoppedAnimation<Color>(Colors.pinkAccent),
            ),
            SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Terkumpul: Rp${currentAmount.toStringAsFixed(0)}'),
                Text('Target: Rp${targetAmount.toStringAsFixed(0)}'),
              ],
            ),
            SizedBox(height: 8),
            ElevatedButton(
              onPressed: () {
                _showAddAmountDialog(context);
              },
              child: Text('Tambah Dana', style: TextStyle(color: Colors.white)), // White text
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.pinkAccent, // Button color
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
                padding: EdgeInsets.symmetric(vertical: 12.0, horizontal: 24.0),
              ),
            ),
            SizedBox(height: 8),
            if (currentAmount >= targetAmount)
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 16.0),
                child: Text(
                  'Dana sudah terkumpul',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.green,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  void _showAddAmountDialog(BuildContext context) {
    final TextEditingController amountController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Tambah Dana'),
          content: TextField(
            controller: amountController,
            keyboardType: TextInputType.number,
            decoration: InputDecoration(
              labelText: 'Jumlah',
              labelStyle: TextStyle(color: Colors.pinkAccent), // Text color
              border: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.pinkAccent),
              ),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text(
                'Batal',
                style: TextStyle(color: Colors.pinkAccent), // Button color
              ),
            ),
            TextButton(
              onPressed: () {
                final double amountToAdd = double.tryParse(amountController.text) ?? 0.0;
                onAddAmount(amountToAdd);
                Navigator.of(context).pop();
              },
              child: Text(
                'Tambah',
                style: TextStyle(color: Colors.pinkAccent), // Button color
              ),
            ),
          ],
        );
      },
    );
  }
}
