import 'dart:io';
import 'dart:math';

import 'package:cell_calendar/cell_calendar.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:super_calendar/features/calendar/components/date_model.dart';
import 'package:super_calendar/features/calendar/components/event_model.dart';
import 'package:super_calendar/utils.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late List events = [
    DateModel(
      events: [
        EventModel(
          text: "Hhh",
          dateTime: DateTime.now(),
          color:
              backgroundColors[Random().nextInt(backgroundColors.length) + 0],
        ),
        EventModel(
          text: "Hhh",
          dateTime: DateTime.now(),
          color:
              backgroundColors[Random().nextInt(backgroundColors.length) + 0],
        ),
        EventModel(
          text: "Hhh",
          dateTime: DateTime.now(),
          color:
              backgroundColors[Random().nextInt(backgroundColors.length) + 0],
        ),
        EventModel(
          text: "Hhh",
          dateTime: DateTime.now(),
          color:
              backgroundColors[Random().nextInt(backgroundColors.length) + 0],
        ),
        EventModel(
          text: "Hhh",
          dateTime: DateTime.now(),
          color:
              backgroundColors[Random().nextInt(backgroundColors.length) + 0],
        ),
        EventModel(
          text: "Hhh",
          dateTime: DateTime.now(),
          color:
              backgroundColors[Random().nextInt(backgroundColors.length) + 0],
        ),
      ],
      date: DateTime.now(),
    ),
    DateModel(
      events: [
        EventModel(
          text: "Hhhsdfdfsdf",
          dateTime: DateTime.now().add(const Duration(days: 1)),
          color:
              backgroundColors[Random().nextInt(backgroundColors.length) + 0],
        ),
      ],
      date: DateTime.now().add(const Duration(days: 1)),
    ),
  ];

  List<Color> backgroundColors = [
    Colors.green,
    Colors.pink,
    Colors.red,
    Colors.blue,
    Colors.orange,
    Colors.purple,
    Colors.teal,
    Colors.brown,
    Colors.cyan,
    Colors.indigo,
  ];

  List eventOnDate = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: SafeArea(
        bottom: false,
        child: Column(
          children: [
            Flexible(
              flex: 3,
              child: CellCalendar(
                onPageChanged: (firstDate, lastDate) {
                  if (Platform.isIOS) {
                    HapticFeedback.lightImpact();
                  }
                },
                onCellTapped: (tapDate) {
                  for (DateModel date in events) {
                    if (getOnlyDate(tapDate) == getOnlyDate(date.date)) {
                      setState(() {
                        eventOnDate = date.events;
                      });
                    }
                  }
                },
                daysOfTheWeekBuilder: (dayIndex) {
                  /// dayIndex: 0 for Sunday, 6 for Saturday.
                  final labels = ["S", "M", "T", "W", "T", "F", "S"];
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 4.0),
                    child: Text(
                      labels[dayIndex],
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  );
                },
                events: [
                  for (DateModel date in events)
                    for (EventModel event in date.events)
                      CalendarEvent(
                        eventName: event.text,
                        eventDate: event.dateTime,
                        eventTextStyle: const TextStyle(
                            color: Colors.white,
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                            height: 1),
                        eventBackgroundColor: event.color,
                      ),
                ],
              ),
            ),
            SizedBox(
              height: 20,
              child: eventOnDate.isNotEmpty
                  ? Text(eventOnDate.first.dateTime.toString().split(' ')[0])
                  : null,
            ),
            Flexible(
              flex: 1,
              child: ListView(
                children: [
                  for (EventModel event in eventOnDate)
                    ListTile(
                      leading: const Icon(Icons.event),
                      title: Text(event.text),
                      subtitle: Text(event.dateTime.toString()),
                    )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
