import 'dart:collection';

import 'package:biden_blast/team.dart';
import 'package:flutter/material.dart';

class TeamsModel extends ChangeNotifier {
  final List<Team> _teams = [];

  UnmodifiableListView<Team> get teams => UnmodifiableListView(_teams);

  void add(Team team) {
    _teams.add(team);
    notifyListeners();
  }
}
