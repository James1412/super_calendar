import 'package:flutter/material.dart';

class DarkModeProvider extends ChangeNotifier {
  bool isDarkMode = false;
  void setDarkMode(bool value) {
    isDarkMode = value;
    notifyListeners();
  }
}
