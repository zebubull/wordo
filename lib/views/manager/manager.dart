import 'package:flutter/material.dart';

class ManagerView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Manager')),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: const Text('Manager'),
      ),
    );
  }
}
