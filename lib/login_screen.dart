import 'package:flutter/material.dart';

void main() {
  runApp(const MaterialApp(
    debugShowCheckedModeBanner: false,
    home: LoginScreen(),
  ));
}

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFFFFEAEA),
              Color(0xFFFFA07A),
            ],
          ),
        ),
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 30.0),
            child: Column(
              children: [
                const SizedBox(height: 80),

                // Üstteki Logo
                Stack(
                  alignment: Alignment.center,
                  children: [
                    Icon(Icons.favorite, size: 100, color: Colors.redAccent),
                    Icon(Icons.pets, size: 50, color: Colors.white),
                  ],
                ),
                const SizedBox(height: 10),
                const Text(
                  "PetConnect",
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),

                const SizedBox(height: 30),

                // Profil Avatarı
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.white.withOpacity(0.8),
                    border: Border.all(color: Colors.black54),
                  ),
                  child: const Icon(Icons.person_outline, size: 50, color: Colors.black87),
                ),

                const SizedBox(height: 30),

                // Form Kutusu
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: const Color(0xFFFFF5F0),
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        blurRadius: 10,
                        offset: const Offset(0, 5),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text("Email Address:", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12)),
                      const TextField(
                        decoration: InputDecoration(
                          isDense: true,
                          border: InputBorder.none,
                          contentPadding: EdgeInsets.symmetric(vertical: 5),
                        ),
                      ),
                      const Divider(color: Colors.black26),
                      const SizedBox(height: 10),
                      const Text("Password:", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12)),
                      const TextField(
                        obscureText: true,
                        decoration: InputDecoration(
                          isDense: true,
                          border: InputBorder.none,
                          contentPadding: EdgeInsets.symmetric(vertical: 5),
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 10),

                // Linkler
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text("Forgot your password?", style: TextStyle(fontSize: 12)),
                ),
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: const [
                    Text("Don't have an account? ", style: TextStyle(fontSize: 12)),
                    Text("Sign up", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12)),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}