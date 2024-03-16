import 'dart:io';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:scouting_app/providers/server.dart';
import 'package:scouting_app/views/manager/network.dart';

class ManagerView extends StatefulWidget {
  @override
  State<ManagerView> createState() => _ManagerViewState();
}

class _ManagerViewState extends State<ManagerView> {
  @override
  void initState() {
    super.initState();
    var server = Provider.of<ServerProvider>(context, listen: false);
    if (!server.running) {
      server.start(InternetAddress('0.0.0.0'), 42069);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Manager')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [NetworkView()],
        ),
      ),
    );
  }
}
