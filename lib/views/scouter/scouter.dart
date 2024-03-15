import 'package:flutter/material.dart';

class ScouterView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Scouter')),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: const Text('Scouter'),
      ),
    );
  }
}
