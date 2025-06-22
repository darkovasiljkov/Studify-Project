import 'package:flutter/material.dart';

class AppConstants {
  // Application Name
  static const String appName = "Studify";

  // Colors
  static const Color primaryColor = Colors.blue;
  static const Color accentColor = Colors.orange;
  static const Color backgroundColor = Colors.white;
  static const Color textColor = Colors.black;

  // Text Styles
  static const TextStyle headingStyle = TextStyle(
    fontSize: 24,
    fontWeight: FontWeight.bold,
    color: textColor,
  );

  static const TextStyle bodyStyle = TextStyle(
    fontSize: 16,
    color: textColor,
  );

  static const TextStyle buttonTextStyle = TextStyle(
    fontSize: 18,
    color: Colors.white,
    fontWeight: FontWeight.bold,
  );

  // Padding and Margins
  static const double defaultPadding = 16.0;
  static const double defaultMargin = 16.0;

  // Routes
  static const String loginRoute = "/";
  static const String homeRoute = "/home";
  static const String calendarRoute = "/calendar";
  static const String taskDetailsRoute = "/task-details";
  static const String addEventRoute = "/add-event";
  static const String locationRoute = "/location";
  static const String profileRoute = "/profile";
  static const String settingsRoute = "/settings";
  static const String taskListRoute = "/task-list";
}
