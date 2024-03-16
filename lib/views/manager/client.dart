import 'package:flutter/material.dart';
import 'package:scouting_app/models/assignment.dart';
import 'package:scouting_app/models/server/client.dart';
import 'package:scouting_app/models/team.dart';
import 'package:scouting_app/widgets/centered_card.dart';

class ClientView extends StatefulWidget {
  final Client client;

  ClientView(this.client);

  @override
  State<ClientView> createState() => _ClientViewState();
}

class _ClientViewState extends State<ClientView> {
  late Client client;
  var _numberController = TextEditingController();
  var _teamNameController = TextEditingController();
  var _teamNumberController = TextEditingController();

  @override
  void initState() {
    super.initState();
    client = widget.client;
  }

  void _deleteMatch(Assignment match) {
    setState(() => client.unassign(match));
  }

  void _addMatch() {
    var number = int.tryParse(_numberController.text);
    var teamNumber = int.tryParse(_teamNumberController.text);
    if (number == null || teamNumber == null) return;

    setState(() => client.assign(Assignment(
        matchNumber: number,
        team: Team(number: teamNumber, name: _teamNameController.text))));

    _numberController.clear();
    _teamNumberController.clear();
    _teamNameController.clear();
  }

  @override
  void dispose() {
    _numberController.dispose();
    _teamNameController.dispose();
    _teamNumberController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(
          title: Text(
              '${client.username}@${client.socket.remoteAddress.address}')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: CenteredCard(
            width: 600,
            child: ListView(shrinkWrap: true, children: [
              for (var match in client.assignments)
                ListTile(
                    title: Text('${match.matchNumber}'),
                    trailing: IconButton(
                        icon: const Icon(Icons.delete_outline_rounded),
                        onPressed: () => _deleteMatch(match))),
              if (widget.client.assignments.isNotEmpty)
                Divider(color: theme.colorScheme.onPrimaryContainer),
              TextField(
                controller: _numberController,
                decoration: InputDecoration(
                    hintText: 'Match number', border: OutlineInputBorder()),
              ),
              SizedBox(height: 8.0),
              TextField(
                controller: _teamNameController,
                decoration: InputDecoration(
                    hintText: 'Team name', border: OutlineInputBorder()),
              ),
              SizedBox(height: 8.0),
              TextField(
                controller: _teamNumberController,
                decoration: InputDecoration(
                    hintText: 'Team number', border: OutlineInputBorder()),
              ),
              SizedBox(height: 8.0),
              IconButton(
                  icon: const Icon(Icons.add_box_outlined),
                  onPressed: _addMatch),
            ])),
      ),
    );
  }
}
