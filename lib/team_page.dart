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

class _TeamPageState extends State<TeamPage> with SingleTickerProviderStateMixin {
  /// The team bound to this page. Do not directly edit this, instead use [_update].
  Team? _baseTeam;

  late TabController _tabController;
  static const List<Tab> _tabs = [
    Tab( text: "PITS"),
    Tab( text: "LATEST MATCH"),
    Tab( text: "OLD MATCHES"),
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(vsync: this, length: _tabs.length);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

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

    return Column(
      children: [ 
        _makeTitleBar(theme, team),
        Expanded(
          child: TabBarView(
            controller: _tabController,
            children: [
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: _makePitsTile(theme, team),
              ),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: _makeLatestMatch(theme, team),
              ),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: _makeOldMatches(theme, team),
              ),
            ],
          ),
        ),
      ],
    );
  }

  int _matchNumber = 0;

  Widget _makeLatestMatch(ThemeData theme, Team team) {
    final match = team.matches.lastOrNull;
    final titleStyle = theme.textTheme.titleLarge!;
  
    return ListView(
      children: [
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(
                width: 160,
                child: TextField(
                  decoration: InputDecoration(hintText: 'Match #', border: OutlineInputBorder()),
                  keyboardType: TextInputType.number,
                  onChanged: (v) => setState(() => _matchNumber = int.tryParse(v) ?? 1),
                ),
              ),
              SizedBox(width: 16.0),
              IconButton.filled(
                icon: Icon(Icons.add),
                onPressed: () => _update(() => team.matches.add(Match(number: _matchNumber))),
              ),
            ],
          ),
        ),
        if (match != null)
        Center(child: Text('Match ${match.number}', style: titleStyle)),
        if (match != null)
        SizedBox(height: 16.0),
        if (match != null)
        Container(
          decoration: BoxDecoration(
            color: theme.colorScheme.background,
            borderRadius: BorderRadius.all(Radius.circular(16.0)),
          ),
            child: Column(
              children: [
                _makeAutonTile(theme, match),
                _makeTeleTile(theme, match),
                _makeEndgameTile(theme, match),
                _makeRatingsTile(theme, match),
              ],
            ),
          ),
      ],
    );
  }

  ListView _makeOldMatches(ThemeData theme, Team team) {
    return ListView(
      children: [
        for (var (i, match) in team.matches.indexed)
          _makeMatch(theme, match, team.matches.length, i)
      ]
    );
  }

  /// Create the title bar to display the team name and number.
  SafeArea _makeTitleBar(ThemeData theme, Team team) {
    final selectedTheme = theme.textTheme.bodyMedium!.copyWith(
      color: theme.colorScheme.onPrimary,
      fontWeight: FontWeight.bold,
    );
    final unselectedTheme = theme.textTheme.bodyMedium!.copyWith(
      color: theme.colorScheme.onPrimary,
    );
    final titleTheme = theme.textTheme.titleLarge!.copyWith(
      color: theme.colorScheme.onPrimary,
    );
    return SafeArea(
      child: SizedBox(
        height: 100,
        child: AppBar(
          backgroundColor: theme.colorScheme.primary,
          title: Text('(${team.id}) ${team.name}', style: titleTheme),
          bottom: TabBar(tabs: _tabs, controller: _tabController, labelStyle: selectedTheme, unselectedLabelStyle: unselectedTheme,),
        ),
      ),
    );
  }

  Container _makePitsTile(ThemeData theme, Team team) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(16.0)),
        color: theme.colorScheme.background,
      ),
      child: ListView(
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
          Align(
            alignment: Alignment.center,
            child: DropdownMenu(
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

  Padding _makeMatch(ThemeData theme, Match match, int totalMatches, int index) {

    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: Container(
        decoration: BoxDecoration(
          color: theme.colorScheme.background,
          borderRadius: BorderRadius.all(Radius.circular(16.0)),
        ),
        child: ExpansionTile(
          initiallyExpanded: totalMatches == 1,
          title: Text('Match ${match.number}'),
          shape: const Border(),
          children: [
            Divider(),
            _makeAutonTile(theme, match),
            _makeTeleTile(theme, match),
            _makeEndgameTile(theme, match),
            _makeRatingsTile(theme, match),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Align(
                alignment: Alignment.centerLeft,
                child: IconButton.filled(
                  icon: Icon(Icons.delete),
                  onPressed: () => _update(() => _baseTeam!.matches.removeAt(index)),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Create the tile for autonomous data.
  ExpansionTile _makeAutonTile(ThemeData theme, Match match) {
    return ExpansionTile(
      title: Text('Autonomous'),
      shape: const Border(),
      children: [
        _TeamNumberView(
          title: const Text('Amp'),
          label: Text('${match.ampAuto}'),
          onPressed: (a) => _update(() => match.ampAuto = (match.ampAuto + a).clamp(0, 20)),
        ),
        SizedBox(height: 10.0),
        _TeamNumberView(
          title: const Text('Speaker'),
          label: Text('${match.speakerAuto}'),
          onPressed: (a) => _update(() => match.speakerAuto = (match.speakerAuto + a).clamp(0, 20)),
        ),
        SizedBox(height: 10.0),
        _TeamBoolView(
          title: const Text('Leave'),
          value: match.leaves,
          onChanged: (b) => _update(() => match.leaves = b ?? false),
        ),
        SizedBox(height: 10.0),
      ],
    );
  }

  /// Create the tile for teleoperated data.
  ExpansionTile _makeTeleTile(ThemeData theme, Match match) {
    return ExpansionTile(
      title: Text('Teleoperated'),
      shape: const Border(),
      children: [
        _TeamNumberView(
          title: const Text('Amp'),
          label: Text('${match.ampTele}'),
          onPressed: (a) => _update(() => match.ampTele = (match.ampTele + a).clamp(0, 20)),
        ),
        SizedBox(height: 10.0),
        _TeamNumberView(
          title: const Text('Speaker'),
          label: Text('${match.speakerTele}'),
          onPressed: (a) => _update(() => match.speakerTele = (match.speakerTele + a).clamp(0, 20)),
        ),
        SizedBox(height: 10.0),
      ]
    );
  }

  /// Create the tile for endgame data.
  ExpansionTile _makeEndgameTile(ThemeData theme, Match match) {
    return ExpansionTile(
      title: Text('Endgame'),
      shape: const Border(),
      children: [
        _TeamBoolView(
          title: const Text('Hang'),
          value: match.hangs,
          onChanged: (b) => _update(() => match.hangs = b ?? false),
        ),
        SizedBox(height: 10.0),
        _TeamBoolView(
          title: const Text('Trap'),
          value: match.trap,
          onChanged: (b) => _update(() => match.trap = b ?? false),
        ),
        SizedBox(height: 10.0),
        _TeamBoolView(
          title: const Text('Harmony'),
          value: match.harmony,
          onChanged: (b) => _update(() => match.harmony = b ?? false),
        ),
        SizedBox(height: 10.0),
      ]
    );
  }

  /// Create the tile for qualitative ratings.
  ExpansionTile _makeRatingsTile(ThemeData theme, Match match) {
    return ExpansionTile(
      title: Text('Ratings'),
      shape: const Border(),
      children: [
        _TeamRatingSlider(
          onChanged: (v) => _update(() => match.offenseScore = v),
          title: Text("Offense (${match.offenseScore})"),
          value: match.offenseScore,
        ),
        _TeamRatingSlider(
          onChanged: (v) => _update(() => match.defenseScore = v),
          title: Text("Defense (${match.defenseScore})"),
          value: match.defenseScore,
        ),
        _TeamRatingSlider(
          onChanged: (v) => _update(() => match.overallScore = v),
          title: Text("Overall (${match.overallScore})"),
          value: match.overallScore,
        ),
        _TeamSizeSlider(
          onChanged: (v) => _update(() => match.cycleTime = v),
          title: Text('Cycle Time (${match.cycleTime}s)'),
          value: match.cycleTime,
        ),
        SizedBox(height: 20.0),
        const Text('Pickup Zones'),
        DropdownMenu(
          hintText: 'Pickup Zones',
          initialSelection: Pickup.defenseBot,
          onSelected: (p) => _update(() { match.pickup = p ?? Pickup.defenseBot; }),
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

