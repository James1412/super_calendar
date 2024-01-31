import 'package:flutter/material.dart';

class MoreFeatures extends ChangeNotifier {
  bool moreFeatures = false;

  void setMoreFeatures(bool value) {
    moreFeatures = value;
    notifyListeners();
  }
}
