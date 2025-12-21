import 'package:flutter/material.dart';
import 'available_animals_screen.dart';
import 'profile_page.dart';
import '../feedingPoint_screen.dart';
import '../reminders_screen.dart';
import 'chat_list_screen.dart';
import '../addNewPat.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 3;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black87),
          onPressed: () {
            // Back button functionality
          },
        ),
      ),
      body: Column(
        children: [
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
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 25.0),
              child: GridView.count(
                crossAxisCount: 3,
                crossAxisSpacing: 20,
                mainAxisSpacing: 30,
                childAspectRatio: 0.75,
                children: [
                  _buildMenuItem(
                    title: "Adoption",
                    icon: Icons.pets_outlined,
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const AvailableAnimalsScreen(),
                        ),
                      );
                    },
                  ),
                  _buildMenuItem(
                    title: "Dating",
                    icon: Icons.favorite,
                    iconColor: Colors.redAccent,
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const AvailableAnimalsScreen(purpose: 'Dating'),
                        ),
                      );
                    },
                  ),
                  _buildMenuItem(
                    title: "Profile",
                    icon: Icons.person_outline,
                    isBold: true,
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const ProfilePage(),
                        ),
                      );
                    },
                  ),
                  _buildMenuItem(
                    title: "Food point",
                    icon: Icons.fastfood_outlined,
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const FeedingPointsScreen(),
                        ),
                      );
                    },
                  ),
                  _buildMenuItem(
                    title: "Reminders",
                    icon: Icons.notifications_none_outlined,
                    isBold: true,
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const ReminderScreen(),
                        ),
                      );
                    },
                  ),
                  _buildMenuItem(
                    title: "Messages",
                    icon: Icons.chat_bubble_outline_outlined,
                    isBold: true,
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const ChatListScreen(),
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
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
          BottomNavigationBarItem(icon: Icon(Icons.notifications_none), label: ''),
          BottomNavigationBarItem(icon: Icon(Icons.volunteer_activism), label: ''),
          BottomNavigationBarItem(icon: Icon(Icons.storefront_outlined), label: ''),
          BottomNavigationBarItem(icon: Icon(Icons.home_outlined, size: 30), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.person_outline), label: ''),
          BottomNavigationBarItem(icon: Icon(Icons.chat_bubble_outline), label: ''),
          BottomNavigationBarItem(icon: Icon(Icons.favorite_border), label: ''),
        ],
      ),
    );
  }

  Widget _buildMenuItem({
    required String title,
    required IconData icon,
    Color iconColor = Colors.black87,
    bool isBold = false,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: 12),
            decoration: BoxDecoration(
              color: const Color(0xFFF8E1F4),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.pink.shade100, width: 0.5),
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
          Icon(
            icon,
            size: 32,
            color: iconColor,
            shadows: isBold
                ? [
                    Shadow(color: iconColor, offset: Offset(0.5, 0.5)),
                    Shadow(color: iconColor, offset: Offset(-0.5, -0.5))
                  ]
                : null,
          ),
        ],
      ),
    );
  }
}

