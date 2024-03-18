import 'dart:convert';
import 'dart:typed_data';

import 'package:scouting_app/models/assignment.dart';
import 'package:scouting_app/models/server/server.dart';
import 'package:scouting_app/models/team.dart';

class ByteHelper {
  BytesBuilder? _write;
  Uint8List? _read;
  int _readIndex = 0;

  List<int> get bytes => _write!.toBytes();

  ByteHelper.write() : _write = BytesBuilder();

  ByteHelper.read(Uint8List bytes) : _read = bytes;

  void addU32(int data) {
    _write!.add(Uint8List(4)..buffer.asUint32List()[0] = data);
  }

  void addString(String data) {
    addU32(data.length);
    _write!.add(utf8.encode(data));
  }

  void addTeam(Team team) {
    addU32(team.number);
    addString(team.name);
  }

  void addAssignment(Assignment assignment) {
    addTeam(assignment.team);
    addU32(assignment.matchNumber);
  }

  void addUser(User user) {
    addString(user.username);
    addU32(user.matches.length);
    for (var match in user.matches) {
      addAssignment(match);
    }
  }

  int readU32() {
    var data = _read!.sublist(_readIndex).buffer.asUint32List()[0];
    _readIndex += 4;
    return data;
  }

  String readString() {
    var length = readU32();
    var data = utf8.decode(_read!.sublist(_readIndex, _readIndex + length));
    _readIndex += length;
    return data;
  }

  Team readTeam() {
    var number = readU32();
    var name = readString();
    return Team(number: number, name: name);
  }

  Assignment readAssignment() {
    var team = readTeam();
    var number = readU32();
    return Assignment(team: team, matchNumber: number);
  }

  User readUser() {
    var username = readString();
    var u = User(username);
    var numMatches = readU32();
    for (int i = 0; i < numMatches; ++i) {
      final team = readTeam();
      final number = readU32();
      u.assign(team, number);
    }
    return u;
  }
}
