import 'package:flutter/material.dart';

void main() {
  runApp(const MaterialApp(
    debugShowCheckedModeBanner: false,
    home: SplashScreen(),
  ));
}

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

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
              children: [
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