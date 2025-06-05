import 'package:flutter/material.dart';
import 'package:projeto_final_rotina_estudos/screens/register_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

// Telas principais
import 'screens/login_screen.dart';
import 'screens/home_screen.dart';
import 'screens/calendar_screen.dart';
import 'screens/tasks_screen.dart';        // Tela unificada de Tarefas e Provas
import 'screens/performance_screen.dart';
import 'screens/profile_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
      

  final prefs = await SharedPreferences.getInstance();
  final bool isLoggedIn = prefs.getBool('isLoggedIn') ?? false;

  runApp(MyApp(isLoggedIn: isLoggedIn));
}

class MyApp extends StatefulWidget {
  final bool isLoggedIn;

  const MyApp({super.key, required this.isLoggedIn});

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
      initialRoute: widget.isLoggedIn ? '/home' : '/',
      routes: {
  '/': (context) => const LoginScreen(), // <- ADICIONE ESTA LINHA
  '/login': (context) => const LoginScreen(),
  '/register': (context) => const RegisterScreen(),
  '/home': (context) => const HomeScreen(),
  '/calendar': (context) => CalendarScreen(),
  '/tasks': (context) => const TasksScreen(),
  '/performance': (context) => PerformanceScreen(),
  '/profile': (context) => ProfileScreen(
        onThemeChanged: toggleTheme,
        isDarkTheme: isDarkTheme,
      ),
},
    );
  }
}