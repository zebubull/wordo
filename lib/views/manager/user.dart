import 'package:flutter/material.dart';
import 'package:scouting_app/models/server/server.dart';
import 'package:scouting_app/models/server/team_store.dart';
import 'package:scouting_app/models/team.dart';
import 'package:scouting_app/widgets/centered_card.dart';
import 'package:watch_it/watch_it.dart';

class UserView extends WatchingStatefulWidget {
  final User user;
  UserView(this.user);

  @override
  State<UserView> createState() => _UserViewState();
}

class _UserViewState extends State<UserView> {
  var _numberController = TextEditingController();
  Team? selectedTeam;

  @override
  void dispose() {
    _numberController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final user = watch(widget.user);
    final teams = watchPropertyValue((TeamStore t) => t.teams);

    return Scaffold(
      appBar: AppBar(title: Text(user.username)),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: CenteredCard(
            width: 600,
            child: ListView(shrinkWrap: true, children: [
              for (var match in user.matches)
                ListTile(
                    title: Text('${match.matchNumber}'),
                    trailing: IconButton(
                        icon: const Icon(Icons.delete_outline_rounded),
                        onPressed: () => user.unassign(match))),
              if (user.matches.isNotEmpty)
                Divider(color: theme.colorScheme.onPrimaryContainer),
              ExpansionTile(
                  maintainState: true,
                  title: const Text('Assign match'),
                  shape: const Border(),
                  key: PageStorageKey('Assign match'),
                  children: [
                    TextField(
                      controller: _numberController,
                      key: PageStorageKey('user_numtext'),
                      decoration: InputDecoration(
                          hintText: 'Match number',
                          border: OutlineInputBorder()),
                    ),
                    SizedBox(height: 8.0),
                    DropdownMenu<Team>(
                      requestFocusOnTap: false,
                      label: const Text('Team'),
                      key: PageStorageKey('user_teambox'),
                      onSelected: (team) => setState(() => selectedTeam = team),
                      dropdownMenuEntries: [
                        for (var team in teams)
                          DropdownMenuEntry<Team>(
                            label: '(${team.number}) ${team.name}',
                            value: team,
                          )
                      ],
                    ),
                    SizedBox(height: 8.0),
                    IconButton(
                        icon: const Icon(Icons.add_box_outlined),
                        onPressed: () {
                          var match = int.tryParse(_numberController.text);
                          if (match == null || selectedTeam == null) return;

                          user.assign(selectedTeam!, match);
                          _numberController.clear();
                          di.get<Server>().checkAssignments(user);
                        }),
                  ])
            ])),
      ),
    );
  }
}
