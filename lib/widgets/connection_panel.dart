import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:scouting_app/viewmodels/client.dart';

class ConnectionPanel extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Consumer<ClientViewModel>(builder: (context, network, child) {
      return Container(
        width: 450,
        decoration: BoxDecoration(
          color: theme.colorScheme.primaryContainer,
          borderRadius: BorderRadius.all(Radius.circular(8.0)),
        ),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(children: [
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
            Text('Id: ${network.clientId}'),
          ]),
        ),
      );
    });
  }
}
