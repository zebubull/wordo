import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:scouting_app/providers/client.dart';
import 'package:scouting_app/widgets/centered_card.dart';

class ConnectionPanel extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<ClientProvider>(builder: (context, network, child) {
      return CenteredCard(children: [
        if (network.connected)
          Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.circle),
              Text(' Connected to server'),
            ],
          )
        else
          Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.circle_outlined),
              Text(' Disconnected'),
            ],
          ),
        Text('Id: ${network.client?.id ?? -1}'),
      ]);
    });
  }
}
