import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:money_tracker/models/transaction.dart';
import 'package:money_tracker/models/reminder.dart' as ReminderModel;

class WalletPage extends StatefulWidget {
  @override
  _WalletPageState createState() => _WalletPageState();
}

class _WalletPageState extends State<WalletPage> {
  double currentBalance = 1500000.0;
  double monthlyBudget = 5000000.0;
  List<Transaction> transactions = [
    Transaction(
      id: 't1',
      name: 'Pengeluaran 1',
      category: 'Belanja',
      date: DateTime(2024, 6, 1),
      amount: 500000.0,
      isIncome: false,
    ),
    Transaction(
      id: 't2',
      name: 'Pemasukan 1',
      category: 'Gaji',
      date: DateTime(2024, 6, 5),
      amount: 2000000.0,
      isIncome: true,
    ),
    Transaction(
      id: 't3',
      name: 'Pengeluaran 2',
      category: 'Hiburan',
      date: DateTime(2024, 6, 10),
      amount: 300000.0,
      isIncome: false,
    ),
  ];

  List<ReminderModel.Reminder> reminders = [
    ReminderModel.Reminder(
      name: 'Pembayaran Listrik',
      dueDate: DateTime(2024, 6, 15),
      isPaid: false,
    ),
    ReminderModel.Reminder(
      name: 'Pembayaran Internet',
      dueDate: DateTime(2024, 6, 20),
      isPaid: true,
    ),
  ];

  String selectedType = 'Semua';
  final _nameController = TextEditingController();
  final _amountController = TextEditingController();
  final _dateController = TextEditingController();
  final _categoryController = TextEditingController();
  final _budgetController = TextEditingController();
  final _reminderNameController = TextEditingController();
  final _reminderDateController = TextEditingController();
  String? _transactionType;

