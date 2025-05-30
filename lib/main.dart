import 'package:flutter/material.dart';
import 'screens/login_screen.dart';
import 'screens/home_screen.dart';
import 'screens/calendar_screen.dart';
import 'screens/tasks_screen.dart';
import 'screens/subjects_screen.dart';
import 'screens/performance_screen.dart';
import 'screens/profile_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  bool isDarkTheme = false;

  void toggleTheme(bool value) {
    setState(() {
      isDarkTheme = value;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'EduTrack',
      debugShowCheckedModeBanner: false,
      theme: isDarkTheme ? ThemeData.dark() : ThemeData.light(),
      initialRoute: '/',
      routes: {
  '/': (context) => LoginScreen(onThemeChanged: toggleTheme),
  '/home': (context) => const HomeScreen(),
  '/calendar': (context) => CalendarScreen(),
  '/tasks': (context) => TasksScreen(),
  '/subjects': (context) => const SubjectsScreen(),
  '/performance': (context) => PerformanceScreen(),
  '/profile': (context) => const ProfileScreen(),
},

    );
  }
}
