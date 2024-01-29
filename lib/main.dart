import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:super_calendar/features/calendar/show_agenda_provider.dart';
import 'package:super_calendar/features/navigation/bottom_navigation_screen.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (context) => ShowAgendaProvider(),
        )
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
        primaryColor: Colors.orange,
        scaffoldBackgroundColor: Colors.white,
      ),
      home: const BottomNavigationScreen(),
    );
  }
}