  @override
  void initState() {
    super.initState();
    _checkReminders();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Dompet',
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
        ),
        backgroundColor: Colors.pinkAccent[100],
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _buildCurrentBalanceCard(),
            SizedBox(height: 16),
            _buildFinancialPlanCard(),
            SizedBox(height: 16),
            _buildRemindersCard(),
            SizedBox(height: 16),
            _buildTransactionsCard(),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          _showAddTransactionDialog(context);
        },
        label: Text('Tambah Transaksi', style: TextStyle(color: Colors.white)),
        icon: Icon(Icons.add),
        backgroundColor: Colors.pinkAccent[100],
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }

  Widget _buildCurrentBalanceCard() {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      child: Container(
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
          child: Row(
            children: [
              Icon(
                Icons.account_balance_wallet,
                size: 30,
                color: Colors.pinkAccent[100],
              ),
              SizedBox(width: 12),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Saldo Saat Ini',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                  SizedBox(height: 4),
                  Text(
                    'Rp ${currentBalance.toStringAsFixed(0)}',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                ],
              ),
              Spacer(),
              IconButton(
                icon: Icon(Icons.add_circle, color: Colors.pinkAccent[100]),
                onPressed: () {
                  _showAddBalanceDialog(context);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFinancialPlanCard() {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      child: Container(
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
          child: Column(
            children: [
              Row(
                children: [
                  Icon(
                    Icons.insert_chart,
                    size: 30,
                    color: Colors.pinkAccent[100],
                  ),
                  SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Rencana Keuangan Bulanan',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.black87,
                          ),
                        ),
                        SizedBox(height: 4),
                        Text(
                          'Rp ${monthlyBudget.toStringAsFixed(0)}',
                          style: TextStyle(fontSize: 20, color: Colors.black87),
                        ),
                        SizedBox(height: 8),
                        Text(
                          'Sisa Anggaran Bulanan',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: _calculateRemainingBudget() >= 0
                                ? Colors.green
                                : Colors.red,
                          ),
                        ),
                        SizedBox(height: 4),
                        Text(
                          'Rp ${_calculateRemainingBudget().toStringAsFixed(0)}',
                          style: TextStyle(
                            fontSize: 20,
                            color: _calculateRemainingBudget() >= 0
                                ? Colors.green
                                : Colors.red,
                          ),
                        ),
                      ],
                    ),
                  ),
                  IconButton(
                    icon: Icon(Icons.edit, color: Colors.pinkAccent[100]),
                    onPressed: () {
                      _showEditBudgetDialog(context);
                    },
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildRemindersCard() {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      child: Container(
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
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(
                    Icons.notifications,
                    size: 30,
                    color: Colors.pinkAccent[100],
                  ),
                  SizedBox(width: 12),
                  Text(
                    'Reminder Pembayaran',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                  Spacer(),
                  IconButton(
                    icon: Icon(Icons.add_circle, color: Colors.pinkAccent[100]),
                    onPressed: () {
                      _showAddReminderDialog(context);
                    },
                  ),
                ],
              ),
              SizedBox(height: 8),
              ListView.builder(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                itemCount: reminders.length,
                itemBuilder: (context, index) {
                  final reminder = reminders[index];
                  return ListTile(
                    leading: IconButton(
                      icon: Icon(
                        reminder.isPaid
                            ? Icons.check_circle
                            : Icons.check_circle_outline,
                        color: reminder.isPaid ? Colors.green : Colors.red,
                      ),
                      onPressed: () {
                        setState(() {
                          reminder.isPaid = !reminder.isPaid;
                        });
                      },
                    ),
                    title: Text(reminder.name),
                    subtitle: Text(
                      DateFormat('dd MMM yyyy').format(reminder.dueDate),
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTransactionsCard() {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      child: Container(
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
          child: Column(
            children: [
              Row(
                children: [
                  Icon(
                    Icons.history,
                    size: 30,
                    color: Colors.pinkAccent[100],
                  ),
                  SizedBox(width: 12),
                  Text(
                    'Daftar Transaksi',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 8),
              ListView.builder(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                itemCount: transactions.length,
                itemBuilder: (context, index) {
                  final transaction = transactions[index];
                  return ListTile(
                    leading: Icon(
                      transaction.isIncome
                          ? Icons.arrow_upward
                          : Icons.arrow_downward,
                      color: transaction.isIncome ? Colors.green : Colors.red,
                    ),
                    title: Text(transaction.name),
                    subtitle: Text(
                      '${transaction.category} - ${DateFormat('dd MMM yyyy').format(transaction.date)}',
                    ),
                    trailing: Text(
                      'Rp ${transaction.amount.toStringAsFixed(0)}',
                      style: TextStyle(
                        color: transaction.isIncome ? Colors.green : Colors.red,
                      ),
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showAddTransactionDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        // Menggunakan StatefulBuilder untuk memastikan data dapat diubah dalam dialog
        return StatefulBuilder(
          builder: (context, setDialogState) {
            return AlertDialog(
              title: Text('Tambah Transaksi'),
              content: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextField(
                      controller: _nameController,
                      decoration: InputDecoration(labelText: 'Nama Transaksi'),
                    ),
                    TextField(
                      controller: _amountController,
                      decoration: InputDecoration(labelText: 'Jumlah'),
                      keyboardType: TextInputType.number,
                    ),
                    TextField(
                      controller: _categoryController,
                      decoration: InputDecoration(labelText: 'Kategori'),
                    ),
                    TextField(
                      controller: _dateController,
                      decoration: InputDecoration(labelText: 'Tanggal'),
                      readOnly: true,
                      onTap: () async {
                        final pickedDate = await showDatePicker(
                          context: context,
                          initialDate: DateTime.now(),
                          firstDate: DateTime(2000),
                          lastDate: DateTime(2101),
                        );
                        if (pickedDate != null) {
                          setDialogState(() {
                            _dateController.text =
                                DateFormat('dd MMM yyyy').format(pickedDate);
                          });
                        }
                      },
                    ),
                    Row(
                      children: [
                        Text('Jenis: '),
                        DropdownButton<String>(
                          value: _transactionType,
                          hint: Text('Pilih Jenis'),
                          items: <String>['Pemasukan', 'Pengeluaran']
                              .map((String value) {
                            return DropdownMenuItem<String>(
                              value: value,
                              child: Text(value),
                            );
                          }).toList(),
                          onChanged: (String? newValue) {
                            setDialogState(() {
                              _transactionType = newValue;
                            });
                          },
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Text('Batal'),
                ),
                ElevatedButton(
                  onPressed: () {
                    if (_nameController.text.isEmpty ||
                        _amountController.text.isEmpty ||
                        _dateController.text.isEmpty ||
                        _transactionType == null) {
                      return;
                    }

                    final newTransaction = Transaction(
                      id: DateTime.now().toString(),
                      name: _nameController.text,
                      category: _categoryController.text,
                      date:
                          DateFormat('dd MMM yyyy').parse(_dateController.text),
                      amount: double.parse(_amountController.text),
                      isIncome: _transactionType == 'Pemasukan',
                    );

                    // Menggunakan setState dari StatefulWidget untuk memperbarui list transaksi
                    setState(() {
                      transactions.add(newTransaction);
                    });

                    _nameController.clear();
                    _amountController.clear();
                    _dateController.clear();
                    _categoryController.clear();
                    _transactionType = null;

                    Navigator.of(context).pop();
                  },
                  child: Text('Simpan'),
                ),
              ],
            );
          },
        );
      },
    );
  }

  void _showAddReminderDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Tambah Pengingat'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: _reminderNameController,
                decoration: InputDecoration(labelText: 'Nama Pengingat'),
              ),
              TextField(
                controller: _reminderDateController,
                decoration: InputDecoration(labelText: 'Tanggal Jatuh Tempo'),
                readOnly: true,
                onTap: () async {
                  final pickedDate = await showDatePicker(
                    context: context,
                    initialDate: DateTime.now(),
                    firstDate: DateTime(2000),
                    lastDate: DateTime(2101),
                  );
                  if (pickedDate != null) {
                    _reminderDateController.text =
                        DateFormat('dd MMM yyyy').format(pickedDate);
                  }
                },
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Batal'),
            ),
            ElevatedButton(
              onPressed: () {
                if (_reminderNameController.text.isEmpty ||
                    _reminderDateController.text.isEmpty) {
                  return;
                }

                final newReminder = ReminderModel.Reminder(
                  name: _reminderNameController.text,
                  dueDate: DateFormat('dd MMM yyyy')
                      .parse(_reminderDateController.text),
                  isPaid: false,
                );

                setState(() {
                  reminders.add(newReminder);
                });

                _reminderNameController.clear();
                _reminderDateController.clear();

                Navigator.of(context).pop();
              },
              child: Text('Simpan'),
            ),
          ],
        );
      },
    );
  }

  void _showEditBudgetDialog(BuildContext context) {
    _budgetController.text = monthlyBudget.toStringAsFixed(0);

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Edit Rencana Keuangan Bulanan'),
          content: TextField(
            controller: _budgetController,
            decoration: InputDecoration(labelText: 'Anggaran Bulanan'),
            keyboardType: TextInputType.number,
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Batal'),
            ),
            ElevatedButton(
              onPressed: () {
                setState(() {
                  monthlyBudget = double.parse(_budgetController.text);
                });
                Navigator.of(context).pop();
              },
              child: Text('Simpan'),
            ),
          ],
        );
      },
    );
  }

  void _showAddBalanceDialog(BuildContext context) {
    final _amountController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Tambah Saldo'),
          content: TextField(
            controller: _amountController,
            decoration: InputDecoration(labelText: 'Jumlah'),
            keyboardType: TextInputType.number,
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Batal'),
            ),
            ElevatedButton(
              onPressed: () {
                setState(() {
                  currentBalance += double.parse(_amountController.text);
                });
                Navigator.of(context).pop();
              },
              child: Text('Simpan'),
            ),
          ],
        );
      },
    );
  }

  double _calculateRemainingBudget() {
    double totalExpense = transactions
        .where((tx) => !tx.isIncome)
        .fold(0.0, (sum, tx) => sum + tx.amount);
    return monthlyBudget - totalExpense;
  }

  void _checkReminders() {
    // Logic for checking reminders
  }
}
