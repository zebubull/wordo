import 'package:flutter/material.dart';
import 'package:scouting_app/models/assignment.dart';
import 'package:scouting_app/widgets/centered_card.dart';

class MatchView extends StatelessWidget {
  final Assignment match;

  MatchView(this.match);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
            title: Text('Match ${match.matchNumber}: ${match.team.number}')),
        body: CenteredCard(
          width: 450,
          child: Text('${match.team.name} (${match.team.number})'),
        ));
  }
}
