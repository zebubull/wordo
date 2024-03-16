import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:scouting_app/models/client/client.dart';
import 'package:scouting_app/models/team.dart';
import 'package:scouting_app/network/packet.dart';

class ClientProvider extends ChangeNotifier {
  Client? _client;

  bool get connected => _client != null;
  Client? get client => _client;

  List<Team> assignedTeams = <Team>[];

  void updateName(String name) {
    if (client == null) return;

    client!.name = name;
    var namePacket = Packet.send(PacketType.username);
    namePacket.addString(client!.name);
    namePacket.send(client!.socket);
    client!.socket.flush();
  }

  void _onClientReceive(Uint8List bytes) {
    var packet = Packet.receive(bytes);
    switch (packet.type) {
      case PacketType.welcome:
        _client!.id = packet.readU32();
        notifyListeners();
        Packet.send(PacketType.assignmentRequest).send(client!.socket);
        client!.socket.flush();
      case PacketType.assignment:
        var number = packet.readU32();
        var name = packet.readString();
        assignedTeams.add(Team(number: number, name: name));
        notifyListeners();
      default:
        break;
    }
  }

  void _closeClient() async {
    if (_client == null) return;
    await _client!.socket.close();
    _client = null;
    notifyListeners();
  }

  void _onClientError(Object? error) {
    print('$error');
    _closeClient();
  }

  void connectToServer(InternetAddress host, int port) async {
    try {
      var sock = await Socket.connect(host, port);
      print('[Debug] Connected to server');
      sock.listen(_onClientReceive,
          onError: _onClientError, onDone: _closeClient);
      _client = Client(id: -1, socket: sock);
    } catch (err) {
      print('[Error] Failed to connect to server: $err');
    }
  }
}
