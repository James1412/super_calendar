import 'package:flutter/material.dart';
import 'package:lunar/calendar/Lunar.dart';
import 'package:lunar/calendar/Solar.dart';
import 'package:provider/provider.dart';
import 'package:super_calendar/features/calendar/view_models/data_source_vm.dart';
import 'package:super_calendar/features/settings/view_models/settings_items_vm.dart';
import 'package:super_calendar/utils.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';

class MonthCell extends StatelessWidget {
  final bool isToday;
  final bool isSelectedDate;
  final MonthCellDetails details;
  final bool moreFeatures;
  final bool showAgenda;
  final DateTime midDate;
  const MonthCell(
      {super.key,
      required this.midDate,
      required this.isToday,
      required this.isSelectedDate,
      required this.details,
      required this.moreFeatures,
      required this.showAgenda});

  Color? dateTextColor(DateTime datetime, bool moreFeatures, DateTime midDate,
      BuildContext context) {
    final bool isSaturday = datetime.weekday == 6;
    final bool isSunday = datetime.weekday == 7;
    final bool currentMonth = (datetime.month == midDate.month);
    List<Appointment> appointments =
        context.watch<DataSourceViewModel>().dataSource;
    for (Appointment appointment in appointments) {
      if (appointment.isAllDay &&
          getOnlyDate(appointment.startTime) == getOnlyDate(details.date) &&
          appointment.notes == SettingsItemViewModel.holidayText) {
        return Colors.red;
      }
    }
    if (!moreFeatures) {
      if (isSaturday) {
        return Colors.blue;
      } else if (isSunday) {
        return Colors.red;
      }
      return isDarkMode(context) ? Colors.white : Colors.black;
    } else {
      if (currentMonth) {
        if (isSaturday) {
          return Colors.blue;
        } else if (isSunday) {
          return Colors.red;
        }
        return isDarkMode(context) ? Colors.white : Colors.black;
      } else {
        return isDarkMode(context)
            ? Colors.grey.shade800
            : Colors.grey.shade300;
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.topCenter,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Container(
            padding: EdgeInsets.only(
                top: MediaQuery.of(context).size.height * 0.003),
            width: 30,
            height: 30,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: isToday
                  ? Theme.of(context).primaryColor
                  : isSelectedDate
                      ? Theme.of(context).primaryColor.withOpacity(0.3)
                      : null,
            ),
            child: Text(
              details.date.day.toString(),
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w900,
                color: isToday
                    ? Colors.white
                    : dateTextColor(
                        details.date, moreFeatures, midDate, context),
              ),
            ),
          ),
          if (context.watch<SettingsItemViewModel>().showLunarDate)
            Text(
              Lunar.fromSolar(Solar.fromDate(details.date)).getDay().toString(),
              style: const TextStyle(fontSize: 13, color: Colors.grey),
            ),
        ],
      ),
    );
  }
}
