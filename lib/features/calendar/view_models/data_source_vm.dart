import 'package:flutter/material.dart';
import 'package:super_calendar/features/calendar/components/event_model.dart';
import 'package:super_calendar/utils.dart';

class DataSourceViewModel extends ChangeNotifier {
  List<Event> dataSource = [
    Event(
      'ConferenceConferenceConferenceConferenceConference',
      getOnlyDate(DateTime.now()),
      getOnlyDate(DateTime.now()).add(const Duration(hours: 2)),
      const Color(0xFF0F8644),
      true,
    ),
    Event(
        'Conference',
        getOnlyDate(DateTime.now()),
        getOnlyDate(DateTime.now()).add(const Duration(hours: 2)),
        const Color(0xFF0F8644),
        false),
    Event(
        'Conference',
        getOnlyDate(DateTime.now()),
        getOnlyDate(DateTime.now()).add(const Duration(hours: 2)),
        const Color(0xFF0F8644),
        false),
  ];
}
