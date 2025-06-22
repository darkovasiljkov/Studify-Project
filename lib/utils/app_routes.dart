import 'package:flutter/material.dart';
import '../screens/login_screen.dart';
import '../screens/home_screen.dart';
import '../screens/calendar_screen.dart';
import '../screens/task_details_screen.dart';
import '../screens/add_event_screen.dart';
import '../screens/location_screen.dart';
import '../screens/profile_screen.dart';
import '../screens/settings_screen.dart';
import '../screens/signup_screen.dart';
import '../models/task_model.dart';
import '../screens/add_task_screen.dart';

class AppRoutes {
  // Routes without arguments
  static final routes = {
    '/': (context) => LoginScreen(),
    '/signup': (context) => SignUpScreen(),
    '/home': (context) => HomeScreen(),
    '/calendar': (context) => CalendarScreen(),
    '/add-task': (context) => AddTaskScreen(),
    '/add-event': (context) => AddEventScreen(),
    '/location': (context) => LocationScreen(),
    '/profile': (context) => ProfileScreen(),
    '/settings': (context) => SettingsScreen(),
  };

  // Handle routes with arguments
  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case '/task-details':
        final args = settings.arguments;
        if (args is Task) {
          return MaterialPageRoute(
            builder: (_) => TaskDetailsScreen(task: args),
          );
        }
        return MaterialPageRoute(
          builder: (_) => Scaffold(
            body: Center(child: Text('Task data is missing or invalid!')),
          ),
        );

      default:
        return MaterialPageRoute(
          builder: (_) => const Scaffold(
            body: Center(child: Text('No route defined')),
          ),
        );
    }
  }
}
