import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SplashProvider with ChangeNotifier {
  static const String _key = 'splashCompleted';
  
  // Get whether user has completed the splash screen before
  Future<bool> get hasCompletedSplash async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_key) ?? false;
  }

  // Mark that user has completed the splash screen (after login/signup)
  Future<void> markSplashCompleted() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_key, true);
    notifyListeners();
  }

  // Reset splash completed status (for logout)
  Future<void> resetSplashCompleted() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_key, false);
    notifyListeners();
  }

  // Track if initial splash animations have been shown in current session
  bool _initialSplashesShown = false;
  bool get initialSplashesShown => _initialSplashesShown;
  
  void markInitialSplashesShown() {
    _initialSplashesShown = true;
    notifyListeners();
  }
}