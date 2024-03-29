import 'dart:io';
import 'package:animated_emoji/animated_emoji.dart';
import 'package:flex_color_picker/flex_color_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:super_calendar/features/settings/services/get_holiday_service.dart';
import 'package:super_calendar/features/settings/view_models/more_feature_provider.dart';
import 'package:super_calendar/features/settings/view_models/dark_mode_provider.dart';
import 'package:super_calendar/features/settings/view_models/settings_items_vm.dart';
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
  List<int> val = [2, 6];
  int selectedIndex = 1;
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
                    context.read<SettingsItemViewModel>().weekNumIndex = 3;
                    context
                        .read<SettingsItemViewModel>()
                        .setShowLeadingTrailingDates(false);
                    setState(() {
                      animateMuscle = false;
                    });
                  }
                },
              ),
            ),
          ),
          if (moreFeature)
            Column(
              children: [
                InkWell(
                  onTap: () {
                    showCupertinoModalPopup(
                      context: context,
                      builder: (context) => SizedBox(
                        height: 216,
                        child: CupertinoPicker(
                          backgroundColor: Colors.white,
                          squeeze: 1.2,
                          magnification: 1.22,
                          useMagnifier: true,
                          itemExtent: 32.0,
                          scrollController: FixedExtentScrollController(
                              initialItem: context
                                  .watch<SettingsItemViewModel>()
                                  .weekNumIndex),
                          onSelectedItemChanged: (value) {
                            setState(() {
                              context
                                  .read<SettingsItemViewModel>()
                                  .setWeekNum(value);
                            });
                          },
                          children: [
                            for (int i = 0;
                                i <
                                    context
                                        .watch<SettingsItemViewModel>()
                                        .indexAndWeekNumList
                                        .length;
                                i++)
                              Center(
                                child: Text(
                                  context
                                      .watch<SettingsItemViewModel>()
                                      .indexAndWeekNumList[i]
                                      .toString(),
                                  style: const TextStyle(color: Colors.black),
                                ),
                              ),
                          ],
                        ),
                      ),
                    );
                  },
                  child: ListTile(
                    title: const Text("Number of weeks"),
                    trailing: Text(
                      context
                          .watch<SettingsItemViewModel>()
                          .indexAndWeekNumList[context
                              .watch<SettingsItemViewModel>()
                              .weekNumIndex]
                          .toString(),
                      style: const TextStyle(fontSize: 14),
                    ),
                  ),
                ),
                SwitchListTile(
                  activeColor: Theme.of(context).primaryColor,
                  inactiveThumbColor: Colors.grey,
                  inactiveTrackColor: Colors.grey.shade300,
                  trackOutlineColor:
                      MaterialStateProperty.all(Colors.transparent),
                  value: context
                      .watch<SettingsItemViewModel>()
                      .showLeadingAndTrailingDates,
                  onChanged: (value) {
                    context
                        .read<SettingsItemViewModel>()
                        .setShowLeadingTrailingDates(value);
                  },
                  title: const Text("Show leading and trailing dates 😶‍🌫️"),
                ),
              ],
            ),
          InkWell(
            onTap: () async {
              Color primaryColor = await showColorPickerDialog(
                context,
                Theme.of(context).primaryColor,
              );
              if (!mounted) return;
              context
                  .read<SettingsItemViewModel>()
                  .changePrimaryColor(primaryColor);
            },
            child: ListTile(
              title: const Text("Change primary color"),
              trailing: Container(
                height: 30,
                width: 30,
                decoration: BoxDecoration(
                  color: Theme.of(context).primaryColor,
                  shape: BoxShape.circle,
                ),
              ),
            ),
          ),
          InkWell(
            onTap: () {
              showCupertinoModalPopup(
                context: context,
                builder: (context) => SizedBox(
                  height: 200,
                  child: CupertinoPicker(
                    backgroundColor: Colors.white,
                    squeeze: 1.2,
                    magnification: 1.22,
                    useMagnifier: true,
                    itemExtent: 32.0,
                    scrollController: FixedExtentScrollController(
                        initialItem: context
                            .watch<SettingsItemViewModel>()
                            .eventViewIndex),
                    onSelectedItemChanged: (value) => context
                        .read<SettingsItemViewModel>()
                        .setEventView(value),
                    children: const [
                      Center(
                        child: Text(
                          "list",
                          style: TextStyle(color: Colors.black),
                        ),
                      ),
                      Center(
                        child: Text(
                          "indicator",
                          style: TextStyle(color: Colors.black),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
            child: ListTile(
              title: const Text("Event view"),
              trailing: Text(
                context.watch<SettingsItemViewModel>().eventViewIndex == 0
                    ? "list"
                    : "indicator",
                style: const TextStyle(fontSize: 14),
              ),
            ),
          ),
          // Holiday
          InkWell(
            onTap: () async {
              await showCupertinoModalPopup(
                context: context,
                builder: (context) => SizedBox(
                  height: 300,
                  child: CupertinoPicker(
                    backgroundColor: Colors.white,
                    squeeze: 1.2,
                    magnification: 1.22,
                    useMagnifier: true,
                    itemExtent: 32.0,
                    scrollController: FixedExtentScrollController(
                        initialItem: context
                            .watch<SettingsItemViewModel>()
                            .holidayIndex),
                    onSelectedItemChanged: (value) => context
                        .read<SettingsItemViewModel>()
                        .setHolidayIndex(value),
                    children: countries.keys
                        .map(
                          (e) => Center(
                            child: Text(
                              e,
                              style: const TextStyle(color: Colors.black),
                            ),
                          ),
                        )
                        .toList(),
                  ),
                ),
              );
              // Holiday api call  //
              if (!mounted) return;
              callHolidayApi(context, mounted);
              // ---------------- //
            },
            child: ListTile(
              title: const Text("Holiday Country 🎁"),
              trailing: Text(
                countries.keys.toList()[
                    context.watch<SettingsItemViewModel>().holidayIndex],
                style: const TextStyle(fontSize: 14),
              ),
            ),
          ),
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
          SwitchListTile(
            activeColor: Theme.of(context).primaryColor,
            inactiveThumbColor: Colors.grey,
            inactiveTrackColor: Colors.grey.shade300,
            trackOutlineColor: MaterialStateProperty.all(Colors.transparent),
            value: context.watch<SettingsItemViewModel>().showLunarDate,
            onChanged: (value) {
              context.read<SettingsItemViewModel>().setShowLunarDate(value);
            },
            title: const Text("Show Lunar Calendar 📅"),
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
