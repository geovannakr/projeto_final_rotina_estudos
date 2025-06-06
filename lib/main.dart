import 'package:flutter/material.dart';
import 'package:projeto_final_rotina_estudos/screens/chat_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'screens/login_screen.dart';
import 'screens/home_screen.dart';
import 'screens/calendar_screen.dart';
import 'screens/tasks_screen.dart';
import 'screens/performance_screen.dart';
import 'screens/profile_screen.dart';

final ValueNotifier<bool> isDarkMode = ValueNotifier(false);

const supabaseUrl = 'https://fsumddencoudxgptixay.supabase.co';
const supabaseAnonKey = 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImZzdW1kZGVuY291ZHhncHRpeGF5Iiwicm9sZSI6ImFub24iLCJpYXQiOjE3NDkxNTkwNjAsImV4cCI6MjA2NDczNTA2MH0.3uwgpeKDpCKb6ZQlHKQFMIv2huB0G0hGlOBrK9ihpr8';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Supabase.initialize(
    url: supabaseUrl,
    anonKey: supabaseAnonKey,
  );

  final prefs = await SharedPreferences.getInstance();
  final bool isLoggedIn = prefs.getBool('isLoggedIn') ?? false;
  final bool savedDarkMode = prefs.getBool('isDarkMode') ?? false;

  isDarkMode.value = savedDarkMode;

  runApp(MyApp(isLoggedIn: isLoggedIn));
}

class MyApp extends StatelessWidget {
  final bool isLoggedIn;

  const MyApp({super.key, required this.isLoggedIn});

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<bool>(
      valueListenable: isDarkMode,
      builder: (context, darkMode, _) {
        return MaterialApp(
          title: 'StudyFlow',
          debugShowCheckedModeBanner: false,
          theme: ThemeData(
            colorScheme: ColorScheme.fromSeed(
              seedColor: const Color(0xFF1565C0),
              brightness: Brightness.light,
            ),
            useMaterial3: true,
          ),
          darkTheme: ThemeData(
            colorScheme: ColorScheme.fromSeed(
              seedColor: const Color(0xFF1565C0),
              brightness: Brightness.dark,
            ),
            useMaterial3: true,
          ),
          themeMode: darkMode ? ThemeMode.dark : ThemeMode.light,
          initialRoute: isLoggedIn ? '/home' : '/login',
          routes: {
            '/login': (context) => const LoginScreen(),
            '/home': (context) => HomeScreen(),
            '/calendar': (context) => const CalendarScreen(),
            '/tasks': (context) => const TasksScreen(),
            '/performance': (context) => const PerformanceScreen(),
            '/profile': (context) => const ProfileScreen(),
            '/chat': (context) => const ChatScreen(),
          },
        );
      },
    );
  }
}