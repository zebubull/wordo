import 'package:flutter/material.dart';
import 'package:scouting_app/models/server/server.dart';
import 'package:scouting_app/models/team.dart';
import 'package:scouting_app/widgets/centered_card.dart';
import 'package:watch_it/watch_it.dart';

class ClientView extends WatchingStatefulWidget {
  final int id;
  ClientView(this.id);

  @override
  State<ClientView> createState() => _ClientViewState();
}

class _ClientViewState extends State<ClientView> {
  var _numberController = TextEditingController();
  var _teamNameController = TextEditingController();
  var _teamNumberController = TextEditingController();

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
    final maybeClient = watchIt<Server>().clients[widget.id];
    if (maybeClient == null) {
      return Scaffold(appBar: AppBar(title: const Text('Client disconnected')));
    }
    final client = watch(maybeClient);

    return Scaffold(
      appBar: AppBar(
          title:
              Text('${client.username}@${client.sock.remoteAddress.address}')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: CenteredCard(
            width: 600,
            child: ListView(shrinkWrap: true, children: [
              for (var match in client.matches)
                ListTile(
                    title: Text('${match.matchNumber}'),
                    trailing: IconButton(
                        icon: const Icon(Icons.delete_outline_rounded),
                        onPressed: () => client.unassign(match))),
              if (client.matches.isNotEmpty)
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
                  onPressed: () {
                    var match = int.tryParse(_numberController.text);
                    var teamNum = int.tryParse(_teamNumberController.text);
                    if (match == null || teamNum == null) return;
                    var teamName = _teamNameController.text;

                    client.assign(Team(number: teamNum, name: teamName), match);
                    _numberController.clear();
                    _teamNumberController.clear();
                    _teamNameController.clear();
                  }),
            ])),
      ),
    );
  }
}
