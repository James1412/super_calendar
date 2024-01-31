import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:iconsax/iconsax.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:super_calendar/features/authentication/more_feature_provider.dart';
import 'package:super_calendar/features/calendar/components/calendar_datasource.dart';
import 'package:super_calendar/features/calendar/components/event_model.dart';
import 'package:super_calendar/features/calendar/view_models/data_source_vm.dart';
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

  Color? dateTextColor(DateTime datetime, bool moreFeatures) {
    final bool isSaturday = datetime.weekday == 6;
    final bool isSunday = datetime.weekday == 7;
    final bool currentMonth =
        (_calendarController.displayDate!.month == datetime.month);
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

  Widget monthCellBuilder(
      BuildContext context, MonthCellDetails details, bool moreFeatures) {
    final bool isToday =
        getOnlyDate(details.date) == getOnlyDate(DateTime.now());
    bool isSelectedDate = false;
    if (_calendarController.selectedDate != null) {
      isSelectedDate = getOnlyDate(details.date) ==
          getOnlyDate(_calendarController.selectedDate!);
    }
    return Align(
      alignment: Alignment.topCenter,
      child: Container(
        padding: const EdgeInsets.only(top: 2),
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
    );
  }

  Future<void> onViewChanged(ViewChangedDetails viewChangedDetails) async {
    if (_calendarController.view != CalendarView.month) {
      showAgenda = false;
      await Future.delayed(Duration.zero, () async {
        setState(() {});
      });
    }
    if (!mounted) return;
    if (Provider.of<MoreFeatures>(context, listen: false).moreFeatures &&
        _calendarController.view == CalendarView.month) {
      _calendarController.displayDate = viewChangedDetails.visibleDates[15];
      await Future.delayed(const Duration(microseconds: 1), () async {
        setState(() {});
      });
    }
  }

  void onTap(calendarTapDetails) {
    if (calendarTapDetails.targetElement == CalendarElement.header) {
      return;
    }
    if (Platform.isIOS) {
      HapticFeedback.lightImpact();
    }
    if (!showAgenda) {
      showAgenda = !showAgenda;
    }
    selectedDate = calendarTapDetails.date!;
    setState(() {});
  }

  void onVerticalDragUpdate(details) {
    if (details.delta.dy < -10) {
      setState(() {
        showAgenda = true;
      });
    } else if (details.delta.dy > 10) {
      setState(() {
        showAgenda = false;
      });
    }
  }

  bool showAgenda = false;
  DateTime selectedDate = DateTime.now();
  @override
  Widget build(BuildContext context) {
    bool moreFeatures = context.watch<MoreFeatures>().moreFeatures;
    return GestureDetector(
      onVerticalDragUpdate: onVerticalDragUpdate,
      child: Scaffold(
        resizeToAvoidBottomInset: true,
        body: SafeArea(
          bottom: false,
          child: Stack(
            children: [
              Column(
                children: [
                  Expanded(
                    child: SfCalendar(
                      onViewChanged: onViewChanged,
                      headerStyle: CalendarHeaderStyle(
                        textStyle: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: isDarkMode(context)
                                ? Colors.white
                                : Colors.black),
                        textAlign:
                            !moreFeatures ? TextAlign.center : TextAlign.start,
                      ),
                      viewHeaderStyle: ViewHeaderStyle(
                        dayTextStyle: TextStyle(
                            color: isDarkMode(context)
                                ? Colors.white70
                                : Colors.black),
                      ),
                      controller: _calendarController,
                      showTodayButton: moreFeatures ? true : false,
                      showDatePickerButton: moreFeatures ? true : false,
                      showNavigationArrow: moreFeatures ? true : false,
                      selectionDecoration:
                          const BoxDecoration(color: Colors.transparent),
                      view: CalendarView.month,
                      allowedViews: moreFeatures
                          ? [
                              CalendarView.month,
                              CalendarView.week,
                              CalendarView.day,
                              CalendarView.timelineDay,
                            ]
                          : null,
                      cellBorderColor: Colors.transparent,
                      monthViewSettings: MonthViewSettings(
                        showTrailingAndLeadingDates:
                            moreFeatures ? true : false,
                        appointmentDisplayCount: 4,
                        appointmentDisplayMode: showAgenda
                            ? MonthAppointmentDisplayMode.indicator
                            : MonthAppointmentDisplayMode.appointment,
                      ),
                      monthCellBuilder: (context, details) =>
                          monthCellBuilder(context, details, moreFeatures),
                      todayHighlightColor: moreFeatures
                          ? Theme.of(context).primaryColor
                          : isDarkMode(context)
                              ? Colors.white70
                              : Colors.black,
                      onTap: onTap,
                      dataSource: MeetingDataSource(
                        context.watch<DataSourceViewModel>().dataSource,
                      ),
                    ),
                  ),
                  if (showAgenda) getAgenda(context),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Column getAgenda(BuildContext context) {
    bool moreFeature = context.watch<MoreFeatures>().moreFeatures;
    bool notToday = getOnlyDate(selectedDate) != getOnlyDate(DateTime.now());
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  DateFormat.yMMMMd().format(selectedDate),
                  style: const TextStyle(
                    fontSize: 23,
                  ),
                ),
              ),
            ),
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                GestureDetector(
                  onTap: () {
                    _calendarController.displayDate = DateTime.now();
                    _calendarController.selectedDate = DateTime.now();
                    setState(() {
                      selectedDate = DateTime.now();
                    });
                  },
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 400),
                    width: 90,
                    height: 36,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      color: notToday
                          ? Theme.of(context).primaryColor
                          : Colors.transparent,
                    ),
                    child: notToday
                        ? const Center(
                            child: Text(
                              "Go to today",
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                                fontSize: 13,
                              ),
                            ),
                          )
                        : null,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10.0),
                  child: GestureDetector(
                    onTap: () {
                      if (Platform.isIOS) {
                        HapticFeedback.lightImpact();
                      }
                      setState(() {
                        showAgenda = !showAgenda;
                      });
                    },
                    child: const Icon(
                      Iconsax.close_circle,
                      size: 30,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
        SizedBox(
          height: MediaQuery.of(context).size.height * 0.25,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15),
            child: Row(
              children: [
                Expanded(
                  child: ListView(
                    children: [
                      for (Event event in Provider.of<DataSourceViewModel>(
                              context,
                              listen: false)
                          .dataSource)
                        Align(
                          alignment: Alignment.center,
                          child: Container(
                            margin: const EdgeInsets.symmetric(
                              vertical: 5,
                            ),
                            width: double.maxFinite,
                            height: 50,
                            decoration: BoxDecoration(
                              color: Colors.grey.withOpacity(0.15),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Center(
                                child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Row(
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.symmetric(
                                        vertical: 10,
                                        horizontal: 15,
                                      ),
                                      child: Container(
                                        decoration: BoxDecoration(
                                          color: event.background,
                                          borderRadius:
                                              BorderRadius.circular(5),
                                        ),
                                        width: 5,
                                        height: double.maxFinite,
                                      ),
                                    ),
                                    SizedBox(
                                      width: MediaQuery.of(context).size.width *
                                          0.4,
                                      child: Text(
                                        event.eventName,
                                        style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold,
                                          color: isDarkMode(context)
                                              ? Colors.white
                                              : Colors.black,
                                        ),
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                  ],
                                ),
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 15),
                                  child: Text(
                                    event.isAllDay
                                        ? "all-day"
                                        : "${getOnlyTime(event.from)} - ${getOnlyTime(event.to)}",
                                  ),
                                ),
                              ],
                            )),
                          ),
                        ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
