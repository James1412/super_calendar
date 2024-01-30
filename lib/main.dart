import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:super_calendar/features/authentication/more_feature_provider.dart';
import 'package:super_calendar/features/darkmode/dark_mode_provider.dart';
import 'package:super_calendar/features/navigation/bottom_navigation_screen.dart';
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
        primaryColor: Colors.orange,
        scaffoldBackgroundColor: Colors.white,
        textTheme: Typography.blackCupertino,
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.white,
          shadowColor: Colors.white,
          surfaceTintColor: Colors.white,
        ),
      ),
      darkTheme: ThemeData(
        brightness: Brightness.dark,
        primaryColor: Colors.orange,
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
