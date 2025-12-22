import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';
import 'firebase_options.dart';

// Providers
import 'providers/auth_provider.dart';
import 'providers/pet_provider.dart';
import 'providers/feeding_point_provider.dart';
import 'providers/theme_provider.dart';
import 'providers/chat_provider.dart';

// Utils
import 'utils/app_theme.dart';

// Screens
import 'screens/splash_screen.dart';
import 'screens/login_screen.dart';
import 'screens/home_screen.dart';
import 'screens/available_animals_screen.dart';
import 'screens/playdates_screen.dart';
import 'screens/chat_list_screen.dart';
import 'screens/pet_detail_screen.dart';
import 'screens/profile_screen.dart';
import 'screens/feeding_point_screen.dart';
import 'screens/add_feeding_point_screen.dart';
import 'screens/add_new_pet_screen.dart';
import 'screens/chat_screen.dart';
import 'screens/reminder_screen.dart';

// Auth Wrapper
import 'screens/auth_wrapper.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Initialize Firebase
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  
  runApp(const PawfectApp());
}

class PawfectApp extends StatelessWidget {
  const PawfectApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        // Auth Provider
        ChangeNotifierProvider(create: (_) => AuthProvider()),
        
        // Pet Provider
        ChangeNotifierProvider(create: (_) => PetProvider()),
        
        // Feeding Point Provider
        ChangeNotifierProvider(create: (_) => FeedingPointProvider()),
        
        // Theme Provider
        ChangeNotifierProvider(create: (_) => ThemeProvider()..initialize()),
        
        // Chat Provider
        ChangeNotifierProvider(create: (_) => ChatProvider()),
      ],
      child: Consumer<ThemeProvider>(
        builder: (context, themeProvider, child) {
          return MaterialApp(
            title: 'Pawfect Match',
            debugShowCheckedModeBanner: false,
            theme: AppTheme.lightTheme,
            darkTheme: AppTheme.darkTheme,
            themeMode: themeProvider.themeMode,
            initialRoute: '/',
            routes: {
              '/': (context) => const SplashScreen(),
              '/auth': (context) => const AuthWrapper(),
              '/login': (context) => const LoginScreen(),
              '/home': (context) => const HomeScreen(),
              '/animals': (context) => const AvailableAnimalsScreen(),
              '/playdates': (context) => const PlaydatesScreen(),
              '/chats': (context) => const ChatListScreen(),
              '/chat': (context) => const ChatScreen(),
              '/pet_detail': (context) => const PetDetailScreen(),
              '/profile': (context) => const ProfileScreen(),
              '/feeding_points': (context) => const FeedingPointsScreen(),
              '/add_feeding_point': (context) => const AddFeedingPointScreen(),
              '/add_pet': (context) => const AddNewPetScreen(),
              '/reminders': (context) => const ReminderScreen(),
            },
          );
        },
      ),
    );
  }
}
