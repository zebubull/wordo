import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:scouting_app/viewmodels/server.dart';

class ManagerView extends StatefulWidget {
  @override
  State<ManagerView> createState() => _ManagerViewState();
}

class _ManagerViewState extends State<ManagerView> {
  @override
  void initState() {
    super.initState();
    Provider.of<ServerViewModel>(context, listen: false).initializeServer();
  }

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
