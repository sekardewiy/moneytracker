import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:money_tracker/pages/home_screen.dart';
import 'package:money_tracker/pages/register.dart'; // Import halaman registrasi

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool _isLoading = false;

  // Fungsi untuk melakukan login
  Future<void> _loginWithEmailAndPassword() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });

      try {
        UserCredential userCredential = await _auth.signInWithEmailAndPassword(
          email: _emailController.text,
          password: _passwordController.text,
        );

        // Jika login berhasil, navigasi ke halaman HomeScreen
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => HomeScreen()),
        );
      } catch (e) {
        setState(() {
          _isLoading = false;
        });
        print('Login error: $e');
        // Handle error login di sini
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: Text('Login Error'),
            content: Text('Gagal login, cek email dan password Anda.'),
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
  }

  // Fungsi untuk navigasi ke halaman registrasi
  void _goToRegisterPage() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => RegisterPage()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Login'),
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
                        child: Form(
                          key: _formKey,
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              // Logo atau gambar
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
                                  prefixIcon: Icon(Icons.email,
                                      color: Colors.grey[600]),
                                ),
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Email tidak boleh kosong';
                                  } else if (!RegExp(r'^[^@]+@[^@]+\.[^@]+')
                                      .hasMatch(value)) {
                                    return 'Masukkan email yang valid';
                                  }
                                  return null;
                                },
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
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Password tidak boleh kosong';
                                  } else if (value.length < 6) {
                                    return 'Password harus lebih dari 6 karakter';
                                  }
                                  return null;
                                },
                              ),
                              SizedBox(height: 20),
                              // Tombol Login
                              ElevatedButton(
                                onPressed: _loginWithEmailAndPassword,
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
                                  'Login',
                                  style: TextStyle(
                                      fontSize: 16, color: Colors.white),
                                ),
                              ),
                              SizedBox(height: 10),
                              // Tombol registrasi
                              TextButton(
                                onPressed: _goToRegisterPage,
                                child: Text(
                                  'Belum punya akun? Register disini',
                                  style: TextStyle(color: Colors.pink.shade200),
                                ),
                              ),
                            ],
                          ),
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
