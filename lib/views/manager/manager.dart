import 'package:flutter/material.dart';
import 'package:scouting_app/views/manager/network.dart';

class ManagerView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Manager')),
      body: Center(
        child: NetworkView(),
      ),
    );
  }
}
