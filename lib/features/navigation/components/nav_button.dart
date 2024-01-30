import 'package:flutter/material.dart';
import 'package:super_calendar/utils.dart';

class NavButton extends StatelessWidget {
  final IconData icon;
  final Function onTap;
  final bool isSelected;
  const NavButton(
      {super.key,
      required this.onTap,
      required this.isSelected,
      required this.icon});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => onTap(),
      child: Container(
        color: Colors.transparent,
        height: double.maxFinite,
        child: Icon(
          icon,
          color: isSelected
              ? Theme.of(context).primaryColor
              : isDarkMode(context)
                  ? Colors.white
                  : Colors.black,
        ),
      ),
    );
  }
}
