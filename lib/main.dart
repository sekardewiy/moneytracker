import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:money_tracker/pages/home_page.dart' as home;
import 'package:money_tracker/pages/wallet_page.dart';
import 'package:money_tracker/pages/analysis_page.dart';
import 'package:money_tracker/pages/settings_page.dart';
import 'package:money_tracker/models/transaction.dart' as txn;
import 'package:money_tracker/pages/login_page.dart';
import 'package:money_tracker/pages/register.dart';
import 'package:money_tracker/pages/home_screen.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Money Tracker',
      theme: ThemeData(
        primarySwatch: Colors.pink,
      ),
      debugShowCheckedModeBanner: false,
      home: AuthenticationWrapper(),
      routes: {
        '/profile': (context) => ProfilePage(),
        '/notifications': (context) => NotificationsPage(),
        '/security': (context) => SecurityPage(),
        '/language': (context) => LanguagePage(),
        '/help': (context) => HelpPage(),
        '/about': (context) => AboutPage(),
      },
    );
  }
}

class AuthenticationWrapper extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        }

        if (snapshot.hasData && snapshot.data != null) {
          // User sudah login
          return HomeScreen();
        } else {
          // User belum login
          return LoginPage();
        }
      },
    );
  }
}

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;

  // Contoh daftar transaksi
  final List<txn.Transaction> exampleTransactions = [
    txn.Transaction(
      id: '1',
      name: 'Gaji',
      category: 'Pemasukan',
      date: DateTime.now(),
      amount: 5000000,
      isIncome: true,
    ),
    txn.Transaction(
      id: '2',
      name: 'Makan',
      category: 'Makanan',
      date: DateTime.now(),
      amount: 50000,
      isIncome: false,
    ),
  ];

  late final List<Widget> _pages;

  @override
  void initState() {
    super.initState();
    _pages = [
      home.MyHomePage(),
      WalletPage(),
      AnalysisPage(transactions: exampleTransactions),
      SettingsPage(),
    ];
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.book),
            label: 'Buku',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.account_balance_wallet),
            label: 'Dompet',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.pie_chart),
            label: 'Analisis',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings),
            label: 'Pengaturan',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.pink,
        unselectedItemColor: Colors.grey,
        onTap: _onItemTapped,  // Gunakan metode _onItemTapped
      ),
    );
  }
}

class SettingsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Pengaturan'),
        backgroundColor: Colors.pinkAccent[100],
      ),
      body: ListView(
        children: [
          ListTile(
            leading: Icon(Icons.account_circle),
            title: Text('Profil'),
            subtitle: Text('Kelola informasi profil Anda'),
            trailing: Icon(Icons.arrow_forward),
            onTap: () {
              Navigator.pushNamed(context, '/profile');
            },
          ),
          ListTile(
            leading: Icon(Icons.notifications),
            title: Text('Notifikasi'),
            subtitle: Text('Atur preferensi notifikasi'),
            trailing: Icon(Icons.arrow_forward),
            onTap: () {
              Navigator.pushNamed(context, '/notifications');
            },
          ),
          ListTile(
            leading: Icon(Icons.lock),
            title: Text('Keamanan'),
            subtitle: Text('Ubah kata sandi atau pengaturan keamanan lainnya'),
            trailing: Icon(Icons.arrow_forward),
            onTap: () {
              Navigator.pushNamed(context, '/security');
            },
          ),
          ListTile(
            leading: Icon(Icons.language),
            title: Text('Bahasa'),
            subtitle: Text('Pilih bahasa aplikasi'),
            trailing: Icon(Icons.arrow_forward),
            onTap: () {
              Navigator.pushNamed(context, '/language');
            },
          ),
          ListTile(
            leading: Icon(Icons.help),
            title: Text('Bantuan'),
            subtitle: Text('Pusat bantuan dan FAQ'),
            trailing: Icon(Icons.arrow_forward),
            onTap: () {
              Navigator.pushNamed(context, '/help');
            },
          ),
          ListTile(
            leading: Icon(Icons.info),
            title: Text('Tentang Aplikasi'),
            subtitle: Text('Informasi tentang aplikasi'),
            trailing: Icon(Icons.arrow_forward),
            onTap: () {
              Navigator.pushNamed(context, '/about');
            },
          ),
        ],
      ),
    );
  }
}

class ProfilePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Profil'),
      ),
      body: Center(
        child: Padding(
          padding: EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CircleAvatar(
                radius: 60,
                backgroundImage: AssetImage('assets/images/profile_image.png'), // Ganti dengan gambar profil pengguna
              ),
              SizedBox(height: 20),
              Text(
                'Nama Pengguna',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 10),
              Text(
                'Email: nama@email.com', // Ganti dengan email pengguna
                style: TextStyle(fontSize: 18),
              ),
              SizedBox(height: 10),
              Text(
                'Nomor Telepon: +62 123 4567 8901', // Ganti dengan nomor telepon pengguna
                style: TextStyle(fontSize: 18),
              ),
              SizedBox(height: 30),
              ElevatedButton(
                onPressed: () {
                  // Implement action for editing profile
                  // Navigator.push(context, MaterialPageRoute(builder: (context) => EditProfilePage()));
                },
                child: Text('Edit Profil'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class NotificationsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Notifikasi'),
      ),
      body: ListView.builder(
        itemCount: dummyNotifications.length,
        itemBuilder: (context, index) {
          return ListTile(
            leading: Icon(Icons.notifications),
            title: Text(dummyNotifications[index].title),
            subtitle: Text(dummyNotifications[index].message),
            trailing: Icon(Icons.arrow_forward),
            onTap: () {
              // Implement action when notification item is tapped
            },
          );
        },
      ),
    );
  }
}

