import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:super_calendar/features/settings/view_models/more_feature_provider.dart';
import 'package:super_calendar/features/calendar/view_models/data_source_vm.dart';
import 'package:super_calendar/features/settings/view_models/dark_mode_provider.dart';
import 'package:super_calendar/features/navigation/bottom_navigation_screen.dart';
import 'package:super_calendar/features/settings/view_models/settings_items_vm.dart';
import 'package:super_calendar/utils.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (context) => MoreFeatures(),
        ),
        ChangeNotifierProvider(
          create: (context) => DarkModeProvider(),
        ),
        ChangeNotifierProvider(
          create: (context) => DataSourceViewModel(),
        ),
        ChangeNotifierProvider(
          create: (context) => SettingsItemViewModel(),
        ),
      ],
      child: const SuperCalendarApp(),
    ),
  );
}

class SuperCalendarApp extends StatelessWidget {
  const SuperCalendarApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        brightness: Brightness.light,
        primaryColor: context.watch<SettingsItemViewModel>().primaryColor,
        scaffoldBackgroundColor: Colors.white,
        textTheme: Typography.blackCupertino,
        dialogTheme: const DialogTheme(
          surfaceTintColor: Colors.white,
          shadowColor: Colors.white,
          backgroundColor: Colors.white,
        ),
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.white,
          shadowColor: Colors.white,
          surfaceTintColor: Colors.white,
        ),
      ),
      darkTheme: ThemeData(
        dialogTheme: const DialogTheme(
          surfaceTintColor: Color(0xff121212),
          shadowColor: Color(0xff121212),
          backgroundColor: Color(0xff121212),
        ),
        brightness: Brightness.dark,
        primaryColor: context.watch<SettingsItemViewModel>().primaryColor,
        textTheme: Typography.whiteCupertino,
        scaffoldBackgroundColor: const Color(0xff121212),
        appBarTheme: const AppBarTheme(
          backgroundColor: Color(0xff121212),
          shadowColor: Color(0xff121212),
          surfaceTintColor: Color(0xff121212),
        ),
      ),
      themeMode: isDarkMode(context) ? ThemeMode.dark : ThemeMode.light,
      home: const BottomNavigationScreen(),
    );
  }
}
