import 'package:scouting_app/teams_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class TeamSelectPage extends StatelessWidget {
  final Function(int id) onTeamSelect;
  TeamSelectPage({super.key, required this.onTeamSelect});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
      padding: EdgeInsets.all(20),
      child: Consumer<TeamsModel> (
      builder: (context, teams, _) => ListView(
        children: [
        for (var team in teams.teams)
          ListTile(
            title: ElevatedButton(
              child: Text('${team.name} (${team.id})'),
              onPressed: () => onTeamSelect(team.id),
            ),
            trailing: IconButton(onPressed: () => Provider.of<TeamsModel>(context, listen: false).deleteTeam(team.id), icon: Icon(Icons.delete)),
          ),
        ],
      ))),
    );
  }
}
