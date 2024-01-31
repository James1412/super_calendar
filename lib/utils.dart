import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:super_calendar/features/darkmode/dark_mode_provider.dart';

DateTime getOnlyDate(DateTime date) {
  return DateTime(date.year, date.month, date.day);
}

String getOnlyTime(DateTime datetime) {
  return DateFormat.jm().format(datetime);
}

String getDayName(DateTime dateTime) {
  return getDay(dateTime);
}

String getDay(DateTime date) {
  switch (date.weekday) {
    case (1):
      return "MON";
    case (2):
      return "TUE";
    case (3):
      return "WED";
    case (4):
      return "THU";
    case (5):
      return "FRI";
    case (6):
      return "SAT";
    default:
      return "SUN";
  }
}

bool isDarkMode(BuildContext context) {
  return context.watch<DarkModeProvider>().isDarkMode;
}
