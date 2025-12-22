import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/auth_provider.dart';
import '../widgets/custom_bottom_nav.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    final authProvider = context.watch<AuthProvider>();
    
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: null,
        automaticallyImplyLeading: false,
        actions: [
          // User greeting
          Padding(
            padding: const EdgeInsets.only(right: 8),
            child: Center(
              child: Text(
                'Hi, ${authProvider.userName.split(' ').first}!',
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: Colors.black87,
                ),
              ),
            ),
          ),
          // Logout button
          IconButton(
            icon: const Icon(Icons.logout, color: Colors.black54),
            onPressed: () => _showLogoutDialog(context),
            tooltip: 'Logout',
          ),
        ],
      ),

      body: Column(
        children: [
          // Logo:
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

          // Menu 
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
                    route: '/animals',
                    context: context,
                  ),
                  _buildMenuItem(
                    title: "Playdates",
                    icon: Icons.favorite,
                    iconColor: Colors.redAccent,
                    route: '/playdates',
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

      bottomNavigationBar: const CustomBottomNav(currentIndex: 0),
    );
  }

  void _showLogoutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Logout'),
        content: const Text('Are you sure you want to logout?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () async {
              Navigator.pop(ctx);
              await context.read<AuthProvider>().signOut();
              if (context.mounted) {
                Navigator.pushReplacementNamed(context, '/login');
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
            ),
            child: const Text('Logout'),
          ),
        ],
      ),
    );
  }

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
              style: const TextStyle(
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
