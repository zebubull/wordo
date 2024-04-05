import 'package:flutter/material.dart';
import 'package:scouting_app/views/manager/manager.dart';
import 'package:scouting_app/views/settings.dart';
import 'scouter/scouter.dart';

class HomeView extends StatefulWidget {
  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Role Select'),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => SettingsView())),
        child: const Icon(Icons.settings),
      ),
      body: Center(
          child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text('Select your role:',
              style: Theme.of(context).textTheme.titleLarge),
          SizedBox(height: 10.0),
          ElevatedButton(
              child: const Text('Scouter'),
              onPressed: () => Navigator.push(context,
                  MaterialPageRoute(builder: (context) => ScouterView()))),
          SizedBox(height: 10.0),
          ElevatedButton(
              child: const Text('Manager'),
              onPressed: () => Navigator.push(context,
                  MaterialPageRoute(builder: (context) => ManagerView()))),
        ],
      )),
    );
  }
}
