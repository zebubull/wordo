import 'dart:collection';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:scouting_app/main.dart';
import 'package:scouting_app/models/team.dart';
import 'package:scouting_app/util/byte_helper.dart';

class TeamStore extends ChangeNotifier {
  List<Team> _teams;

  UnmodifiableListView<Team> get teams => UnmodifiableListView(_teams);

  TeamStore() : _teams = [] {
    _loadTeams();
  }

  void addTeam(Team team) {
    _teams.add(team);
    _saveTeams();
    notifyListeners();
  }

  void removeTeam(Team team) {
    _teams.remove(team);
    _saveTeams();
    notifyListeners();
  }

  void _loadTeams() async {
    if (dataPath == null) return;
    final file = File('${dataPath!.path}/teams.dat');
    if (!await file.exists()) return;
    final data = ByteHelper.read(await file.readAsBytes());
    final numTeams = data.readU32();
    for (int i = 0; i < numTeams; ++i) {
      _teams.add(data.readTeam());
    }
    notifyListeners();
  }

  void _saveTeams() async {
    if (dataPath == null) return;
    var data = ByteHelper.write();
    data.addU32(_teams.length);
    for (var team in _teams) {
      data.addTeam(team);
    }
    await File('${dataPath!.path}/teams.dat').writeAsBytes(data.bytes);
  }

  @override
  void notifyListeners() {
    super.notifyListeners();
  }
}
