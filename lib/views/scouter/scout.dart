import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:scouting_app/providers/client.dart';
import 'package:scouting_app/views/scouter/team.dart';
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
              if (client.assignedTeams.isEmpty) const Text('No teams assigned'),
              for (var team in client.assignedTeams)
                ElevatedButton(
                    child: Text('${team.name} (${team.number})'),
                    onPressed: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => TeamView(team: team)))),
            ]));
      },
    );
  }
}
