import 'package:flutter/material.dart';
import 'screens/splash_screen.dart';
import 'screens/login_screen.dart';
import 'screens/home_screen.dart';
import 'screens/available_animals_screen.dart';
import 'screens/chat_list_screen.dart';
import 'screens/pet_detail_screen.dart';
import 'screens/profile_screen.dart';
import 'screens/feeding_point_screen.dart';
import 'screens/add_feeding_point_screen.dart';
import 'screens/add_new_pet_screen.dart';
import 'screens/chat_screen.dart';
import 'screens/reminder_screen.dart';

void main() {
  runApp(const PawfectApp());
}

class PawfectApp extends StatelessWidget {
  const PawfectApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Pawfect Match',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.pink,
        scaffoldBackgroundColor: Colors.white,
        fontFamily: 'Roboto', // Ensure this font is added in pubspec.yaml or use default
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => const SplashScreen(),
        '/login': (context) => const LoginScreen(),
        '/home': (context) => const HomeScreen(),
        '/animals': (context) => const AvailableAnimalsScreen(), // For Adoption/Dating
        '/chats': (context) => const ChatListScreen(), // List of chats
        '/chat': (context) => const ChatScreen(), // Individual chat
        '/pet_detail': (context) => const PetDetailScreen(),
        '/profile': (context) => const ProfileScreen(),
        '/feeding_points': (context) => const FeedingPointsScreen(),
        '/add_feeding_point': (context) => const AddFeedingPointScreen(),
        '/add_pet': (context) => const AddNewPetScreen(),
        '/reminders': (context) => const ReminderScreen(),
      },
    );
  }
}
