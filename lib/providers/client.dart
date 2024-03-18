import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:scouting_app/models/assignment.dart';
import 'package:scouting_app/models/client/client.dart';
import 'package:scouting_app/network/packet.dart';
import 'package:scouting_app/widgets/error_dialog.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ClientProvider extends ChangeNotifier {
  Client? _client;
  SharedPreferences? _prefs;

  bool get connected => _client != null;
  Client? get client => _client;

  List<Assignment> assignedMatches = <Assignment>[];

  String _username = "scouter";

  ClientProvider() {
    SharedPreferences.getInstance().then((prefs) {
      _prefs = prefs;
      _username = _prefs!.getString('username') ?? "scouter";

      var port = prefs.getInt('port');

      if (port != null) {
        var host = InternetAddress(prefs.getString('host')!);
        connectToServer(host, port);
      }
    });
  }

  void updateName(String name) {
    _username = name;
    _prefs?.setString('username', name);
    if (client == null) return;

    client!.name = name;
    var namePacket = Packet.send(PacketType.username);
    namePacket.addU32(client!.id);
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
        var req = Packet.send(PacketType.username);
        req.addU32(client!.id);
        req.addString(client!.name);
        req.send(client!.socket);
        client!.socket.flush();
      case PacketType.assignment:
        var count = packet.readU32();
        assignedMatches.clear();
        for (var i = 0; i < count; ++i) {
          assignedMatches.add(packet.readAssignment());
        }
        notifyListeners();
      default:
        break;
    }
  }

  Future<void> _closeClient() async {
    if (_client == null) return;
    await _client!.socket.close();
    _client = null;
    notifyListeners();
  }

  void _onClientError(Object? err) {
    ErrorDialog.show('Client error', err.toString(), () => {});
    _closeClient();
  }

  Future<void> connectToServer(InternetAddress host, int port) async {
    try {
      var sock = await Socket.connect(host, port);
      print('[Debug] Connected to server');
      sock.listen(_onClientReceive,
          onError: _onClientError, onDone: _closeClient);
      _client = Client(id: -1, socket: sock);
      _client!.name = _username;
      _prefs?.setInt('port', port);
      _prefs?.setString('host', host.address);
    } catch (err) {
      ErrorDialog.show('Client error',
          'Failed to connect to server\n${err.toString()}', () => {});
    }
  }
}
