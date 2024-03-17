import 'dart:collection';
import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:scouting_app/models/assignment.dart';
import 'package:scouting_app/models/team.dart';
import 'package:scouting_app/network/packet.dart';

import 'client.dart';

class User extends ChangeNotifier {
  String _username;
  List<Assignment> _assignments;

  String get username => _username;
  UnmodifiableListView<Assignment> get matches =>
      UnmodifiableListView(_assignments);

  User(String username)
      : _username = username,
        _assignments = [];

  void assign(Team team, int match) {
    _assignments.add(Assignment(team: team, matchNumber: match));
    notifyListeners();
  }

  void unassign(Assignment match) {
    _assignments.remove(match);
    notifyListeners();
  }
}

class Server extends ChangeNotifier {
  ServerSocket? _sock;
  List<Client?> _clients;
  List<User> _users;

  bool get running => _sock != null;
  int get port => _sock?.port ?? 0;
  UnmodifiableListView<Client?> get clients => UnmodifiableListView(_clients);
  UnmodifiableListView<User> get users => UnmodifiableListView(_users);

  int _numClients = 0;
  int get numClients => _numClients;

  Server(InternetAddress host, int port)
      : _clients = [],
        _users = [] {
    _start(host, port);
  }

  void _start(InternetAddress host, int port) async {
    _sock = await ServerSocket.bind(host, port);
    _sock!.listen(_receiveClient);
    notifyListeners();
  }

  void _receiveClient(Socket client) {
    _numClients++;
    for (int i = 0; i < _clients.length; ++i) {
      if (_clients[i] == null) {
        _clients[i] = Client(i, client);
        _setupClient(_clients[i]!);
        notifyListeners();
        return;
      }
    }

    var id = _clients.length;
    _clients.add(Client(id, client));
    _setupClient(_clients[id]!);
    notifyListeners();
  }

  void _setupClient(Client client) {
    client.sock.listen((data) => _onPacketGet(data, client.id),
        onDone: () => _removeClient(client.id));

    var welcome = Packet.send(PacketType.welcome);
    welcome.addU32(client.id);
    welcome.send(client.sock);
    client.sock.flush();
  }

  void _removeClient(int id) {
    _clients[id]!.sock.close();
    _clients[id] = null;
    _numClients--;
    notifyListeners();
  }

  void _onPacketGet(Uint8List data, int clientId) {
    var packet = Packet.receive(data);
    var id = packet.readU32();

    switch (packet.type) {
      case PacketType.username:
        String username = packet.readString();
        _clients[id]!.setName(username);
        var user = _users.where((u) => u.username == username).firstOrNull;
        if (user != null) {
          _clients[id]!.setMatches(user.matches);
        }
        notifyListeners();
      default:
        break;
    }
  }

  User registerUser(String username) {
    var user = User(username);
    _users.add(user);
    notifyListeners();
    return user;
  }

  void checkAssignments(User user) {
    var client = _clients
        .where((c) => c != null && c.username == user.username)
        .firstOrNull;
    if (client != null) {
      client.setMatches(user.matches);
    }
  }
}
