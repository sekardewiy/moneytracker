import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:money_tracker/pages/home_screen.dart'; // Import halaman home screen

class RegisterPage extends StatefulWidget {
  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _isLoading = false;

  // Fungsi untuk melakukan registrasi
  Future<void> _registerWithEmailAndPassword() async {
    setState(() {
      _isLoading = true;
    });

    try {
      // Registrasi dengan email dan password
      UserCredential userCredential =
          await _auth.createUserWithEmailAndPassword(
        email: _emailController.text.trim(),
        password: _passwordController.text.trim(),
      );

      // Jika registrasi berhasil, navigasi ke halaman HomeScreen
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => HomeScreen()),
      );
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      print('Registrasi error: $e');
      // Handle error registrasi di sini
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text('Registrasi Error'),
          content: Text('Gagal registrasi, coba lagi nanti.'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('OK'),
            ),
          ],
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Registrasi'),
        centerTitle: true,
      ),
      body: Stack(
        children: [
          // Background gradient
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [Colors.pink.shade200, Colors.pink.shade500],
              ),
            ),
          ),
          Center(
            child: _isLoading
                ? CircularProgressIndicator()
                : SingleChildScrollView(
                    padding: EdgeInsets.all(16.0),
                    child: Card(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                      elevation: 5,
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            // Logo atau gambar (opsional)
                            SizedBox(
                              height: 240,
                              child: Image.asset(
                                'assets/logo.png',
                                fit: BoxFit.contain,
                              ),
                            ),
                            SizedBox(height: 20),
                            // Input email
                            TextFormField(
                              controller: _emailController,
                              keyboardType: TextInputType.emailAddress,
                              decoration: InputDecoration(
                                labelText: 'Email',
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                  borderSide: BorderSide.none,
                                ),
                                filled: true,
                                fillColor: Colors.white,
                                prefixIcon:
                                    Icon(Icons.email, color: Colors.grey[600]),
                              ),
                            ),
                            SizedBox(height: 20),
                            // Input password
                            TextFormField(
                              controller: _passwordController,
                              obscureText: true,
                              decoration: InputDecoration(
                                labelText: 'Password',
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                  borderSide: BorderSide.none,
                                ),
                                filled: true,
                                fillColor: Colors.white,
                                prefixIcon:
                                    Icon(Icons.lock, color: Colors.grey[600]),
                              ),
                            ),
                            SizedBox(height: 20),
                            // Tombol Registrasi
                            ElevatedButton(
                              onPressed: _registerWithEmailAndPassword,
                              style: ButtonStyle(
                                backgroundColor:
                                    MaterialStateProperty.all<Color>(
                                        Colors.pink),
                                shape:
                                    MaterialStateProperty.all<OutlinedBorder>(
                                  RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                ),
                                padding: MaterialStateProperty.all<
                                    EdgeInsetsGeometry>(
                                  EdgeInsets.symmetric(
                                      horizontal: 50, vertical: 15),
                                ),
                                elevation:
                                    MaterialStateProperty.all<double>(10),
                                shadowColor: MaterialStateProperty.all<Color>(
                                    Colors.pinkAccent),
                              ),
                              child: Text(
                                'Registrasi',
                                style: TextStyle(
                                    fontSize: 16, color: Colors.white),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }
}
