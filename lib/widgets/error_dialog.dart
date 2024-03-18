import 'package:flutter/material.dart';
import 'package:scouting_app/main.dart';

class ErrorDialog extends StatelessWidget {
  final String title;
  final String body;

  final void Function() onPressed;

  static void show(String title, String body, void Function() onPressed) {
    showDialog(
        context: navigatorKey.currentContext!,
        builder: (_) => ErrorDialog(title, body, onPressed));
  }

  ErrorDialog(this.title, this.body, this.onPressed);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(title),
      content: Text(body),
      actions: [
        ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              onPressed();
            },
            child: const Text('Ok'))
      ],
    );
  }
}
