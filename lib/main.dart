import 'package:flutter/material.dart';
import 'package:super_calendar/features/navigation/bottom_navigation_screen.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const SuperCalendarApp());
}

class SuperCalendarApp extends StatelessWidget {
  const SuperCalendarApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: Colors.orange,
        scaffoldBackgroundColor: Colors.white,
      ),
      home: const BottomNavigationScreen(),
    );
  }
}
