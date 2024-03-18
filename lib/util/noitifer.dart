import 'package:flutter/material.dart';
import 'package:scouting_app/main.dart';

void showNotification(String text, {Duration? duration}) {
  ScaffoldMessenger.of(navigatorKey.currentContext!).showSnackBar(SnackBar(
    content: Text(text),
    duration: duration ?? Duration(seconds: 3),
  ));
}
