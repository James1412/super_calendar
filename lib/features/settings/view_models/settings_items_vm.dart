import 'package:flutter/material.dart';

class SettingsItemViewModel extends ChangeNotifier {
  bool showLunarDate = false;

  void setShowLunarDate(bool value) {
    showLunarDate = value;
    notifyListeners();
  }

  // Week number
  List indexAndWeekNumList = [1, 2, 4, 6];
  int weekNumIndex = 3;
  void setWeekNum(int value) {
    weekNumIndex = value;
    notifyListeners();
  }

  // Event view (indicator, list)
  int eventViewIndex = 0;
  void setEventView(int value) {
    eventViewIndex = value;
    notifyListeners();
  }

  // Primary Color
  Color primaryColor = Colors.orange;
  void changePrimaryColor(Color color) {
    primaryColor = color;
    notifyListeners();
  }

  //Lunar.fromSolar(Solar.fromDate(details.date)).getDay().toString(),
}
