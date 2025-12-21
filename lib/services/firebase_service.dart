import 'package:firebase_core/firebase_core.dart';

class FirebaseService {
  static bool _isInitialized = false;
  static bool get isInitialized => _isInitialized;

  static Future<void> initialize() async {
    // Skip Firebase initialization for mock mode
    // Uncomment the following when Firebase is configured:
    // try {
    //   await Firebase.initializeApp(
    //     options: DefaultFirebaseOptions.currentPlatform,
    //   );
    //   _isInitialized = true;
    // } catch (e) {
    //   print('Firebase initialization error: $e');
    //   print('Running in mock mode');
    //   _isInitialized = false;
    // }
    
    // Running in mock mode (no Firebase)
    _isInitialized = false;
    print('Running in mock mode (Firebase not initialized)');
  }
}

