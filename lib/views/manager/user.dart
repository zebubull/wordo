import 'package:flutter/material.dart';
import 'package:scouting_app/models/server/server.dart';
import 'package:scouting_app/models/team.dart';
import 'package:scouting_app/widgets/centered_card.dart';
import 'package:scouting_app/widgets/match_input_card.dart';
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

    return Scaffold(
      appBar: AppBar(title: Text(user.username)),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: CenteredCard(
            width: 600,
            child: ListView(shrinkWrap: true, children: [
              for (var match in user.matches)
                ListTile(
                    title: Text('${match.matchNumber} | ${match.team.name}'),
                    trailing: IconButton(
                        icon: const Icon(Icons.delete_outline_rounded),
                        onPressed: () {
                          user.unassign(match);
                          di.get<Server>().checkAssignments(user);
                        })),
              if (user.matches.isNotEmpty)
                Divider(color: theme.colorScheme.onPrimaryContainer),
              MatchInputCard(onPressed: (match) {
                user.assign(match);
                di.get<Server>().checkAssignments(user);
              }),
            ])),
      ),
    );
  }
}
