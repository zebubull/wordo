import 'package:flutter/material.dart';
import 'package:scouting_app/models/assignment.dart';
import 'package:scouting_app/models/server/team_store.dart';
import 'package:scouting_app/models/team.dart';
import 'package:watch_it/watch_it.dart';

class MatchInputCard extends WatchingStatefulWidget {
  final void Function(Assignment) onPressed;
  MatchInputCard({required this.onPressed});

  @override
  State<MatchInputCard> createState() => _MatchInputCardState();
}

class _MatchInputCardState extends State<MatchInputCard> {
  var _numberController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  Team? _selectedTeam;

  @override
  void dispose() {
    _numberController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final teams = watchPropertyValue((TeamStore t) => t.teams);

    return Form(
      key: _formKey,
      child: ExpansionTile(
          maintainState: true,
          title: const Text('Assign match'),
          shape: const Border(),
          key: PageStorageKey('Assign match'),
          children: [
            TextFormField(
              controller: _numberController,
              key: PageStorageKey('user_numtext'),
              decoration: InputDecoration(
                  hintText: 'Match number', border: OutlineInputBorder()),
              validator: (value) => value != null && int.tryParse(value) == null
                  ? 'Please enter a valid number'
                  : null,
            ),
            SizedBox(height: 8.0),
            DropdownMenu<Team>(
              requestFocusOnTap: false,
              label: const Text('Team'),
              key: PageStorageKey('user_teambox'),
              initialSelection: teams.firstOrNull,
              onSelected: (team) => setState(() => _selectedTeam = team),
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
                  if (!(_formKey.currentState?.validate() ?? false) ||
                      _selectedTeam == null) {
                    return;
                  }

                  widget.onPressed(Assignment(
                      matchNumber: int.parse(_numberController.text),
                      team: _selectedTeam!));
                  _numberController.clear();
                }),
          ]),
    );
  }
}
