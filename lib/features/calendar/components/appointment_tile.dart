import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:super_calendar/features/calendar/view_models/data_source_vm.dart';
import 'package:super_calendar/features/settings/view_models/more_feature_provider.dart';
import 'package:super_calendar/utils.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';

class AppointmentTile extends StatefulWidget {
  final Appointment appointment;
  final Function onRemove;
  final DateTime selectedDate;
  final Function setStateHome;
  const AppointmentTile(
      {super.key,
      required this.appointment,
      required this.onRemove,
      required this.selectedDate,
      required this.setStateHome});

  @override
  State<AppointmentTile> createState() => _AppointmentTileState();
}

class _AppointmentTileState extends State<AppointmentTile> {
  @override
  void dispose() {
    controller.dispose();
    startTimeController.dispose();
    endTimeController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    controller.text = widget.appointment.subject;
    startTimeController.text =
        "${widget.appointment.startTime.toString().split(' ')[0]}     ${getOnlyTime(widget.appointment.startTime)}";
    endTimeController.text =
        "${widget.appointment.endTime.toString().split(' ')[0]}     ${getOnlyTime(widget.appointment.endTime)}";
    super.initState();
  }

  TextEditingController controller = TextEditingController();
  void onTap(BuildContext context) {
    if (Platform.isIOS) {
      HapticFeedback.lightImpact();
    }
    //When default mode
    if (!Provider.of<MoreFeatures>(context, listen: false).moreFeatures) {
      bool startTap = false;
      bool endTap = false;
      bool allDay = widget.appointment.isAllDay;
      DateTime startTime = widget.appointment.startTime;
      DateTime endTime = widget.appointment.endTime;
      showDialog(
        context: context,
        builder: (context) => StatefulBuilder(
          builder: (context, setState) => Dialog(
            child: Container(
              height: allDay
                  ? 250
                  : startTap || endTap
                      ? 600
                      : 400,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      "Change event",
                      style: TextStyle(
                          fontWeight: FontWeight.normal, fontSize: 20),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    CupertinoTextField(
                      style: TextStyle(
                          color: isDarkMode(context)
                              ? Colors.white
                              : Colors.black),
                      cursorColor:
                          isDarkMode(context) ? Colors.white : Colors.black,
                      clearButtonMode: OverlayVisibilityMode.editing,
                      controller: controller,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        const Text("All day"),
                        Checkbox(
                          activeColor: Theme.of(context).primaryColor,
                          value: allDay,
                          onChanged: (val) {
                            if (Platform.isIOS) {
                              HapticFeedback.lightImpact();
                            }
                            allDay = !allDay;
                            setState(() {});
                          },
                        ),
                      ],
                    ),
                    if (!allDay)
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 30.0),
                        child: Column(
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  "Start time",
                                  style: TextStyle(
                                    color: Colors.grey,
                                  ),
                                ),
                                Container(
                                  padding: const EdgeInsets.only(top: 3),
                                  height: 40,
                                  width: double.maxFinite,
                                  child: TextField(
                                    style: const TextStyle(height: 0.75),
                                    controller: startTimeController,
                                    onTap: () {
                                      setState(() {
                                        startTap = true;
                                        endTap = false;
                                      });
                                    },
                                    readOnly: true,
                                    decoration: InputDecoration(
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                      focusedBorder: OutlineInputBorder(
                                        borderSide: BorderSide(
                                            color:
                                                Theme.of(context).primaryColor),
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const Padding(
                              padding: EdgeInsets.only(top: 15, bottom: 0),
                              child: FaIcon(
                                FontAwesomeIcons.arrowDown,
                                color: Colors.grey,
                                size: 20,
                              ),
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  "End time",
                                  style: TextStyle(
                                    color: Colors.grey,
                                  ),
                                ),
                                Container(
                                  padding: const EdgeInsets.only(top: 3),
                                  height: 40,
                                  width: double.maxFinite,
                                  child: TextField(
                                    style: const TextStyle(height: 0.75),
                                    onTap: () {
                                      endTap = true;
                                      startTap = false;
                                      setState(() {});
                                    },
                                    controller: endTimeController,
                                    readOnly: true,
                                    decoration: InputDecoration(
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                      focusedBorder: OutlineInputBorder(
                                        borderSide: BorderSide(
                                            color:
                                                Theme.of(context).primaryColor),
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    if ((startTap || endTap) && !allDay)
                      SizedBox(
                        height: 200,
                        width: double.maxFinite,
                        child: CupertinoDatePicker(
                          initialDateTime: startTap ? startTime : endTime,
                          minimumDate: endTap ? startTime : null,
                          maximumDate: startTap ? endTime : null,
                          onDateTimeChanged: (date) {
                            if (startTap) {
                              startTimeController.text =
                                  "${date.toString().split(' ')[0]}     ${getOnlyTime(date)}";
                              startTime = date;
                            }
                            if (endTap) {
                              endTimeController.text =
                                  "${date.toString().split(' ')[0]}     ${getOnlyTime(date)}";
                              endTime = date;
                            }
                            setState(() {});
                          },
                          mode: CupertinoDatePickerMode.dateAndTime,
                        ),
                      ),
                    const SizedBox(
                      height: 20,
                    ),
                    GestureDetector(
                      onTap: () {
                        if (Platform.isIOS) {
                          HapticFeedback.lightImpact();
                        }
                        context.read<DataSourceViewModel>().setAllDay(
                            appointment: widget.appointment, value: allDay);
                        context
                            .read<DataSourceViewModel>()
                            .changeAppointmentTime(
                                appointment: widget.appointment,
                                startTime: startTime,
                                endTime: endTime,
                                isAllDay: allDay);
                        widget.setStateHome();
                        context
                            .read<DataSourceViewModel>()
                            .changeAppointmentName(
                                appointment: widget.appointment,
                                text: controller.text);
                        Navigator.pop(context);
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.black),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        padding: const EdgeInsets.symmetric(
                            vertical: 8, horizontal: 40),
                        child: const Text(
                          "Done",
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      );
    }
    //TODO: When more Feature mode
  }

  TextEditingController startTimeController = TextEditingController();
  TextEditingController endTimeController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => onTap(context),
      borderRadius: BorderRadius.circular(10),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 5.0),
        child: Slidable(
          endActionPane: ActionPane(
            motion: const DrawerMotion(),
            children: [
              SlidableAction(
                backgroundColor: Colors.red,
                borderRadius: BorderRadius.circular(10),
                onPressed: (value) {
                  widget.onRemove(widget.appointment);
                  context.read<DataSourceViewModel>().quickDeleteAppoinment(
                      appointment: widget.appointment,
                      selectedDate: widget.selectedDate);
                },
                icon: FontAwesomeIcons.trash,
              ),
            ],
          ),
          child: Container(
            width: double.maxFinite,
            height: MediaQuery.of(context).size.height * 0.070,
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
                          color: widget.appointment.color,
                          borderRadius: BorderRadius.circular(5),
                        ),
                        width: 5,
                        height: double.maxFinite,
                      ),
                    ),
                    SizedBox(
                      width: MediaQuery.of(context).size.width * 0.45,
                      child: Text(
                        widget.appointment.subject,
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color:
                              isDarkMode(context) ? Colors.white : Colors.black,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: double.maxFinite,
                  child: Center(
                    child: Padding(
                      padding: const EdgeInsets.only(right: 15),
                      child: Text(
                        getTimeText(),
                        textAlign: TextAlign.right,
                        style: const TextStyle(fontSize: 12),
                      ),
                    ),
                  ),
                ),
              ],
            )),
          ),
        ),
      ),
    );
  }

  String getTimeText() {
    if (widget.appointment.isAllDay) {
      return 'all-day';
    } else if (getOnlyDate(widget.appointment.startTime) !=
        getOnlyDate(widget.appointment.endTime)) {
      return "${getThreeCharDay(widget.appointment.startTime)} ${getOnlyTime(widget.appointment.startTime)} \n ${getThreeCharDay(widget.appointment.endTime)} ${getOnlyTime(widget.appointment.endTime)}";
    } else if (getOnlyTime(widget.appointment.startTime) ==
        getOnlyTime(widget.appointment.endTime)) {
      return getOnlyTime(widget.appointment.startTime);
    }

    return "${getOnlyTime(widget.appointment.startTime)} \n ${getOnlyTime(widget.appointment.endTime)}";
  }
}
