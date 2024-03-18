import 'dart:collection';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:scouting_app/models/assignment.dart';
import 'package:scouting_app/network/packet.dart';

class Client extends ChangeNotifier {
  Socket sock;

  int _id;
  int get id => _id;

  String? _username;
  String get username => _username ?? sock.remoteAddress.host;

  List<Assignment> _matches;
  UnmodifiableListView<Assignment> get matches =>
      UnmodifiableListView(_matches);

  Client(int id, this.sock)
      : _id = id,
        _matches = [];

  void assign(Assignment match) {
    _matches.add(match);
    _sendAssignments();
    notifyListeners();
  }

  void unassign(Assignment match) {
    _matches.remove(match);
    _sendAssignments();
    notifyListeners();
  }

  void setName(String name) {
    _username = name;
    notifyListeners();
  }

  void setMatches(List<Assignment> matches) {
    _matches.clear();
    _matches.addAll(matches);
    _sendAssignments();
    notifyListeners();
  }

  void _sendAssignments() {
    var packet = Packet.send(PacketType.assignment);
    packet.addU32(_matches.length);
    for (var match in _matches) {
      packet.addAssignment(match);
    }
    packet.send(sock);
    sock.flush();
  }

  @override
  String toString() {
    return '$username@${sock.remoteAddress.address}';
  }
}
