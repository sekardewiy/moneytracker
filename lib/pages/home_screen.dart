import 'package:flutter/material.dart';
import 'package:money_tracker/pages/home_page.dart'; // Import halaman HomePage
import 'package:animated_text_kit/animated_text_kit.dart'; // Import package animasi teks

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Money Tracker',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.white, // Ubah warna teks menjadi putih
          ),
        ),
        backgroundColor: Colors.pinkAccent,
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.pink[50]!, Colors.pink[100]!],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Center(
          child: Card(
            elevation: 8,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15),
            ),
            margin: EdgeInsets.symmetric(horizontal: 20),
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Image.asset(
                    'assets/logo.png', // Sesuaikan dengan path dan nama file logo Anda
                    height: 240,
                    width: 240,
                  ),
                  SizedBox(height: 20),
                  AnimatedTextKit(
                    animatedTexts: [
                      TypewriterAnimatedText(
                        'Selamat datang di Money Tracker',
                        textStyle: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                        ),
                        speed: Duration(milliseconds: 100),
                      ),
                    ],
                    totalRepeatCount: 1,
                    pause: Duration(milliseconds: 1000),
                    displayFullTextOnTap: true,
                  ),
                  SizedBox(height: 10),
                  AnimatedTextKit(
                    animatedTexts: [
                      TypewriterAnimatedText(
                        'Kelola keuangan Anda dengan lebih mudah',
                        textStyle: TextStyle(
                          fontSize: 16,
                        ),
                        speed: Duration(milliseconds: 100),
                      ),
                    ],
                    totalRepeatCount: 1,
                    pause: Duration(milliseconds: 1000),
                    displayFullTextOnTap: true,
                  ),
                  SizedBox(height: 30),
                  ElevatedButton(
                    onPressed: () {
                      // Navigasi ke halaman HomePage saat tombol diklik
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => MyHomePage()),
                      );
                    },
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 30.0, vertical: 15.0),
                      child: Text(
                        'Mulai Sekarang',
                        style: TextStyle(
                          fontSize: 18,
                          color: Colors.white, // Ubah warna teks menjadi putih
                        ),
                      ),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.pink,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
