import 'package:flutter/material.dart';

class SettingsItemViewModel extends ChangeNotifier {
  bool showLunarDate = false;
  List indexAndWeekNumList = [1, 2, 4, 6];
  int weekNumIndex = 3;
  int eventViewIndex = 0;
  void setShowLunarDate(bool value) {
    showLunarDate = value;
    notifyListeners();
  }

  void setWeekNum(int value) {
    weekNumIndex = value;
    notifyListeners();
  }

  void setEventView(int value) {
    eventViewIndex = value;
    notifyListeners();
  }
  //Lunar.fromSolar(Solar.fromDate(details.date)).getDay().toString(),
}
