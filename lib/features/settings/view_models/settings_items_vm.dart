import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:super_calendar/features/calendar/view_models/data_source_vm.dart';

import '../models/holiday_model.dart';

class SettingsItemViewModel extends ChangeNotifier {
  // leading and trailing dates
  bool showLeadingAndTrailingDates = false;
  void setShowLeadingTrailingDates(bool value) {
    showLeadingAndTrailingDates = value;
    notifyListeners();
  }

  // Lunar dates
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

  // Holiday
  int holidayIndex = 0;
  static String holidayText = "flutter-super-calendar-holiday";
  void setHolidayIndex(int index) {
    holidayIndex = index;
    notifyListeners();
  }

  void addHolidays(List<HolidayModel> holidayModels, BuildContext context) {
    // Remove pre-existing holidays
    final dataSource =
        Provider.of<DataSourceViewModel>(context, listen: false).dataSource;
    dataSource.removeWhere(
        (element) => element.notes == SettingsItemViewModel.holidayText);

    // Then add new holidays
    for (HolidayModel holiday in holidayModels) {
      int year = int.parse(holiday.date.split('-')[0]);
      int month = int.parse(holiday.date.split('-')[1]);
      int day = int.parse(holiday.date.split('-')[2]);
      context.read<DataSourceViewModel>().addQuickNewAppointment(
            date: DateTime(year, month, day),
            time: null,
            text: holiday.holidayName,
            context: context,
            holiday: holidayText,
            color: Colors.red,
          );
    }
    notifyListeners();
  }

  //Lunar.fromSolar(Solar.fromDate(details.date)).getDay().toString(),
}
