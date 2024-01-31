import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:iconsax/iconsax.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:super_calendar/features/calendar/components/text_magnifier.dart';
import 'package:super_calendar/features/settings/view_models/more_feature_provider.dart';
import 'package:super_calendar/features/calendar/models/calendar_datasource.dart';
import 'package:super_calendar/features/calendar/components/appointment_tile.dart';
import 'package:super_calendar/features/calendar/components/month_cell.dart';
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
    _quickAddController.dispose();
    _calendarController.dispose();
    super.dispose();
  }

  Color? dateTextColor(DateTime datetime, bool moreFeatures, DateTime midDate) {
    final bool isSaturday = datetime.weekday == 6;
    final bool isSunday = datetime.weekday == 7;
    final bool currentMonth = (datetime.month == midDate.month);
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
    int mid = details.visibleDates.length ~/ 2.toInt();
    DateTime midDate = details.visibleDates[0].add(Duration(days: mid));
    final bool isToday =
        getOnlyDate(details.date) == getOnlyDate(DateTime.now());
    bool isSelectedDate = false;
    if (_calendarController.selectedDate != null) {
      isSelectedDate = getOnlyDate(details.date) ==
          getOnlyDate(_calendarController.selectedDate!);
    }
    return MonthCell(
      isToday: isToday,
      isSelectedDate: isSelectedDate,
      details: details,
      dateTextColor: dateTextColor,
      midDate: midDate,
      moreFeatures: moreFeatures,
      showAgenda: showAgenda,
    );
  }

  Future<void> onViewChanged(ViewChangedDetails viewChangedDetails) async {
    if (_calendarController.view != CalendarView.month) {
      showAgenda = false;
      await Future.delayed(Duration.zero, () async {
        setState(() {});
      });
    }
  }

  void onTap(CalendarTapDetails calendarTapDetails) {
    if (calendarTapDetails.targetElement == CalendarElement.calendarCell) {
      if (Platform.isIOS) {
        HapticFeedback.lightImpact();
      }
      if (!showAgenda) {
        showAgenda = !showAgenda;
      }
      setState(() {
        appointmentsOnDate =
            calendarTapDetails.appointments!.cast<Appointment>();
      });
      selectedDate = calendarTapDetails.date!;
      setState(() {});
    }
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

  final TextEditingController _quickAddController = TextEditingController();
  DateTime? selectedTime;
  void onLongPress(CalendarLongPressDetails calendarLongPressDetails) async {
    if (calendarLongPressDetails.targetElement ==
        CalendarElement.calendarCell) {
      if (Platform.isIOS) {
        HapticFeedback.mediumImpact();
      }
    }
    bool addTime = false;
    bool repeat = false;
    String? dropDownValue;
    showCupertinoDialog(
      context: context,
      builder: (context) => StatefulBuilder(builder: (context, setState) {
        return CupertinoAlertDialog(
          title: Text(
            DateFormat.yMMMMd()
                .format(calendarLongPressDetails.date!)
                .toString(),
            style: const TextStyle(fontWeight: FontWeight.w500),
          ),
          content: Column(
            children: [
              const SizedBox(
                height: 20,
              ),
              CupertinoTextField(
                autofocus: true,
                cursorColor: Colors.black,
                magnifierConfiguration: TextMagnifierConfiguration(
                  magnifierBuilder: (context, controller, magnifierInfo) =>
                      CustomMagnifier(magnifierInfo: magnifierInfo),
                ),
                controller: _quickAddController,
                clearButtonMode: OverlayVisibilityMode.always,
                placeholder: "Add new event",
              ),
              const SizedBox(
                height: 10,
              ),
              CupertinoListTile(
                title: const Text("Add time?"),
                trailing: CupertinoCheckbox(
                  value: addTime,
                  onChanged: (value) {
                    addTime = value!;
                    setState(() {});
                  },
                ),
              ),
              if (addTime)
                SizedBox(
                  height: 100,
                  width: double.maxFinite,
                  child: CupertinoDatePicker(
                    initialDateTime: calendarLongPressDetails.date,
                    onDateTimeChanged: (date) {
                      selectedTime = date;
                      setState(() {});
                    },
                    mode: CupertinoDatePickerMode.time,
                  ),
                ),
              CupertinoListTile(
                title: const Text("Repeat?"),
                trailing: CupertinoCheckbox(
                  value: repeat,
                  onChanged: (value) {
                    repeat = value!;
                    setState(() {});
                  },
                ),
              ),
              if (repeat)
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    const Text("Repeat every"),
                    Material(
                      type: MaterialType.transparency,
                      child: Expanded(
                        child: DropdownButton(
                          dropdownColor: Colors.grey.shade300,
                          items: const [
                            DropdownMenuItem<String>(
                                value: 'day', child: Text("day")),
                            DropdownMenuItem<String>(
                                value: 'week', child: Text("week")),
                            DropdownMenuItem<String>(
                                value: 'month', child: Text("month")),
                            DropdownMenuItem<String>(
                                value: 'year', child: Text("year")),
                          ],
                          onChanged: (value) {
                            dropDownValue = value!;
                            setState(() {});
                          },
                          value: dropDownValue,
                        ),
                      ),
                    ),
                  ],
                ),
            ],
          ),
          actions: [
            CupertinoDialogAction(
              isDefaultAction: true,
              textStyle: const TextStyle(color: Colors.red),
              child: const Text("Cancel"),
              onPressed: () {
                _quickAddController.clear();
                Navigator.pop(context);
              },
            ),
            CupertinoDialogAction(
              isDefaultAction: true,
              textStyle: TextStyle(color: Theme.of(context).primaryColor),
              onPressed: () {
                String? repeat;

                switch (dropDownValue) {
                  case ('day'):
                    repeat = SfCalendar.generateRRule(
                        RecurrenceProperties(
                            startDate: calendarLongPressDetails.date!,
                            recurrenceType: RecurrenceType.daily),
                        calendarLongPressDetails.date!,
                        calendarLongPressDetails.date!);
                  case ('week'):
                    repeat =
                        'FREQ=WEEKLY;BYDAY=${getDay(calendarLongPressDetails.date!)};INTERVAL=1';
                  case ('month'):
                    repeat = 'FREQ=MONTHLY;INTERVAL=1';
                  case ('year'):
                    repeat = 'FREQ=YEARLY;INTERVAL=1';
                  default:
                    repeat = null;
                }
                context.read<DataSourceViewModel>().quickAddNewEvent(
                      context: context,
                      date: calendarLongPressDetails.date!,
                      time: selectedTime,
                      text: _quickAddController.text,
                      repeat: repeat ?? "",
                    );

                _quickAddController.clear();
                Navigator.pop(context);
              },
              child: const Text("Add"),
            ),
          ],
        );
      }),
    );
  }

  bool showAgenda = false;
  DateTime selectedDate = DateTime.now();
  List<Appointment> appointmentsOnDate = <Appointment>[];

  @override
  Widget build(BuildContext context) {
    bool moreFeatures = context.watch<MoreFeatures>().moreFeatures;
    return GestureDetector(
      onVerticalDragUpdate: onVerticalDragUpdate,
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        body: SafeArea(
          bottom: false,
          child: Column(
            children: [
              Expanded(
                child: SfCalendar(
                  onLongPress: onLongPress,
                  onViewChanged: onViewChanged,
                  headerStyle: CalendarHeaderStyle(
                    textStyle: TextStyle(
                        fontWeight: FontWeight.bold,
                        color:
                            isDarkMode(context) ? Colors.white : Colors.black),
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
                          CalendarView.timelineWeek,
                        ]
                      : null,
                  cellBorderColor: Colors.transparent,
                  monthViewSettings: MonthViewSettings(
                    showTrailingAndLeadingDates: moreFeatures ? true : false,
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
        ),
      ),
    );
  }

  Column getAgenda(BuildContext context) {
    bool moreFeature = context.watch<MoreFeatures>().moreFeatures;
    bool isToday = getOnlyDate(selectedDate) != getOnlyDate(DateTime.now());
    List<Appointment> sortedAppoinmentsOnDate =
        filterEventsByDate(selectedDate, appointmentsOnDate, true) +
            filterEventsByDate(selectedDate, appointmentsOnDate, false);
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 5.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15.0),
                child: Text(
                  DateFormat.yMMMMd().format(selectedDate),
                  style: const TextStyle(
                    fontSize: 21,
                  ),
                ),
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  if (moreFeature)
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
                        width: 70,
                        height: 35,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          color: !isToday
                              ? Theme.of(context).primaryColor
                              : Colors.transparent,
                        ),
                        child: !isToday
                            ? const Center(
                                child: Text(
                                  "Today",
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
        ),
        const Divider(
          indent: 15,
          endIndent: 15,
        ),
        SizedBox(
          height: MediaQuery.of(context).size.height * 0.35,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15),
            child: Row(
              children: [
                Expanded(
                  child: ListView.builder(
                    itemCount: sortedAppoinmentsOnDate.length,
                    itemBuilder: (context, index) => AppointmentTile(
                      event: sortedAppoinmentsOnDate[index],
                    ),
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
