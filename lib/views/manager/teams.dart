import 'package:flutter/material.dart';
import 'package:scouting_app/models/server/team_store.dart';
import 'package:scouting_app/models/team.dart';
import 'package:scouting_app/widgets/centered_card.dart';
import 'package:watch_it/watch_it.dart';

class TeamsView extends WatchingStatefulWidget {
  @override
  State<StatefulWidget> createState() => _TeamsViewState();
}

class _TeamsViewState extends State<TeamsView> {
  var _nameController = TextEditingController();
  var _idController = TextEditingController();

  @override
  void dispose() {
    _nameController.dispose();
    _idController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final teams = watchPropertyValue((TeamStore t) => t.teams);
    final loading = watchPropertyValue((TeamStore t) => t.loading);

    if (loading) return CircularProgressIndicator();

    return CenteredCard(
      width: 600,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: ListView(
          shrinkWrap: true,
          children: [
            if (teams.isEmpty) const Text('No teams registered'),
            for (var team in teams)
              Padding(
                  padding: const EdgeInsets.all(4.0),
                  child: ListTile(
                      title: Text('(${team.number}) ${team.name}'),
                      trailing: IconButton(
                          icon: const Icon(Icons.highlight_remove_outlined),
                          onPressed: () =>
                              di.get<TeamStore>().removeTeam(team)))),
            Divider(color: theme.colorScheme.onPrimaryContainer),
            ExpansionTile(
                title: const Text('Add team'),
                shape: const Border(),
                key: PageStorageKey('Add team'),
                children: [
                  TextField(
                    key: PageStorageKey('teams_nametext'),
                    controller: _nameController,
                    decoration: InputDecoration(
                        hintText: 'Name', border: OutlineInputBorder()),
                  ),
                  SizedBox(height: 8.0),
                  TextField(
                    key: PageStorageKey('teams_idtext'),
                    controller: _idController,
                    decoration: InputDecoration(
                        hintText: 'ID', border: OutlineInputBorder()),
                  ),
                  SizedBox(height: 8.0),
                  IconButton(
                      icon: const Icon(Icons.add_box_outlined),
                      onPressed: () {
                        var id = int.tryParse(_idController.text);
                        if (id == null) return;

                        di.get<TeamStore>().addTeam(
                            Team(number: id, name: _nameController.text));
                        _idController.clear();
                        _nameController.clear();
                      }),
                ])
          ],
        ),
      ),
    );
  }
}
