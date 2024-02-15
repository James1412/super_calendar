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
    Appointment(
      subject: 'Right Now',
      startTime: getOnlyDate(DateTime.now()),
      endTime: getOnlyDate(DateTime.now()).add(const Duration(hours: 24)),
      color: const Color(0xFF0F8644),
      isAllDay: false,
    ),
  ];

  void addQuickNewAppointment({
    required DateTime date,
    required DateTime? time,
    required String text,
    required BuildContext context,
    String? repeat,
    String? holiday,
    Color? color,
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
      color: color ?? Theme.of(context).primaryColor,
      isAllDay: isAllDay,
      recurrenceRule: repeat,
      notes: holiday,
    );
    dataSource.add(newEvent);
    notifyListeners();
  }

  void changeAppointmentName(
      {required Appointment appointment, required String text}) {
    final newAppointment = appointment..subject = text;
    dataSource[
            dataSource.indexWhere((element) => element.id == appointment.id)] =
        newAppointment;
    notifyListeners();
  }

  void changeAppointmentColor(
      {required Appointment appointment, required Color color}) {
    final newAppointment = appointment..color = color;
    dataSource[
            dataSource.indexWhere((element) => element.id == appointment.id)] =
        newAppointment;
    notifyListeners();
  }

  void setAllDay({required Appointment appointment, required bool value}) {
    final newAppointment = appointment
      ..isAllDay = value
      ..startTime = getOnlyDate(appointment.startTime)
      ..endTime = getOnlyDate(appointment.endTime);
    dataSource[
            dataSource.indexWhere((element) => element.id == appointment.id)] =
        newAppointment;
    notifyListeners();
  }

  void changeAppointmentTime(
      {required Appointment appointment,
      required DateTime startTime,
      required DateTime endTime,
      required bool isAllDay}) {
    var newAppointment = appointment;
    if (isAllDay) {
      newAppointment = appointment..isAllDay = isAllDay;
    } else {
      newAppointment = appointment
        ..startTime = startTime
        ..endTime = endTime
        ..isAllDay = isAllDay;
    }
    dataSource[
            dataSource.indexWhere((element) => element.id == appointment.id)] =
        newAppointment;
    notifyListeners();
  }

  void quickDeleteAppoinment(
      {required Appointment appointment, DateTime? selectedDate}) {
    if (selectedDate != null) {
      if (appointment.recurrenceRule != null &&
          appointment.recurrenceRule != '') {
        var monthNum = selectedDate.month == 10 ||
                selectedDate.month == 11 ||
                selectedDate.month == 12
            ? selectedDate.month
            : "0${selectedDate.month}";
        var dayNum = selectedDate.day.toString().length == 1
            ? "0${selectedDate.day - 1}"
            : selectedDate.day - 1;
        String untilText = ";UNTIL=${selectedDate.year}$monthNum$dayNum";
        dataSource[dataSource
                .indexWhere((element) => element.id == appointment.id)] =
            dataSource.where((element) => element.id == appointment.id).first
              ..recurrenceRule = appointment.recurrenceRule! + untilText;
      } else {
        dataSource.removeAt(
            dataSource.indexWhere((element) => element.id == appointment.id));
      }
    } else {
      dataSource.removeAt(
          dataSource.indexWhere((element) => element.id == appointment.id));
    }
    notifyListeners();
  }
}
