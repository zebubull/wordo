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

class _TeamPageState extends State<TeamPage> {
  /// The team bound to this page. Do not directly edit this, instead use [_update].
  Team? _baseTeam;

  /// Set the state with the provided callback and mark the team as dirty. This
  /// function should only be used when updating `_baseTeam`.
  void _update(Function() onSetState) {
    setState(onSetState);
    Provider.of<TeamsModel>(context, listen: false).markDirty();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    _baseTeam ??= Provider.of<TeamsModel>(context).teams.firstWhere((t) => t.id == widget.id);
    Team team = _baseTeam!;

    return CustomScrollView(
      slivers: [ 
        _makeTitleBar(theme, team),
        _makeBody(theme, team),
      ],
    );
  }

  /// Create the title bar to display the team name and number.
  SliverSafeArea _makeTitleBar(ThemeData theme, Team team) {
    return SliverSafeArea(
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
    );
  }

  /// Create the body widget containing the rating and evaluation tiles.
  SliverPadding _makeBody(ThemeData theme, Team team) {
    final buildFunctions = <Container Function(ThemeData, Team)>[
      _makePitsTile,
      _makeAutonTile,
      _makeTeleTile,
      _makeEndgameTile,
      _makeRatingsTile,
    ];
    return SliverPadding(
      padding: EdgeInsets.all(20.0),
        sliver: SliverList(
          delegate: SliverChildBuilderDelegate(
            (context, i) { 
              if (i >= buildFunctions.length) return null;
              return buildFunctions[i].call(theme, team);
            },
          ),
        ),
    );
  }

  Container _makePitsTile(ThemeData theme, Team team) {
    return Container(
      decoration: BoxDecoration(
        color: theme.colorScheme.background,
        borderRadius: BorderRadius.only(topLeft: Radius.circular(16.0), topRight: Radius.circular(16.0))
      ),
      child: ExpansionTile(
        title: Text('Pre-match'),
        shape: const Border(),
        children: [
          _TeamWeightSlider(
            title: Text('Weight (${team.weight} lbs)'),
            value: team.weight,
            onChanged: (v) => _update(() => team.weight = v),
          ),
          _TeamNumberView(
            title: const Text('Width (in)'),
            label: Text('${team.width}'),
            onPressed: (a) => _update(() => team.width = (team.width + a * 0.5).clamp(15.0, 40.0)),
          ),
          SizedBox(height: 20.0),
          _TeamNumberView(
            title: const Text('Length (in)'),
            label: Text('${team.length}'),
            onPressed: (a) => _update(() => team.length = (team.length + a * 0.5).clamp(15.0, 40.0)),
          ),
          SizedBox(height: 20.0),
          _TeamNumberView(
            title: const Text('Height (in)'),
            label: Text('${team.height}'),
            onPressed: (a) => _update(() => team.height = (team.height + a * 0.5).clamp(15.0, 40.0)),
          ),
          SizedBox(height: 20.0),
          DropdownMenu(
            hintText: 'Drivetrain',
            initialSelection: Drivetrain.trank,
            onSelected: (d) => _update(() { team.drivetrain = d ?? Drivetrain.trank; }),
            dropdownMenuEntries: [
              for (var drive in Drivetrain.values)
                DropdownMenuEntry(
                  label: drive.toFriendly(),
                  value: drive,
                ),
            ],
          ),
          SizedBox(height: 10.0),
          _TeamBoolView(
            title: const Text('Below Stage'),
            value: team.underStage,
            onChanged: (b) => _update(() { if (b != null) team.underStage = b; }),
          ),
          SizedBox(height: 10.0),
        ],
      ),
    );
  }

  /// Create the tile for autonomous data.
  Container _makeAutonTile(ThemeData theme, Team team) {
    return Container(
      decoration: BoxDecoration(
        color: theme.colorScheme.background,
        borderRadius: BorderRadius.only()
      ),
      child: ExpansionTile(
        title: Text('Autonomous'),
        shape: const Border(),
        children: [
          _TeamNumberView(
            title: const Text('Amp'),
            label: Text('${team.ampAuto}'),
            onPressed: (a) => _update(() => team.ampAuto = (team.ampAuto + a).clamp(0, 20)),
          ),
          SizedBox(height: 10.0),
          _TeamNumberView(
            title: const Text('Speaker'),
            label: Text('${team.speakerAuto}'),
            onPressed: (a) => _update(() => team.speakerAuto = (team.speakerAuto + a).clamp(0, 20)),
          ),
          SizedBox(height: 10.0),
          _TeamBoolView(
            title: const Text('Leave'),
            value: team.leaves,
            onChanged: (b) => _update(() => team.leaves = b ?? false),
          ),
          SizedBox(height: 10.0),
        ],
      ),
    );
  }

