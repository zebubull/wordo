import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:scouting_app/viewmodels/server.dart';

class ServerPanel extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Consumer<ServerViewModel>(builder: (context, server, child) {
      return Container(
        width: 450,
        decoration: BoxDecoration(
          color: theme.colorScheme.primaryContainer,
          borderRadius: BorderRadius.all(Radius.circular(8.0)),
        ),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(children: [
            if (server.running) Row(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.circle),
                Text(' Server running'),
              ],
            )
            else Row(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.circle_outlined),
                Text(' Server stopped'),
              ],
            ),
            Text('Port: ${server.port}'),
            Text('Active connections: ${server.numClients}'),
          ]),
        ),
      );
    });
  }
}

