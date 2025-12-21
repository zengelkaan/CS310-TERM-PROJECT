import 'package:shared_preferences/shared_preferences.dart';

class PreferenceService {
  static const String _themeKey = 'theme_mode';
  static const String _lastSelectedTabKey = 'last_selected_tab';
  static const String _onboardingCompletedKey = 'onboarding_completed';

  // Theme Mode (light/dark)
  static Future<void> setThemeMode(String themeMode) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_themeKey, themeMode);
  }

  static Future<String?> getThemeMode() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_themeKey);
  }

  // Last Selected Tab
  static Future<void> setLastSelectedTab(int tabIndex) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(_lastSelectedTabKey, tabIndex);
  }

  static Future<int?> getLastSelectedTab() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getInt(_lastSelectedTabKey);
  }

  // Onboarding Status
  static Future<void> setOnboardingCompleted(bool completed) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_onboardingCompletedKey, completed);
  }

  static Future<bool> getOnboardingCompleted() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_onboardingCompletedKey) ?? false;
  }

  // Clear all preferences
  static Future<void> clearAll() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
  }
}

