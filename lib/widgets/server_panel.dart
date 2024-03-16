import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:scouting_app/providers/server.dart';
import 'package:scouting_app/views/manager/client.dart';
import 'package:scouting_app/widgets/centered_card.dart';

class ServerPanel extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<ServerProvider>(builder: (context, server, child) {
      return CenteredCard(
          child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
            if (server.running)
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
            Text('Port: ${server.port}'),
            for (var client in server.clients)
              if (client != null)
                ElevatedButton(
                    child: Text(
                        '${client.username}@${client.socket.remoteAddress.address} (${client.id})'),
                    onPressed: () => Navigator.push(context,
                        MaterialPageRoute(builder: (_) => ClientView(client)))),
          ]));
    });
  }
}
