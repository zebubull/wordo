import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:scouting_app/providers/client.dart';
import 'package:scouting_app/views/scouter/match.dart';
import 'package:scouting_app/widgets/centered_card.dart';

class ScoutView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<ClientProvider>(
      builder: (context, client, child) {
        return CenteredCard(
            child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
              if (client.assignedMatches.isEmpty)
                const Text('No matches assigned'),
              for (var match in client.assignedMatches)
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ElevatedButton(
                      child: Text(
                          '${match.team.name} (${match.team.number}): ${match.matchNumber}'),
                      onPressed: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => MatchView(match)))),
                ),
            ]));
      },
    );
  }
}
