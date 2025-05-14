import 'package:flutter/material.dart';
import 'screens/welcome_screen.dart';
import 'screens/onboarding_screen.dart';
import 'screens/home_screen.dart';
import 'screens/add_task_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

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
      home: LaunchDecider(),
      routes: {
        '/onboarding': (context) => OnboardingScreen(),
        '/home': (context) => HomeScreen(),
        '/add': (context) => AddTaskScreen(),
      },
    );
  }
}

class LaunchDecider extends StatefulWidget {
  @override
  State<LaunchDecider> createState() => _LaunchDeciderState();
}

class _LaunchDeciderState extends State<LaunchDecider> {
  Future<bool> checkFirstOpen() async {
    final prefs = await SharedPreferences.getInstance();
    // isFirstOpen默认为true
    return prefs.getBool('isFirstOpen') ?? true;
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<bool>(
      future: checkFirstOpen(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          // 加载中
          return Scaffold(body: Center(child: CircularProgressIndicator()));
        }
        if (snapshot.data == true) {
          // 首次进入，显示欢迎页
          return WelcomeScreen();
        } else {
          // 非首次进入，直接进主页
          return HomeScreen();
        }
      },
    );
  }
}
