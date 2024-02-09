import 'package:biden_blast/teams_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class TeamPage extends StatefulWidget {
  final int id;
  TeamPage({super.key, required this.id});

  @override
  State<TeamPage> createState() => _TeamPageState();
}

class _TeamPageState extends State<TeamPage> {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final titleStyle = theme.textTheme.titleLarge!.copyWith(
      color: theme.colorScheme.onPrimary,
    );

    final team = Provider.of<TeamsModel>(context)
      .teams
      .firstWhere((t) => t.id == widget.id);

    return Column(
      children: [ 
        Container(
          width: double.infinity,
          color: theme.colorScheme.primary,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Padding(
                padding: EdgeInsets.all(16),
                child: Text(
                  '${team.name} (${team.id})',
                  style: titleStyle
                ),
              ),
            ],
          ),
        ),
        Padding(
          padding: EdgeInsets.all(20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
            ],
          ),
        ),
      ],
    );
  }
}
