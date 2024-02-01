import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:super_calendar/utils.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';

class AppointmentTile extends StatelessWidget {
  final Appointment event;
  const AppointmentTile({super.key, required this.event});

  void onTap() {
    //TODO: When default mode
    //TODO: When more Feature mode
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
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
                onPressed: (value) {},
                icon: FontAwesomeIcons.trash,
              ),
            ],
          ),
          child: Container(
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
                          color: event.color,
                          borderRadius: BorderRadius.circular(5),
                        ),
                        width: 5,
                        height: double.maxFinite,
                      ),
                    ),
                    SizedBox(
                      width: MediaQuery.of(context).size.width * 0.4,
                      child: Text(
                        event.subject,
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
    if (event.isAllDay) {
      return 'all-day';
    } else if (getOnlyDate(event.startTime) != getOnlyDate(event.endTime)) {
      return "${getThreeCharDay(event.startTime)} ${getOnlyTime(event.startTime)} \n - ${getThreeCharDay(event.endTime)} ${getOnlyTime(event.endTime)}";
    } else if (getOnlyTime(event.startTime) == getOnlyTime(event.endTime)) {
      return getOnlyTime(event.startTime);
    }

    return "${getOnlyTime(event.startTime)} - ${getOnlyTime(event.endTime)}";
  }
}
