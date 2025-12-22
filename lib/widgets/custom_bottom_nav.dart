import 'package:flutter/material.dart';

class CustomBottomNav extends StatelessWidget {
  final int currentIndex;

  const CustomBottomNav({super.key, required this.currentIndex});

  void _onTap(BuildContext context, int index) {
    if (index == currentIndex) return;

    switch (index) {
      case 0:
        Navigator.pushReplacementNamed(context, '/home');
        break;
      case 1:
        Navigator.pushReplacementNamed(context, '/animals'); // Adoption
        break;
      case 2:
        Navigator.pushReplacementNamed(context, '/playdates');
        break;
      case 3:
        Navigator.pushReplacementNamed(context, '/feeding_points');
        break;
      case 4:
        Navigator.pushReplacementNamed(context, '/reminders');
        break;
      case 5:
        Navigator.pushReplacementNamed(context, '/chats');
        break;
      case 6:
        Navigator.pushReplacementNamed(context, '/profile');
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      currentIndex: currentIndex,
      onTap: (index) => _onTap(context, index),
      type: BottomNavigationBarType.fixed,
      selectedItemColor: Colors.pink,
      unselectedItemColor: Colors.grey,
      selectedFontSize: 12,
      unselectedFontSize: 12,
      items: const [
        BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
        BottomNavigationBarItem(icon: Icon(Icons.pets), label: 'Adoption'),
        BottomNavigationBarItem(icon: Icon(Icons.favorite), label: 'Playdates'),
        BottomNavigationBarItem(icon: Icon(Icons.location_on), label: 'Feeding'),
        BottomNavigationBarItem(icon: Icon(Icons.notifications), label: 'Reminders'),
        BottomNavigationBarItem(icon: Icon(Icons.chat), label: 'Chat'),
        BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
      ],
    );
  }
}
