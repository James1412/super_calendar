import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:super_calendar/features/calendar/show_agenda_provider.dart';
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

  @override
  Widget build(BuildContext context) {
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
              onTap: (calendarTapDetails) {
                if (Platform.isIOS) {
                  HapticFeedback.lightImpact();
                }
                if (!Provider.of<ShowAgendaProvider>(context, listen: false)
                    .showAgenda) {
                  context.read<ShowAgendaProvider>().setShowAgenda();
                }
              },
              view: CalendarView.month,
              monthViewSettings: MonthViewSettings(
                agendaViewHeight: MediaQuery.of(context).size.height * 0.4,
                appointmentDisplayCount: 4,
                appointmentDisplayMode:
                    context.watch<ShowAgendaProvider>().showAgenda
                        ? MonthAppointmentDisplayMode.indicator
                        : MonthAppointmentDisplayMode.appointment,
                showAgenda: context.watch<ShowAgendaProvider>().showAgenda,
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
