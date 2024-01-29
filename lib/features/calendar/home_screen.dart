import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:super_calendar/utils.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final CalendarController _calendarController = CalendarController();

  @override
  void dispose() {
    _calendarController.dispose();
    super.dispose();
  }

  List<Meeting> getDataSource() {
    final List<Meeting> meetings = <Meeting>[];
    final DateTime today = DateTime.now();
    final DateTime startTime =
        DateTime(today.year, today.month, today.day, 9, 0, 0);
    final DateTime endTime = startTime.add(const Duration(hours: 2));
    meetings.add(Meeting(
        'Conference', startTime, endTime, const Color(0xFF0F8644), false));
    meetings.add(Meeting(
        'Conference', startTime, endTime, const Color(0xFF0F8644), false));
    meetings.add(Meeting(
        'Conference', startTime, endTime, const Color(0xFF0F8644), false));
    return meetings;
  }

  bool showAgenda = false;
  bool isFirst = true;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: SafeArea(
        bottom: false,
        child: Stack(
          children: [
            SfCalendar(
              controller: _calendarController,
              todayHighlightColor: Theme.of(context).primaryColor,
              showDatePickerButton: true,
              showNavigationArrow: true,
              showTodayButton: true,
              selectionDecoration: BoxDecoration(
                  border: Border.all(color: Theme.of(context).primaryColor)),
              onSelectionChanged: (calendarSelectionDetails) {
                if (!isFirst) {
                  if (!showAgenda) {
                    showAgenda = !showAgenda;
                  }

                  setState(() {});
                }
              },
              initialSelectedDate: getOnlyDate(DateTime.now()),
              onTap: (calendarTapDetails) {
                isFirst = false;
                if (Platform.isIOS) {
                  HapticFeedback.lightImpact();
                }
                if (showAgenda) {
                  showAgenda = !showAgenda;
                  setState(() {});
                }
              },
              view: CalendarView.month,
              allowedViews: const [
                CalendarView.month,
                CalendarView.week,
                CalendarView.day,
                CalendarView.timelineDay,
              ],
              monthViewSettings: MonthViewSettings(
                agendaViewHeight: MediaQuery.of(context).size.height * 0.4,
                appointmentDisplayCount: 4,
                appointmentDisplayMode: showAgenda
                    ? MonthAppointmentDisplayMode.indicator
                    : MonthAppointmentDisplayMode.appointment,
                showAgenda: showAgenda,
              ),
              dataSource: MeetingDataSource(getDataSource()),
            ),
          ],
        ),
      ),
    );
  }
}

class MeetingDataSource extends CalendarDataSource {
  MeetingDataSource(List<Meeting> source) {
    appointments = source;
  }

  @override
  DateTime getStartTime(int index) {
    return appointments![index].from;
  }

  @override
  DateTime getEndTime(int index) {
    return appointments![index].to;
  }

  @override
  String getSubject(int index) {
    return appointments![index].eventName;
  }

  @override
  Color getColor(int index) {
    return appointments![index].background;
  }

  @override
  bool isAllDay(int index) {
    return appointments![index].isAllDay;
  }
}

class Meeting {
  Meeting(this.eventName, this.from, this.to, this.background, this.isAllDay);

  String eventName;
  DateTime from;
  DateTime to;
  Color background;
  bool isAllDay;
}
