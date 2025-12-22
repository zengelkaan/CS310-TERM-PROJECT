import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ThemeProvider extends ChangeNotifier {
  static const String _themeKey = 'isDarkMode';
  static const String _lastTabKey = 'lastSelectedTab';
  
  bool _isDarkMode = false;
  int _lastSelectedTab = 0;
  bool _isInitialized = false;

  // Getters
  bool get isDarkMode => _isDarkMode;
  int get lastSelectedTab => _lastSelectedTab;
  bool get isInitialized => _isInitialized;
  ThemeMode get themeMode => _isDarkMode ? ThemeMode.dark : ThemeMode.light;

  // Initialize - load saved preferences
  Future<void> initialize() async {
    if (_isInitialized) return;
    
    try {
      final prefs = await SharedPreferences.getInstance();
      _isDarkMode = prefs.getBool(_themeKey) ?? false;
      _lastSelectedTab = prefs.getInt(_lastTabKey) ?? 0;
      _isInitialized = true;
      notifyListeners();
    } catch (e) {
      // If SharedPreferences fails, use defaults
      _isInitialized = true;
      notifyListeners();
    }
  }

  // Toggle theme mode
  Future<void> toggleTheme() async {
    _isDarkMode = !_isDarkMode;
    notifyListeners();
    
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool(_themeKey, _isDarkMode);
    } catch (e) {
      // Silently fail if storage fails
    }
  }

  // Set theme mode directly
  Future<void> setDarkMode(bool isDark) async {
    if (_isDarkMode == isDark) return;
    
    _isDarkMode = isDark;
    notifyListeners();
    
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool(_themeKey, _isDarkMode);
    } catch (e) {
      // Silently fail if storage fails
    }
  }

  // Save last selected tab
  Future<void> setLastSelectedTab(int tabIndex) async {
    if (_lastSelectedTab == tabIndex) return;
    
    _lastSelectedTab = tabIndex;
    notifyListeners();
    
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setInt(_lastTabKey, _lastSelectedTab);
    } catch (e) {
      // Silently fail if storage fails
    }
  }
}

