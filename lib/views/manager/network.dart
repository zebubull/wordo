import 'package:flutter/material.dart';
import 'package:scouting_app/widgets/server_panel.dart';

class NetworkView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(children: [
        ServerPanel(),
      ]),
    );
  }
}
