import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:super_calendar/features/authentication/more_feature_provider.dart';
import 'package:super_calendar/features/darkmode/dark_mode_provider.dart';
import 'package:super_calendar/utils.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Settings",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      body: Column(
        children: [
          InkWell(
            onTap: () {},
            child: const ListTile(
              title: Text("How to use?"),
            ),
          ),
          SwitchListTile(
            activeColor: Theme.of(context).primaryColor,
            inactiveThumbColor: Colors.grey,
            inactiveTrackColor: Colors.grey.shade300,
            trackOutlineColor: MaterialStateProperty.all(Colors.transparent),
            title: const Text(
              "Enable dark mode",
            ),
            value: isDarkMode(context),
            onChanged: (value) {
              if (Platform.isIOS) {
                HapticFeedback.selectionClick();
              }
              context.read<DarkModeProvider>().setDarkMode(value);
            },
          ),
          SwitchListTile(
            activeColor: Theme.of(context).primaryColor,
            inactiveThumbColor: Colors.grey,
            inactiveTrackColor: Colors.grey.shade300,
            trackOutlineColor: MaterialStateProperty.all(Colors.transparent),
            title: const Text("Enable more features"),
            value: context.watch<MoreFeatures>().moreFeatures,
            onChanged: (value) {
              if (Platform.isIOS) {
                HapticFeedback.selectionClick();
              }
              context.read<MoreFeatures>().setMoreFeatures(value);
            },
          ),
          InkWell(
            onTap: () {},
            child: const ListTile(
              title: Text("What is included in more features?"),
            ),
          ),
        ],
      ),
    );
  }
}