// Dummy data for notifications (replace with actual data)
List<NotificationItem> dummyNotifications = [
  NotificationItem(
    title: 'Pesan Penting',
    message: 'Ada pembaruan aplikasi yang tersedia.',
  ),
  NotificationItem(
    title: 'Pesan Penting',
    message: 'Ada pembaruan aplikasi yang tersedia.',
  ),
  NotificationItem(
    title: 'Pesan Penting',
    message: 'Ada pembaruan aplikasi yang tersedia.',
  ),
];

// Model class for notification item (replace with actual model)
class NotificationItem {
  final String title;
  final String message;

  NotificationItem({required this.title, required this.message});
}

class SecurityPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Keamanan'),
      ),
      body: Padding(
        padding: EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.lock, size: 100),
            SizedBox(height: 20),
            Text(
              'Pengaturan Keamanan',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 20),
            ListTile(
              leading: Icon(Icons.vpn_key),
              title: Text('Ubah Kata Sandi'),
              subtitle: Text('Ubah kata sandi untuk akun Anda'),
              onTap: () {
                // Implement action for changing password
              },
            ),
            Divider(),
            ListTile(
              leading: Icon(Icons.security),
              title: Text('Verifikasi Dua Langkah'),
              subtitle: Text('Aktifkan verifikasi dua langkah untuk keamanan tambahan'),
              onTap: () {
                // Implement action for enabling two-factor authentication
              },
            ),
            Divider(),
            ListTile(
              leading: Icon(Icons.email),
              title: Text('Email Verifikasi'),
              subtitle: Text('Atur pengaturan verifikasi email'),
              onTap: () {
                // Implement action for email verification settings
              },
            ),
            Divider(),
            ListTile(
              leading: Icon(Icons.person),
              title: Text('Pengaturan Akun'),
              subtitle: Text('Lihat dan kelola pengaturan akun Anda'),
              onTap: () {
                // Implement action for account settings
              },
            ),
          ],
        ),
      ),
    );
  }
}


class LanguagePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Bahasa'),
      ),
      body: Padding(
        padding: EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.language, size: 100, color: Colors.blue),
            SizedBox(height: 20),
            Text(
              'Pilih Bahasa Aplikasi',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                // Implement action for language selection
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      title: Text('Pilih Bahasa'),
                      content: SingleChildScrollView(
                        child: ListBody(
                          children: [
                            buildLanguageTile(context, 'English'),
                            buildLanguageTile(context, 'Indonesian'),
                            buildLanguageTile(context, 'Spanish'),
                            buildLanguageTile(context, 'French'),
                          ],
                        ),
                      ),
                      actions: <Widget>[
                        TextButton(
                          child: Text('Batal'),
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                        ),
                      ],
                    );
                  },
                );
              },
              child: Text('Pilih Bahasa'),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildLanguageTile(BuildContext context, String language) {
    return ListTile(
      title: Text(language),
      onTap: () {
        // Implement logic for language selection
        Navigator.of(context).pop(); // Close the dialog
        // You can implement further actions here, such as changing the app language
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Bahasa $language dipilih.'),
            duration: Duration(seconds: 2),
          ),
        );
      },
    );
  }
}

class HelpPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Bantuan'),
      ),
      body: Padding(
        padding: EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.help, size: 100, color: Colors.orange),
            SizedBox(height: 20),
            Text(
              'Pusat Bantuan dan FAQ',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                // Implement action for help and FAQ
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => HelpDetailsPage(),
                  ),
                );
              },
              child: Text('Bantuan'),
            ),
          ],
        ),
      ),
    );
  }
}

class HelpDetailsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Bantuan dan FAQ'),
      ),
      body: ListView(
        padding: EdgeInsets.all(20.0),
        children: [
          buildFAQTile(
            context,
            'Bagaimana cara mengubah kata sandi?',
            'Untuk mengubah kata sandi, ikuti langkah-langkah berikut...',
          ),
          buildFAQTile(
            context,
            'Apa yang harus dilakukan jika lupa kata sandi?',
            'Jika Anda lupa kata sandi, Anda dapat melakukan reset...',
          ),
          buildFAQTile(
            context,
            'Bagaimana cara menghubungi layanan pelanggan?',
            'Anda dapat menghubungi layanan pelanggan kami melalui...',
          ),
          buildFAQTile(
            context,
            'Apakah aplikasi ini gratis?',
            'Ya, aplikasi ini dapat digunakan secara gratis...',
          ),
        ],
      ),
    );
  }

  Widget buildFAQTile(BuildContext context, String question, String answer) {
    return ExpansionTile(
      title: Text(question),
      children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
          child: Text(answer),
        ),
      ],
    );
  }
}


class AboutPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Tentang Aplikasi'),
      ),
      body: Padding(
        padding: EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.info, size: 100, color: Colors.blue),
            SizedBox(height: 20),
            Text(
              'Informasi tentang Aplikasi',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 20),
            Text(
              'Money Tracker adalah aplikasi untuk melacak keuangan pribadi Anda. '
              'Dengan Money Tracker, Anda dapat mencatat transaksi, menganalisis pengeluaran, '
              'dan mengatur pengaturan keamanan dan notifikasi.',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 18),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                // Implement action for app information
                showLicensePage(
                  context: context,
                  applicationName: 'Money Tracker',
                  applicationVersion: '1.0.0',
                  applicationIcon: Icon(Icons.info),
                  applicationLegalese: '© 2024 Money Tracker. All rights reserved.',
                );
              },
              child: Text('Tentang Aplikasi'),
            ),
          ],
        ),
      ),
    );
  }
}