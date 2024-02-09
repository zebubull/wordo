import 'package:biden_blast/team.dart';
import 'package:biden_blast/teams_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class TeamPage extends StatefulWidget {
  final int id;
  TeamPage({super.key, required this.id});

  @override
  State<TeamPage> createState() => _TeamPageState();
}

class _TeamPanelItem extends StatelessWidget {
  final List<Widget> children;

  const _TeamPanelItem({required this.children});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: 20.0),
      child: Wrap(
        direction: Axis.horizontal,
        spacing: 10.0,
        runSpacing: 20.0,
        children: children
      ),
    );
  }
}

class _TeamNumberView extends StatelessWidget {
  final Function(int) onPressed;
  final Widget title;
  final Widget label;

  _TeamNumberView({required this.onPressed, required this.title, required this.label});
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        IconButton(
          icon: Icon(Icons.remove),
          onPressed: () => onPressed(-1),
        ),
        Column(
          children: [
            title,
            label,
          ],
        ),
        IconButton(
          icon: Icon(Icons.add),
          onPressed: () => onPressed(1),
        ),
      ],
    );
  }
}

class _TeamNumberSlider extends StatelessWidget {
  final Function(double) onChanged;
  final Widget title;
  final double value;

  _TeamNumberSlider({required this.onChanged, required this.title, required this.value});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Wrap(
        direction: Axis.horizontal,
        children: [
          title,
          Slider(
            value: value,
            min: 0.0,
            max: 10.0,
            divisions: 10,
            onChanged: onChanged,
          ),
        ],
      ),
    );
  }
}

class _TeamPageState extends State<TeamPage> {
  Team? _baseTeam;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    _baseTeam ??= Provider.of<TeamsModel>(context).teams.firstWhere((t) => t.id == widget.id);
    Team team = _baseTeam!;

    return CustomScrollView(
      slivers: [ 
        SliverSafeArea(
          sliver: SliverAppBar(
            pinned: true,
            floating: true,
            backgroundColor: theme.colorScheme.primary,
            flexibleSpace: FlexibleSpaceBar(
              title: Wrap(
                direction: Axis.horizontal,
                children: [
                  Text('(${team.id}) '), Text(team.name),
                  //style: titleStyle
                ],
              ),
            ),
          ),
        ),
        SliverPadding(
          padding: EdgeInsets.all(20.0),
          sliver: SliverFillRemaining(
              child: ListView(
                children: [
                  Container(
                    decoration: BoxDecoration(
                      color: theme.colorScheme.background,
                      borderRadius: BorderRadius.only(topLeft: Radius.circular(16.0), topRight: Radius.circular(16.0))
                    ),
                    child: ExpansionTile(
                      title: Text('Autonomous'),
                      shape: const Border(),
                      children: [
                        _TeamNumberView(
                          title: const Text('Amp'),
                          label: Text('${team.ampAuto}'),
                          onPressed: (a) => setState(() => team.ampAuto = (team.ampAuto + a).clamp(0, 20)),
                        ),
                        SizedBox(height: 10.0),
                        _TeamNumberView(
                          title: const Text('Speaker'),
                          label: Text('${team.speakerAuto}'),
                          onPressed: (a) => setState(() => team.speakerAuto = (team.speakerAuto + a).clamp(0, 20)),
                        ),
                        SizedBox(height: 10.0),
                      ],
                    ),
                  ),
                  Container(
                    color: theme.colorScheme.background,
                    child: ExpansionTile(
                      title: Text('Teleoperated'),
                      shape: const Border(),
                      children: [
                        _TeamNumberView(
                          title: const Text('Amp'),
                          label: Text('${team.ampTele}'),
                          onPressed: (a) => setState(() => team.ampTele = (team.ampTele + a).clamp(0, 20)),
                        ),
                        SizedBox(height: 10.0),
                        _TeamNumberView(
                          title: const Text('Speaker'),
                          label: Text('${team.speakerTele}'),
                          onPressed: (a) => setState(() => team.speakerTele = (team.speakerTele + a).clamp(0, 20)),
                        ),
                        SizedBox(height: 10.0),
                      ]
                    ),
                  ),
                  Container(
                    decoration: BoxDecoration(
                      color: theme.colorScheme.background,
                      borderRadius: BorderRadius.only(bottomLeft: Radius.circular(16.0), bottomRight: Radius.circular(16.0))
                    ),
                    child: ExpansionTile(
                      title: Text('Ratings'),
                      shape: const Border(),
                      children: [
                        _TeamNumberSlider(
                          onChanged: (v) => setState(() => team.offenseScore = v),
                          title: Text("Offense (${team.offenseScore})"),
                          value: team.offenseScore,
                        ),
                        _TeamNumberSlider(
                          onChanged: (v) => setState(() => team.defenseScore = v),
                          title: Text("Defense (${team.defenseScore})"),
                          value: team.defenseScore,
                        ),
                        _TeamNumberSlider(
                          onChanged: (v) => setState(() => team.overallScore = v),
                          title: Text("Overall (${team.overallScore})"),
                          value: team.overallScore,
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 20.0),
                  ElevatedButton.icon(
                    onPressed: () => ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: const Text('Saved'))),
                    icon: Icon(Icons.save),
                    label: const Text('Save'),
                    ),
                ],
              ),
          ),
        ),
      ],
    );
  }
}
