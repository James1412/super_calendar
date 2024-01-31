import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:iconsax/iconsax.dart';
import 'package:provider/provider.dart';
import 'package:super_calendar/features/settings/view_models/more_feature_provider.dart';
import 'package:super_calendar/features/calendar/home_screen.dart';
import 'package:super_calendar/features/manage/manage_screen.dart';
import 'package:super_calendar/features/navigation/components/nav_button.dart';
import 'package:super_calendar/features/settings/settings_screen.dart';
import 'package:super_calendar/utils.dart';

class BottomNavigationScreen extends StatefulWidget {
  const BottomNavigationScreen({super.key});

  @override
  State<BottomNavigationScreen> createState() => _BottomNavigationScreenState();
}

class _BottomNavigationScreenState extends State<BottomNavigationScreen>
    with SingleTickerProviderStateMixin {
  late List<Widget> screens = [
    const HomeScreen(),
    const ManageScreen(),
    const SettingsScreen(),
  ];

  int index = 0;

  void onNavTap(int selectedIndex) {
    setState(() {
      index = selectedIndex;
    });
    if (Platform.isIOS) {
      HapticFeedback.mediumImpact();
    }
  }

  @override
  Widget build(BuildContext context) {
    bool moreFeature = context.watch<MoreFeatures>().moreFeatures;
    return Scaffold(
      body: screens[index],
      bottomNavigationBar: BottomAppBar(
        height: 55,
        color: Colors.transparent,
        shadowColor: Colors.transparent,
        surfaceTintColor: Colors.transparent,
        padding: const EdgeInsets.only(left: 20, right: 20),
        child: Container(
          decoration: BoxDecoration(
            color: isDarkMode(context) ? const Color(0xff121212) : Colors.white,
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.5),
                spreadRadius: 2,
                blurRadius: 5,
                offset: const Offset(0, 2),
              ),
            ],
            borderRadius: BorderRadius.circular(15),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Expanded(
                child: NavButton(
                  icon: Iconsax.home,
                  onTap: () => onNavTap(0),
                  isSelected: index == 0,
                ),
              ),
              if (moreFeature)
                Expanded(
                  child: NavButton(
                    icon: Iconsax.tag,
                    onTap: () => onNavTap(1),
                    isSelected: index == 1,
                  ),
                ),
              Expanded(
                child: NavButton(
                  icon: Iconsax.setting,
                  onTap: () => onNavTap(2),
                  isSelected: index == 2,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
