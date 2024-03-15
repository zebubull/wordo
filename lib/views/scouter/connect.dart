import 'dart:io';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:scouting_app/viewmodels/client.dart';
import 'package:scouting_app/widgets/connection_panel.dart';

class ConnectView extends StatefulWidget {
  @override
  State<ConnectView> createState() => _ConnectViewState();
}

class _ConnectViewState extends State<ConnectView> {
  final _formKey = GlobalKey<FormState>();
  final _ip = TextEditingController();
  final _port = TextEditingController();

  void _connectClient() {
    try {
      final ip = InternetAddress.tryParse(_ip.text)!;
      final port = int.tryParse(_port.text)!;

      Provider.of<ClientViewModel>(context, listen: false).connectToServer(ip, port);
    } catch (err) {
      print('[DEBUG] Invalid form inputs: $err');
    }
  }

  @override
  void dispose() {
    _ip.dispose();
    _port.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Form(
        key: _formKey,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              width: 450,
              child: TextFormField(
                decoration: const InputDecoration(hintText: 'IP', border: OutlineInputBorder()),
                keyboardType: TextInputType.number,
                controller: _ip,
              ),
            ),
            SizedBox(height: 8.0),
            SizedBox(
              width: 450,
              child: TextFormField(
                decoration: const InputDecoration(hintText: 'Port', border: OutlineInputBorder()),
                keyboardType: TextInputType.number,
                controller: _port,
              ),
            ),
            SizedBox(height: 8.0),
            ElevatedButton(
              onPressed: _connectClient,
              child: const Text('Connect'),
            ),
            SizedBox(height: 24.0),
            ConnectionPanel(),
          ],
        ),
      ),
    );
  }
}
