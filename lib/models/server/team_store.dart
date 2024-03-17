import 'dart:collection';

import 'package:flutter/material.dart';
import 'package:scouting_app/models/team.dart';

class TeamStore extends ChangeNotifier {
  List<Team> _teams;

  UnmodifiableListView<Team> get teams => UnmodifiableListView(_teams);

  TeamStore() : _teams = [];

  void addTeam(Team team) {
    _teams.add(team);
    notifyListeners();
  }

  void removeTeam(Team team) {
    _teams.remove(team);
    notifyListeners();
  }
}
