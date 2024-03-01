import 'dart:async';
import 'dart:collection';
import 'dart:convert';
import 'dart:io';

import 'package:biden_blast/team.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';

List<Team> _parseTeams(String data) {
  final List json = jsonDecode(data);

  return json.map((j) => Team.fromJson(j)).toList();
}

Future<String?> getDownloadPath() async {
  Directory? dir;
  try {
    if (Platform.isAndroid) {
      dir = Directory('/storage/emulated/0/Download');
      if (!await dir.exists()) dir = await getExternalStorageDirectory();
    } else {
      dir = (await getDownloadsDirectory())!;
    }
  } catch (err, _) {
    print('Cannot get download folder path');
  }
  return dir?.path;
}

class TeamsModel extends ChangeNotifier {
  List<Team> _teams = [];
  bool _saved = true;
  Timer? _saveTimer;

  UnmodifiableListView<Team> get teams => UnmodifiableListView(_teams);
  get saved => _saved;

  bool add(Team team, BuildContext context) {
    if (_teams.where((t) => t.id == team.id).isNotEmpty) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Team with id ${team.id} already exists!'))
        );
      }
      return false;
    }
    _teams.add(team);
    markDirty();
    return true;
  }

  void updateTeam(Team team) {
    for (int i = 0; i < _teams.length; ++i) {
      if (_teams[i].id == team.id) {
        _teams[i] = team;
      }
    }
    markDirty();
  }

  (int, int) addTeams(List<Team> teams) {
    int newTeams = 0;
    int updatedTeams = 0;
    for (var team in teams) {
      if (_teams.where((t) => t.id == team.id).isEmpty) {
        _teams.add(team);
        newTeams++;
      } else {
        var curTeam = _teams.where((t) => t.id == team.id).first;
        var wasUpdated = false;
        for (var match in team.matches) {
          if (curTeam.matches.where((m) => m.number == match.number).isEmpty) {
            curTeam.matches.add(match);
            wasUpdated = true;
          }
        }
        updatedTeams += wasUpdated ? 1 : 0;
      }
    }

    markDirty();
    return (newTeams, updatedTeams);
  }

  void deleteTeam(int id) {
    _teams.removeAt(_teams.indexWhere((t) => t.id == id));
    markDirty();
  }

  void markDirty() {
    _saved = false;
    notifyListeners();
    
    _saveTimer?.cancel();
    _saveTimer = Timer(Duration(seconds: 15), () => save(null));
  }

  Future<void> save(BuildContext? context) async {
    if (_saved) return;
    final localPath = (await getApplicationDocumentsDirectory()).path;
    final dataFile = await File('$localPath/.scouting/saved.json').create(recursive: true);
    await dataFile.writeAsString(jsonEncode(teams.map((t) => t.toJson()).toList()));

    if (context != null && context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Saved $localPath/.scouting/saved.json'))
      );
    }

    _saved = true;
    notifyListeners();
  }

  Future<void> export(BuildContext? context) async {
    final downloadPath = (await getDownloadPath());
    if (downloadPath == null) {
      if (context != null && context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('ERROR: Could not find directory to export to.'))
        );
      }
      return;
    }

    var gotFile = true;
    final dataFile = await File('$downloadPath/scouting.csv').create(recursive: true).onError((error, stackTrace) {
      gotFile = false;
      return File('');
    });

    if (!gotFile) {
      if (context != null && context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('ERROR: Could not open export file.'))
        );
      }
      return;
    }

    var sink = dataFile.openWrite();

    sink.writeln('ID,NAME,WGHT,UNDER,DRIVE,SIZE,AMP_A,SPK_A,LEAVE,AMP_T,SPK_T,HANG,TRAP,HMNY,OFF,DEF,OVR,CYCLE');
    

    for (var team in _teams) {
      var avg = MatchAverage.fromMatches(team.matches);
      sink.writeln('${team.id},"${team.name}",${team.weight},${team.underStage},${team.drivetrain.toFriendly().toUpperCase()},${team.width}x${team.height}x${team.length},${avg.ampAuto},${avg.speakerAuto},${avg.leaves},${avg.ampTele},${avg.speakerTele},${avg.hangs},${avg.trap},${avg.harmony},${avg.offenseScore},${avg.defenseScore},${avg.overallScore},${avg.cycleTime}');
    }

    await sink.flush();
    await sink.close();

    if (context != null && context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('exported $downloadPath/scouting.csv'))
      );
    }
  }

  Future<void> load() async {
    notifyListeners();
    final localPath = (await getApplicationDocumentsDirectory()).path;
    final dataFile = File('$localPath/.scouting/saved.json');

    if (!await dataFile.exists()) {
      return;
    }

    final data = await dataFile.readAsString();
    final teams = await compute(_parseTeams, data);
    _teams.addAll(teams);
    notifyListeners();
  }
}
