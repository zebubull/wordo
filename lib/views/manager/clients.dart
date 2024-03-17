import 'package:flutter/material.dart';
import 'package:scouting_app/models/server/server.dart';
import 'package:scouting_app/views/manager/client.dart';
import 'package:scouting_app/widgets/centered_card.dart';
import 'package:watch_it/watch_it.dart';

class ClientListView extends WatchingWidget {
  @override
  Widget build(BuildContext context) {
    final clients = watchPropertyValue((Server s) => s.clients);
    final numClients = watchPropertyValue((Server s) => s.numClients);
    return CenteredCard(
      width: 600,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: ListView(
          shrinkWrap: true,
          children: [
            if (numClients == 0) const Text('No clients connected'),
            for (var client in clients)
              if (client != null)
                Padding(
                  padding: const EdgeInsets.all(4.0),
                  child: ElevatedButton(
                      child: Text(
                          '${client.username}@${client.sock.remoteAddress.host} (${client.id})'),
                      onPressed: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (_) => ClientView(client.id)))),
                ),
          ],
        ),
      ),
    );
  }
}
