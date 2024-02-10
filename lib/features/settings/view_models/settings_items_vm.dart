import 'package:flutter/material.dart';

class SettingsItemViewModel extends ChangeNotifier {
  bool showLunarDate = false;
  List indexAndWeekNumList = [1, 2, 4, 6];
  int index = 3;
  void setShowLunarDate(bool value) {
    showLunarDate = value;
    notifyListeners();
  }

  void setWeekNum(int value) {
    index = value;
    notifyListeners();
  }
  //Lunar.fromSolar(Solar.fromDate(details.date)).getDay().toString(),
}
