import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:scouting_app/providers/client.dart';

class SettingsView extends StatefulWidget {
  @override
  State<SettingsView> createState() => _SettingsViewState();
}

class _SettingsViewState extends State<SettingsView> {
  final _formKey = GlobalKey<FormState>();
  final _username = TextEditingController();

  @override
  void initState() {
    super.initState();
    var currentName = Provider.of<ClientProvider>(context, listen: false).client?.name;
    if (currentName != null && currentName != "scouter") {
      _username.text = currentName;
    }
  }

  void _saveSettings() {
    var client = Provider.of<ClientProvider>(context, listen: false);
    client.updateName(_username.text);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Center(
      child: Container(
        decoration: BoxDecoration(
            color: theme.colorScheme.primaryContainer,
            borderRadius: BorderRadius.all(Radius.circular(8.0))),
        width: 450,
        child: Padding(
          padding: EdgeInsets.all(8.0),
          child: Form(
            key: _formKey,
            child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextFormField(
                      controller: _username,
                      decoration: InputDecoration(
                          border: OutlineInputBorder(), hintText: "Username")),
                  SizedBox(height: 8.0),
                  ElevatedButton.icon(
                      onPressed: _saveSettings,
                      icon: const Icon(Icons.save),
                      label: const Text('Save')),
                ]),
          ),
        ),
      ),
    );
  }
}
