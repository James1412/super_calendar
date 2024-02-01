import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:super_calendar/utils.dart';

class TodayButton extends StatelessWidget {
  const TodayButton({super.key});

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerRight,
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(
            color: isDarkMode(context) ? Colors.white : Colors.black,
          ),
          borderRadius: BorderRadius.circular(15),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(
              Iconsax.rotate_left,
              size: 15,
            ),
            Text(
              "Today",
              style: TextStyle(
                  color: isDarkMode(context) ? Colors.white : Colors.black),
            ),
          ],
        ),
      ),
    );
  }
}
