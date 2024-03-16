import 'package:flutter/material.dart';
import 'package:scouting_app/models/team.dart';
import 'package:scouting_app/widgets/centered_card.dart';

class TeamView extends StatelessWidget {
  final Team team;

  TeamView({required this.team});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: Text('${team.name} (${team.number})')),
        body: CenteredCard(
          width: 450,
          child: Text('${team.name} (${team.number})'),
        ));
  }
}
