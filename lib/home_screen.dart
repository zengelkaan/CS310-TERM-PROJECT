import 'package:flutter/material.dart';

void main() {
  runApp(const MaterialApp(
    debugShowCheckedModeBanner: false,
    home: HomeScreen(),
  ));
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  // Alt menüde hangi sekmenin aktif olduğunu tutar (Şu an Ev ikonu: index 3)
  int _selectedIndex = 3;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      // --- Üst Bar (Geri Butonu) ---
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black87),
          onPressed: () {
            print("Geri tuşuna basıldı");
          },
        ),
      ),

      // --- Ana Gövde ---
      body: Column(
        children: [
          // 1. Üstteki Büyük Logo
          Center(
            child: Container(
              margin: const EdgeInsets.symmetric(vertical: 20),
              child: Stack(
                alignment: Alignment.center,
                children: [
                  Icon(Icons.favorite, size: 160, color: Colors.redAccent),
                  Icon(Icons.pets, size: 70, color: Colors.white),
                ],
              ),
            ),
          ),

          const SizedBox(height: 20),

          // 2. Grid Menü (6 Buton)
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 25.0),
              child: GridView.count(
                crossAxisCount: 3, // Yan yana 3 tane
                crossAxisSpacing: 20, // Yatay boşluk
                mainAxisSpacing: 30, // Dikey boşluk
                childAspectRatio: 0.75, // Buton oranları
                children: [
                  _buildMenuItem(title: "Adoption", icon: Icons.pets_outlined),
                  _buildMenuItem(title: "Dating", icon: Icons.favorite, iconColor: Colors.redAccent),
                  _buildMenuItem(title: "Profile", icon: Icons.person_outline, isBold: true),
                  _buildMenuItem(title: "Food point", icon: Icons.fastfood_outlined),
                  _buildMenuItem(title: "Reminders", icon: Icons.notifications_none_outlined, isBold: true),
                  _buildMenuItem(title: "Messages", icon: Icons.chat_bubble_outline_outlined, isBold: true),
                ],
              ),
            ),
          ),
        ],
      ),

      // --- Alt Gezinti Çubuğu (Bottom Navigation) ---
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        backgroundColor: Colors.white,
        selectedItemColor: Colors.black87,
        unselectedItemColor: Colors.black45,
        showSelectedLabels: false,
        showUnselectedLabels: false,
        currentIndex: _selectedIndex,
        onTap: (index) {
          setState(() {
            _selectedIndex = index;
          });
        },
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.notifications_none), label: ''), // Zil
          // DÜZELTİLEN SATIR: 'Volunteer' ikonu yerine standart bir ikon kullandım
          BottomNavigationBarItem(icon: Icon(Icons.volunteer_activism), label: ''),
          BottomNavigationBarItem(icon: Icon(Icons.storefront_outlined), label: ''), // Market
          BottomNavigationBarItem(icon: Icon(Icons.home_outlined, size: 30), label: 'Home'), // Ana Sayfa
          BottomNavigationBarItem(icon: Icon(Icons.person_outline), label: ''), // Profil
          BottomNavigationBarItem(icon: Icon(Icons.chat_bubble_outline), label: ''), // Mesaj
          BottomNavigationBarItem(icon: Icon(Icons.favorite_border), label: ''), // Kalp
        ],
      ),
    );
  }

  // --- Grid İçindeki Tek Bir Butonu Oluşturan Yardımcı Fonksiyon ---
  Widget _buildMenuItem({
    required String title,
    required IconData icon,
    Color iconColor = Colors.black87,
    bool isBold = false,
  }) {
    return InkWell(
      onTap: () {
        print("$title butonuna tıklandı");
      },
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          // Pembe Başlık Kutusu
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: 12),
            decoration: BoxDecoration(
                color: const Color(0xFFF8E1F4),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.pink.shade100, width: 0.5)
            ),
            child: Text(
              title,
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.black87,
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          const SizedBox(height: 15),
          // İkon
          Icon(
            icon,
            size: 32,
            color: iconColor,
            shadows: isBold ? [Shadow(color: iconColor, offset: Offset(0.5,0.5)), Shadow(color: iconColor, offset: Offset(-0.5,-0.5))] : null,
          ),
        ],
      ),
    );
  }
}