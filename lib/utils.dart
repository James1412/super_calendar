import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:super_calendar/features/settings/view_models/dark_mode_provider.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';

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
      return "MO";
    case (2):
      return "TU";
    case (3):
      return "WE";
    case (4):
      return "TH";
    case (5):
      return "FR";
    case (6):
      return "SA";
    default:
      return "SU";
  }
}

String getThreeCharDay(DateTime date) {
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

List<Appointment> filterEventsByDate(
    DateTime selectedDate, List<Appointment> dataSource, bool isAllDay) {
  return dataSource
      .where((element) =>
          (selectedDate.isBefore(element.endTime) ||
              getOnlyDate(selectedDate)
                  .isAtSameMomentAs(getOnlyDate(element.endTime))) &&
          (selectedDate.isAfter(element.startTime) ||
              getOnlyDate(selectedDate)
                  .isAtSameMomentAs(getOnlyDate(element.startTime))) &&
          (isAllDay ? element.isAllDay : !element.isAllDay))
      .toList()
    ..sort((a, b) => a.startTime.compareTo(b.startTime));
}
