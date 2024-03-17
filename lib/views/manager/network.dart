import 'package:flutter/material.dart';
import 'package:scouting_app/models/server/server.dart';
import 'package:scouting_app/widgets/centered_card.dart';
import 'package:watch_it/watch_it.dart';

class NetworkView extends WatchingWidget {
  @override
  Widget build(BuildContext context) {
    final running = watchPropertyValue((Server s) => s.running);
    final port = watchPropertyValue((Server s) => s.port);
    final numClients = watchPropertyValue((Server s) => s.numClients);

    return CenteredCard(
        child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
          if (running)
            Row(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.circle),
                Text(' Server running'),
              ],
            )
          else
            Row(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.circle_outlined),
                Text(' Server stopped'),
              ],
            ),
          SizedBox(height: 8.0),
          Text('Port: $port'),
          SizedBox(height: 8.0),
          Text('$numClients client(s) connected.'),
        ]));
  }
}
