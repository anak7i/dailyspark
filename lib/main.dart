import 'package:flutter/material.dart';
import 'screens/welcome_screen.dart';
import 'screens/onboarding_screen.dart';
import 'screens/home_screen.dart';
import 'screens/add_task_screen.dart';

void main() {
  runApp(RoutineTrackApp());
}

class RoutineTrackApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'RoutineTrack',
      theme: ThemeData.dark().copyWith(
        scaffoldBackgroundColor: Color.fromARGB(255, 22, 22, 22),
        primaryColor: const Color.fromARGB(255, 2, 2, 2),
        colorScheme: ColorScheme.dark(
          primary: const Color.fromARGB(255, 244, 244, 244),
          secondary: const Color.fromARGB(255, 0, 0, 0),
        ),
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => WelcomeScreen(),
        '/onboarding': (context) => OnboardingScreen(),
        '/home': (context) => HomeScreen(),
        '/add': (context) => AddTaskScreen(),
      },
    );
  }
}
