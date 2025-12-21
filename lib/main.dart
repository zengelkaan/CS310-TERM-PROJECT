import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'services/firebase_service.dart';
import 'services/preference_service.dart';
import 'providers/auth_provider.dart';
import 'providers/pet_provider.dart';
import 'providers/pet_provider_mock.dart';
import 'providers/feeding_point_provider.dart';
import 'providers/vaccination_provider.dart';
import 'providers/message_provider.dart';
import 'screens/auth_wrapper.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Initialize Firebase (will run in mock mode if not configured)
  await FirebaseService.initialize();
  
  runApp(const PetConnectApp());
}

class PetConnectApp extends StatefulWidget {
  const PetConnectApp({super.key});

  @override
  State<PetConnectApp> createState() => _PetConnectAppState();
}

class _PetConnectAppState extends State<PetConnectApp> {
  ThemeMode _themeMode = ThemeMode.light;

  @override
  void initState() {
    super.initState();
    _loadTheme();
  }

  Future<void> _loadTheme() async {
    final themeMode = await PreferenceService.getThemeMode();
    setState(() {
      if (themeMode == 'dark') {
        _themeMode = ThemeMode.dark;
      } else {
        _themeMode = ThemeMode.light;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    // Use mock provider if Firebase is not initialized
    final useMock = !FirebaseService.isInitialized;
    
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthProvider()),
        ChangeNotifierProvider(
          create: (_) => useMock ? PetProviderMock() : PetProvider(),
        ),
        ChangeNotifierProvider(create: (_) => FeedingPointProvider()),
        ChangeNotifierProvider(create: (_) => VaccinationProvider()),
        ChangeNotifierProvider(create: (_) => MessageProvider()),
      ],
      child: MaterialApp(
        title: 'PetConnect',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          primarySwatch: Colors.blueGrey,
          fontFamily: 'Roboto',
          useMaterial3: true,
        ),
        darkTheme: ThemeData(
          brightness: Brightness.dark,
          primarySwatch: Colors.blueGrey,
          fontFamily: 'Roboto',
          useMaterial3: true,
        ),
        themeMode: _themeMode,
        home: const AuthWrapper(),
      ),
    );
  }
}
