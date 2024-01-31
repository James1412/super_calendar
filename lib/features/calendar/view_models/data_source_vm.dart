import 'package:flutter/material.dart';
import 'package:super_calendar/utils.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';

class DataSourceViewModel extends ChangeNotifier {
  List<Appointment> dataSource = [
    Appointment(
      subject: 'Custom',
      startTime: getOnlyDate(DateTime.now()).add(const Duration(hours: 2)),
      endTime: getOnlyDate(DateTime.now()).add(const Duration(hours: 6)),
      color: const Color(0xFF0F8644),
      isAllDay: false,
    ),
    Appointment(
      subject: 'ConferenceConferenceConferenceConferenceConference',
      startTime: getOnlyDate(DateTime.now()),
      endTime: getOnlyDate(DateTime.now()).add(const Duration(hours: 2)),
      color: const Color(0xFF0F8644),
      isAllDay: true,
    ),
    Appointment(
      subject: 'Conference',
      startTime: getOnlyDate(DateTime.now()),
      endTime: getOnlyDate(DateTime.now()).add(const Duration(hours: 50)),
      color: const Color(0xFF0F8644),
      isAllDay: false,
    ),
    Appointment(
      subject: 'Conference',
      startTime: getOnlyDate(DateTime.now()),
      endTime: getOnlyDate(DateTime.now()).add(const Duration(hours: 2)),
      color: const Color(0xFF0F8644),
      isAllDay: true,
    ),
  ];

  void quickAddNewEvent({
    required DateTime date,
    required DateTime? time,
    required String text,
    required BuildContext context,
    String? repeat,
  }) {
    bool isAllDay = false;
    DateTime? from = time;
    DateTime? to = time;
    if (time == null) {
      isAllDay = true;
      from = date;
      to = date;
    }
    final newEvent = Appointment(
        subject: text,
        startTime: from!,
        endTime: to!,
        color: Theme.of(context).primaryColor,
        isAllDay: isAllDay,
        recurrenceRule: repeat);
    dataSource.add(newEvent);
    notifyListeners();
  }
}
