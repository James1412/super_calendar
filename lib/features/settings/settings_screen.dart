import 'dart:io';
import 'package:animated_emoji/animated_emoji.dart';
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

class _SettingsScreenState extends State<SettingsScreen>
    with SingleTickerProviderStateMixin {
  late final AnimationController _animationController = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 400),
    reverseDuration: const Duration(milliseconds: 300),
  );
  late final Animation<double> scale =
      Tween(begin: 1.0, end: 1.3).animate(curve);
  late final CurvedAnimation curve = CurvedAnimation(
      parent: _animationController,
      curve: Curves.fastLinearToSlowEaseIn,
      reverseCurve: Curves.bounceIn);

  @override
  void dispose() {
    _animationController.dispose();
    curve.dispose();
    super.dispose();
  }

  bool animateMuscle = false;
  bool animateMoon = false;

  @override
  Widget build(BuildContext context) {
    bool moreFeature = context.watch<MoreFeatures>().moreFeatures;
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Settings",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      body: Column(
        children: [
          SwitchListTile(
            activeColor: Theme.of(context).primaryColor,
            inactiveThumbColor: Colors.grey,
            inactiveTrackColor: Colors.grey.shade300,
            trackOutlineColor: MaterialStateProperty.all(Colors.transparent),
            title: Row(
              children: [
                const Text(
                  "Enable dark mode ",
                ),
                AnimatedEmoji(
                  AnimatedEmojis.moonFaceLastQuarter,
                  animate: animateMoon,
                ),
              ],
            ),
            value: isDarkMode(context),
            onChanged: (value) {
              if (Platform.isIOS) {
                HapticFeedback.selectionClick();
              }
              context.read<DarkModeProvider>().setDarkMode(value);
              if (Provider.of<DarkModeProvider>(context, listen: false)
                  .isDarkMode) {
                setState(() {
                  animateMoon = true;
                });
              } else {
                setState(() {
                  animateMoon = false;
                });
              }
            },
          ),
          InkWell(
            onTap: () {},
            child: SwitchListTile(
              activeColor: Theme.of(context).primaryColor,
              inactiveThumbColor: Colors.grey,
              inactiveTrackColor: Colors.grey.shade300,
              trackOutlineColor: MaterialStateProperty.all(Colors.transparent),
              value: false,
              onChanged: (value) {},
              title: const Text("Show Lunar Calendar 📅"),
            ),
          ),
          AnimatedBuilder(
            animation: _animationController,
            builder: (context, child) => ScaleTransition(
              scale: scale,
              child: SwitchListTile(
                activeColor: Theme.of(context).primaryColor,
                inactiveThumbColor: Colors.grey,
                inactiveTrackColor: Colors.grey.shade300,
                trackOutlineColor:
                    MaterialStateProperty.all(Colors.transparent),
                title: Row(
                  children: [
                    const Text("Enable feature rich mode "),
                    AnimatedEmoji(
                      AnimatedEmojis.muscle,
                      size: 20,
                      animate: animateMuscle,
                    ),
                  ],
                ),
                value: moreFeature,
                onChanged: (value) async {
                  if (Platform.isIOS) {
                    HapticFeedback.selectionClick();
                  }
                  context.read<MoreFeatures>().setMoreFeatures(value);
                  if (Provider.of<MoreFeatures>(context, listen: false)
                      .moreFeatures) {
                    await _animationController.forward();
                    await _animationController.reverse();
                    setState(() {
                      animateMuscle = true;
                    });
                  } else {
                    setState(() {
                      animateMuscle = false;
                    });
                  }
                },
              ),
            ),
          ),
          InkWell(
            onTap: () {},
            child: const ListTile(
                title: Text("What's included in feature rich mode? 🤔")),
          ),
          InkWell(
            onTap: () {},
            child: const ListTile(
              title: Text("Manage your features 🚀"),
            ),
          ),
          InkWell(
            onTap: () {},
            child: const ListTile(title: Text("Sign up to enable syncing 💥")),
          ),
        ],
      ),
    );
  }
}
