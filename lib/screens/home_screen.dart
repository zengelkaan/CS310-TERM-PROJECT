import 'package:flutter/material.dart';
import '../widgets/custom_bottom_nav.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      // --- Üst Bar (Geri Butonu) ---
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        // Leading icon removed or set to null if it's the main screen
        leading: null,
        automaticallyImplyLeading: false,
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
                children: const [
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
                  _buildMenuItem(
                    title: "Adoption",
                    icon: Icons.pets_outlined,
                    route: '/animals',
                    context: context,
                  ),
                  _buildMenuItem(
                    title: "Dating",
                    icon: Icons.favorite,
                    iconColor: Colors.redAccent,
                    route: '/animals', // Using animals for dating too for now
                    context: context,
                  ),
                  _buildMenuItem(
                    title: "Profile",
                    icon: Icons.person_outline,
                    isBold: true,
                    route: '/profile',
                    context: context,
                  ),
                  _buildMenuItem(
                    title: "Food point",
                    icon: Icons.fastfood_outlined,
                    route: '/feeding_points',
                    context: context,
                  ),
                  _buildMenuItem(
                    title: "Reminders",
                    icon: Icons.notifications_none_outlined,
                    isBold: true,
                    route: '/reminders',
                    context: context,
                  ),
                  _buildMenuItem(
                    title: "Messages",
                    icon: Icons.chat_bubble_outline_outlined,
                    isBold: true,
                    route: '/chats',
                    context: context,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),

      // --- Alt Gezinti Çubuğu (Bottom Navigation) ---
      bottomNavigationBar: const CustomBottomNav(currentIndex: 0),
    );
  }

  // --- Grid İçindeki Tek Bir Butonu Oluşturan Yardımcı Fonksiyon ---
  Widget _buildMenuItem({
    required String title,
    required IconData icon,
    required String route,
    required BuildContext context,
    Color iconColor = Colors.black87,
    bool isBold = false,
  }) {
    return InkWell(
      onTap: () {
        Navigator.pushNamed(context, route);
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
                border: Border.all(color: Colors.pink.shade100, width: 0.5)),
            child: Text(
              title,
              textAlign: TextAlign.center,
              style: const TextStyle(
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
            shadows: isBold
                ? [
                    Shadow(color: iconColor, offset: const Offset(0.5, 0.5)),
                    Shadow(color: iconColor, offset: const Offset(-0.5, -0.5))
                  ]
                : null,
          ),
        ],
      ),
    );
  }
}
