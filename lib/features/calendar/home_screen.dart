import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:iconsax/iconsax.dart';
import 'package:intl/intl.dart';
import 'package:lunar/calendar/Lunar.dart';
import 'package:lunar/calendar/Solar.dart';
import 'package:provider/provider.dart';
import 'package:super_calendar/features/calendar/components/today_button.dart';
import 'package:super_calendar/features/settings/view_models/dark_mode_provider.dart';
import 'package:super_calendar/features/settings/view_models/settings_items_vm.dart';
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

  MonthCell monthCellBuilder(
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
    bool isDarkMode =
        Provider.of<DarkModeProvider>(context, listen: false).isDarkMode;
    if (calendarTapDetails.targetElement == CalendarElement.header) {
      showModalBottomSheet(
          backgroundColor: isDarkMode ? Colors.black : Colors.white,
          context: context,
          builder: (context) => SizedBox(
                height: MediaQuery.of(context).size.height * 0.3,
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(right: 15.0, top: 15),
                      child: GestureDetector(
                        onTap: () {
                          _calendarController.displayDate = DateTime.now();
                          _calendarController.selectedDate = DateTime.now();
                          setState(() {
                            selectedDate = DateTime.now();
                          });
                          Navigator.pop(context);
                        },
                        child: const TodayButton(),
                      ),
                    ),
                    Expanded(
                      child: CupertinoDatePicker(
                        onDateTimeChanged: (value) {
                          _calendarController.displayDate = value;
                          setState(() {});
                        },
                        mode: CupertinoDatePickerMode.monthYear,
                      ),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                  ],
                ),
              ));
    } else if (calendarTapDetails.targetElement ==
        CalendarElement.calendarCell) {
      if (Platform.isIOS) {
        HapticFeedback.lightImpact();
      }
      if (!showAgenda) {
        showAgenda = !showAgenda;
      }
      selectedDate = getOnlyDate(calendarTapDetails.date!);
      setState(() {
        appointmentsOnDate =
            Provider.of<DataSourceViewModel>(context, listen: false)
                .dataSource
                .where((element) =>
                    (element.startTime.isBefore(selectedDate) ||
                        element.startTime.isAtSameMomentAs(selectedDate)) &&
                    (element.endTime.isAfter(selectedDate) ||
                        element.endTime.isAtSameMomentAs(selectedDate)))
                .toList();
      });
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
          title: Column(
            children: [
              Text(
                DateFormat.yMMMMd()
                    .format(calendarLongPressDetails.date!)
                    .toString(),
                style: const TextStyle(fontWeight: FontWeight.w500),
              ),
            ],
          ),
          content: Column(
            children: [
              const SizedBox(
                height: 20,
              ),
              CupertinoTextField(
                style: TextStyle(
                    color: isDarkMode(context) ? Colors.white : Colors.black),
                autofocus: true,
                cursorColor: isDarkMode(context) ? Colors.white : Colors.black,
                controller: _quickAddController,
                clearButtonMode: OverlayVisibilityMode.always,
                placeholder: "Add new event",
              ),
              const SizedBox(
                height: 10,
              ),
              CupertinoListTile(
                title: Text(
                  "At specific time?",
                  style: TextStyle(
                      color: isDarkMode(context) ? Colors.white : Colors.black),
                ),
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
                title: Text(
                  "Repeat?",
                  style: TextStyle(
                      color: isDarkMode(context) ? Colors.white : Colors.black),
                ),
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
                      child: DropdownButton(
                        dropdownColor: isDarkMode(context)
                            ? Colors.black45
                            : Colors.grey.shade300,
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
                    repeat =
                        'FREQ=MONTHLY;BYMONTHDAY=${calendarLongPressDetails.date!.day};INTERVAL=1';
                  case ('year'):
                    repeat =
                        'FREQ=YEARLY;BYMONTHDAY=${calendarLongPressDetails.date!.day};BYMONTH=${calendarLongPressDetails.date!.month};INTERVAL=1';
                  default:
                    repeat = null;
                }
                context.read<DataSourceViewModel>().addQuickNewAppointment(
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

  void removeAppointment(Appointment appointment) {
    appointmentsOnDate.removeAt(appointmentsOnDate.indexOf(appointment));
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    bool moreFeatures = context.watch<MoreFeatures>().moreFeatures;
    List weekNums = context.watch<SettingsItemViewModel>().indexAndWeekNumList;
    int weekNumIndex = context.watch<SettingsItemViewModel>().index;
    return GestureDetector(
      onVerticalDragUpdate: _calendarController.view == CalendarView.month
          ? onVerticalDragUpdate
          : null,
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
                        fontSize: 20,
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
                  showNavigationArrow: moreFeatures ? true : false,
                  selectionDecoration:
                      const BoxDecoration(color: Colors.transparent),
                  view: CalendarView.month,
                  cellBorderColor: Colors.transparent,
                  monthViewSettings: MonthViewSettings(
                    numberOfWeeksInView: weekNums[weekNumIndex],
                    showTrailingAndLeadingDates: moreFeatures ? true : false,
                    appointmentDisplayCount: showAgenda
                        ? weekNumIndex == 0
                            ? 10
                            : weekNumIndex == 1
                                ? 8
                                : weekNumIndex == 2
                                    ? 4
                                    : 3
                        : weekNumIndex == 0
                            ? 14
                            : weekNumIndex == 1
                                ? 10
                                : weekNumIndex == 2
                                    ? 7
                                    : 4,
                    appointmentDisplayMode:
                        MonthAppointmentDisplayMode.appointment,
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
    bool isToday = getOnlyDate(selectedDate) == getOnlyDate(DateTime.now());
    List<Appointment> sortedAppoinmentsOnDate =
        filterEventsByDate(selectedDate, appointmentsOnDate, true) +
            filterEventsByDate(selectedDate, appointmentsOnDate, false);
    bool showLunar = context.watch<SettingsItemViewModel>().showLunarDate;
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15.0),
              child: Text(
                showLunar
                    ? "${DateFormat.yMMMMd().format(selectedDate).split(',')[0]} (${Lunar.fromSolar(Solar.fromDate(selectedDate)).getDay().toString()}),${DateFormat.yMMMMd().format(selectedDate).split(',')[1]}"
                    : DateFormat.yMMMMd().format(selectedDate),
                style: TextStyle(
                  fontSize: showLunar ? 19 : 21,
                ),
              ),
            ),
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                if (!isToday)
                  GestureDetector(
                    onTap: () {
                      _calendarController.displayDate =
                          getOnlyDate(DateTime.now());
                      _calendarController.selectedDate =
                          getOnlyDate(DateTime.now());
                      selectedDate = getOnlyDate(DateTime.now());
                      appointmentsOnDate = Provider.of<DataSourceViewModel>(
                              context,
                              listen: false)
                          .dataSource
                          .where((element) =>
                              (element.startTime.isBefore(selectedDate) ||
                                  element.startTime
                                      .isAtSameMomentAs(selectedDate)) &&
                              (element.endTime.isAfter(selectedDate) ||
                                  element.endTime
                                      .isAtSameMomentAs(selectedDate)))
                          .toList();
                      setState(() {});
                    },
                    child: const TodayButton(),
                  ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 15.0),
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
        const Divider(
          indent: 15,
          endIndent: 15,
        ),
        SizedBox(
          height: MediaQuery.of(context).size.height * 0.25,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15),
            child: ListView.builder(
              itemCount: sortedAppoinmentsOnDate.length,
              itemBuilder: (context, index) => AppointmentTile(
                onRemove: removeAppointment,
                appointment: sortedAppoinmentsOnDate[index],
                selectedDate: selectedDate,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
