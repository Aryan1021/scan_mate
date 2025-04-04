import 'package:flutter/material.dart';

class ThemeProvider extends ChangeNotifier {
  bool isDarkMode = false;

  void toggleTheme() {
    isDarkMode = !isDarkMode;
    notifyListeners(); // Notify UI to update
  }

  ThemeData get themeData {
    return isDarkMode ? ThemeData.dark() : ThemeData.light();
  }
}