  /// Create the tile for teleoperated data.
  Container _makeTeleTile(ThemeData theme, Team team) {
    return Container(
      color: theme.colorScheme.background,
      child: ExpansionTile(
        title: Text('Teleoperated'),
        shape: const Border(),
        children: [
          _TeamNumberView(
            title: const Text('Amp'),
            label: Text('${team.ampTele}'),
            onPressed: (a) => _update(() => team.ampTele = (team.ampTele + a).clamp(0, 20)),
          ),
          SizedBox(height: 10.0),
          _TeamNumberView(
            title: const Text('Speaker'),
            label: Text('${team.speakerTele}'),
            onPressed: (a) => _update(() => team.speakerTele = (team.speakerTele + a).clamp(0, 20)),
          ),
          SizedBox(height: 10.0),
        ]
      ),
    );
  }

  /// Create the tile for endgame data.
  Container _makeEndgameTile(ThemeData theme, Team team) {
    return Container(
      color: theme.colorScheme.background,
      child: ExpansionTile(
        title: Text('Endgame'),
        shape: const Border(),
        children: [
          _TeamBoolView(
            title: const Text('Hang'),
            value: team.hangs,
            onChanged: (b) => _update(() => team.hangs = b ?? false),
          ),
          SizedBox(height: 10.0),
          _TeamBoolView(
            title: const Text('Trap'),
            value: team.trap,
            onChanged: (b) => _update(() => team.trap = b ?? false),
          ),
          SizedBox(height: 10.0),
          _TeamBoolView(
            title: const Text('Harmony'),
            value: team.harmony,
            onChanged: (b) => _update(() => team.harmony = b ?? false),
          ),
          SizedBox(height: 10.0),
        ]
      ),
    );
  }

  /// Create the tile for qualitative ratings.
  Container _makeRatingsTile(ThemeData theme, Team team) {
    return Container(
      decoration: BoxDecoration(
        color: theme.colorScheme.background,
        borderRadius: BorderRadius.only(bottomLeft: Radius.circular(16.0), bottomRight: Radius.circular(16.0))
      ),
      child: ExpansionTile(
        title: Text('Ratings'),
        shape: const Border(),
        children: [
          _TeamRatingSlider(
            onChanged: (v) => _update(() => team.offenseScore = v),
            title: Text("Offense (${team.offenseScore})"),
            value: team.offenseScore,
          ),
          _TeamRatingSlider(
            onChanged: (v) => _update(() => team.defenseScore = v),
            title: Text("Defense (${team.defenseScore})"),
            value: team.defenseScore,
          ),
          _TeamRatingSlider(
            onChanged: (v) => _update(() => team.overallScore = v),
            title: Text("Overall (${team.overallScore})"),
            value: team.overallScore,
          ),
          _TeamSizeSlider(
            onChanged: (v) => _update(() => team.cycleTime = v),
            title: Text('Cycle Time (${team.cycleTime}s)'),
            value: team.cycleTime,
          ),
          SizedBox(height: 20.0),
          const Text('Pickup Zones'),
          DropdownMenu(
            hintText: 'Pickup Zones',
            initialSelection: Pickup.defenseBot,
            onSelected: (p) => _update(() { team.pickup = p ?? Pickup.defenseBot; }),
            dropdownMenuEntries: [
              for (var zone in Pickup.values)
                DropdownMenuEntry(
                  label: zone.toFriendly(),
                  value: zone,
                ),
            ],
          ),
          SizedBox(height: 20.0),
        ],
      ),
    );
  }
}

/// A number display with add and subtract buttons.
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

/// A slider with a label and callback.
class _TeamRatingSlider extends StatelessWidget {
  final Function(double) onChanged;
  final Widget title;
  final double value;

  _TeamRatingSlider({required this.onChanged, required this.title, required this.value});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(20.0),
      child: Wrap(
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

/// A slider with a label and callback.
class _TeamWeightSlider extends StatelessWidget {
  final Function(double) onChanged;
  final Widget title;
  final double value;

  _TeamWeightSlider({required this.onChanged, required this.title, required this.value});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(20.0),
      child: Wrap(
        direction: Axis.horizontal,
        children: [
          title,
          Slider(
            value: value,
            min: 20.0,
            max: 130.0,
            divisions: 220,
            onChanged: onChanged,
          ),
        ],
      ),
    );
  }
}

class _TeamSizeSlider extends StatelessWidget {
  final Function(double) onChanged;
  final Widget title;
  final double value;

  _TeamSizeSlider({required this.onChanged, required this.title, required this.value});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(20.0),
      child: Wrap(
        direction: Axis.horizontal,
        children: [
          title,
          Slider(
            value: value,
            min: 1.0,
            max: 40.0,
            divisions: 156,
            onChanged: onChanged,
          ),
        ],
      ),
    );
  }
}

/// A center-aligned checkbox with a label and callback.
class _TeamBoolView extends StatelessWidget {
  final Function(bool?) onChanged;
  final Widget title;
  final bool value;

  _TeamBoolView({required this.onChanged, required this.title, required this.value});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        title,
        Checkbox(value: value, onChanged: onChanged)
      ],
    );
  }
}

