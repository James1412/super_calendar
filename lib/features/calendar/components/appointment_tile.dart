import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
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
  const AppointmentTile(
      {super.key, required this.appointment, required this.onRemove});

  @override
  State<AppointmentTile> createState() => _AppointmentTileState();
}

class _AppointmentTileState extends State<AppointmentTile> {
  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  void initState() {
    controller.text = widget.appointment.subject;
    super.initState();
  }

  TextEditingController controller = TextEditingController();
  void onTap(BuildContext context) {
    //When default mode
    if (!Provider.of<MoreFeatures>(context, listen: false).moreFeatures) {
      showCupertinoDialog(
        context: context,
        builder: (context) => CupertinoAlertDialog(
          title: const Text("Change event"),
          content: Column(
            children: [
              const SizedBox(
                height: 20,
              ),
              CupertinoTextField(
                style: TextStyle(
                    color: isDarkMode(context) ? Colors.white : Colors.black),
                cursorColor: isDarkMode(context) ? Colors.white : Colors.black,
                clearButtonMode: OverlayVisibilityMode.editing,
                controller: controller,
              ),
            ],
          ),
          actions: [
            CupertinoDialogAction(
              isDefaultAction: true,
              textStyle: const TextStyle(color: Colors.red),
              onPressed: () {
                controller.text = widget.appointment.subject;
                Navigator.pop(context);
              },
              child: const Text("Cancel"),
            ),
            CupertinoDialogAction(
              onPressed: () {
                context.read<DataSourceViewModel>().changeAppointmentName(
                    appointment: widget.appointment, text: controller.text);
                Navigator.pop(context);
              },
              isDefaultAction: true,
              textStyle: TextStyle(color: Theme.of(context).primaryColor),
              child: const Text("Apply"),
            ),
          ],
        ),
      );
    } else {
      //TODO: When more Feature mode
    }
  }

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
                  context
                      .read<DataSourceViewModel>()
                      .deleteAppoinment(appointment: widget.appointment);
                },
                icon: FontAwesomeIcons.trash,
              ),
            ],
          ),
          child: Container(
            width: double.maxFinite,
            height: MediaQuery.of(context).size.height * 0.060,
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
                      width: MediaQuery.of(context).size.width * 0.4,
                      child: Text(
                        widget.appointment.subject,
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color:
                              isDarkMode(context) ? Colors.white : Colors.black,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
                InkWell(
                  onTap: () {
                    showCupertinoDialog(
                      barrierDismissible: true,
                      context: context,
                      builder: (context) => Dialog(
                        backgroundColor: Colors.white,
                        surfaceTintColor: Colors.white,
                        shape: const BeveledRectangleBorder(),
                        insetPadding: const EdgeInsets.symmetric(vertical: 200),
                        child: Column(
                          children: [
                            const Text("Change time"),
                            GestureDetector(
                              onTap: () {
                                showCupertinoModalPopup(
                                  context: context,
                                  builder: (context) => Container(
                                    height: 216,
                                    padding: const EdgeInsets.only(top: 6.0),
                                    margin: EdgeInsets.only(
                                      bottom: MediaQuery.of(context)
                                          .viewInsets
                                          .bottom,
                                    ),
                                    color: CupertinoColors.systemBackground
                                        .resolveFrom(context),
                                    child: SafeArea(
                                      top: false,
                                      child: CupertinoDatePicker(
                                        onDateTimeChanged: (value) {},
                                      ),
                                    ),
                                  ),
                                );
                              },
                              child: const Text("Change"),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                  child: SizedBox(
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
      return "${getThreeCharDay(widget.appointment.startTime)} ${getOnlyTime(widget.appointment.startTime)} \n - ${getThreeCharDay(widget.appointment.endTime)} ${getOnlyTime(widget.appointment.endTime)}";
    } else if (getOnlyTime(widget.appointment.startTime) ==
        getOnlyTime(widget.appointment.endTime)) {
      return getOnlyTime(widget.appointment.startTime);
    }

    return "${getOnlyTime(widget.appointment.startTime)} - ${getOnlyTime(widget.appointment.endTime)}";
  }
}
