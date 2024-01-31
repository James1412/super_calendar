import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:super_calendar/features/calendar/components/event_model.dart';
import 'package:super_calendar/utils.dart';

class EventTile extends StatelessWidget {
  final Event event;
  const EventTile({super.key, required this.event});

  @override
  Widget build(BuildContext context) {
    return Padding(
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
                        color: event.background,
                        borderRadius: BorderRadius.circular(5),
                      ),
                      width: 5,
                      height: double.maxFinite,
                    ),
                  ),
                  SizedBox(
                    width: MediaQuery.of(context).size.width * 0.4,
                    child: Text(
                      event.eventName,
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
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15),
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
    );
  }
}
