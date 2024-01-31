import 'package:flutter/material.dart';
import 'package:lunar/calendar/Lunar.dart';
import 'package:lunar/calendar/Solar.dart';
import 'package:provider/provider.dart';
import 'package:super_calendar/features/settings/view_models/lunar_vm.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';

class MonthCell extends StatelessWidget {
  final bool isToday;
  final bool isSelectedDate;
  final MonthCellDetails details;
  final Function dateTextColor;
  final bool moreFeatures;
  final bool showAgenda;
  const MonthCell(
      {super.key,
      required this.isToday,
      required this.isSelectedDate,
      required this.details,
      required this.dateTextColor,
      required this.moreFeatures,
      required this.showAgenda});

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.topCenter,
      child: Column(
        children: [
          if (showAgenda && context.watch<LunarViewModel>().showLunarDate)
            Text(
              Lunar.fromSolar(Solar.fromDate(details.date)).getDay().toString(),
              style: const TextStyle(fontSize: 10),
            ),
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
                fontSize: 17,
                fontWeight: FontWeight.w900,
                color: isToday
                    ? Colors.white
                    : dateTextColor(details.date, moreFeatures),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
