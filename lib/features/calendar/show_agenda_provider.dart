import 'package:flutter/material.dart';

class ShowAgendaProvider extends ChangeNotifier {
  bool showAgenda = false;

  void setShowAgenda() {
    showAgenda = !showAgenda;
    notifyListeners();
  }
}
