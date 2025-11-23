import 'package:flutter/material.dart';
import 'dart:async';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Timer(const Duration(seconds: 3), () {
      Navigator.pushReplacementNamed(context, '/login');
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        decoration: const BoxDecoration(
          // Arkaplan Gradient
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFFFFEAEA), // Açık pembe
              Color(0xFFFFA07A), // Turuncu
            ],
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Logo Alanı
            Stack(
              alignment: Alignment.center,
              children: const [
                Icon(Icons.favorite, size: 100, color: Colors.redAccent),
                Icon(Icons.pets, size: 50, color: Colors.white),
              ],
            ),
            const SizedBox(height: 20),
            const Text(
              "PetConnect",
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: Colors.white,
                fontFamily: 'Arial', // Varsa özel font eklenebilir
              ),
            ),
          ],
        ),
      ),
    );
  }
}
