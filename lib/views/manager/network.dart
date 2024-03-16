import 'package:flutter/material.dart';
import 'package:scouting_app/models/server/server.dart';
import 'package:scouting_app/views/manager/client.dart';
import 'package:scouting_app/widgets/centered_card.dart';
import 'package:watch_it/watch_it.dart';

class NetworkView extends WatchingWidget {
  @override
  Widget build(BuildContext context) {
    final running = watchPropertyValue((Server s) => s.running);
    final port = watchPropertyValue((Server s) => s.port);
    final clients = watchPropertyValue((Server s) => s.clients);

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
          Text('Port: $port'),
          for (var client in clients)
            if (client != null)
              Padding(
                padding: const EdgeInsets.all(4.0),
                child: ElevatedButton(
                    child: Text(
                        '${client.sock.remoteAddress.address} (${client.id})'),
                    onPressed: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (_) => ClientView(client.id)))),
              ),
        ]));
  }
}
