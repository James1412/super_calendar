import 'package:flutter/material.dart';

class LunarViewModel extends ChangeNotifier {
  bool showLunarDate = false;
  void setShowLunarDate(bool value) {
    showLunarDate = value;
    notifyListeners();
  }
  //Lunar.fromSolar(Solar.fromDate(details.date)).getDay().toString(),
}
