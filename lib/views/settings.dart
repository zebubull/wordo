import 'package:flutter/material.dart';
import 'package:scouting_app/widgets/centered_card.dart';

class SettingsView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return CenteredCard(
      child: SizedBox(
        width: 600,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: ListView(
            shrinkWrap: true,
            children: [
              Row(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('Reset', style: Theme.of(context).textTheme.titleLarge,),
                  SizedBox(width: 16),
                  IconButton(onPressed: () => print('todo'), icon: const Icon(Icons.restart_alt))
                ]
              )
            ]
          ),
        )
      )
    );
  }
}
