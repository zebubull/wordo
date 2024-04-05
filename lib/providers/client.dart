import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:scouting_app/main.dart';
import 'package:scouting_app/models/assignment.dart';
import 'package:scouting_app/models/client/client.dart';
import 'package:scouting_app/network/packet.dart';
import 'package:scouting_app/util/byte_helper.dart';
import 'package:scouting_app/util/noitifer.dart';
import 'package:scouting_app/widgets/error_dialog.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ClientProvider extends ChangeNotifier {
  Client? _client;
  SharedPreferences? _prefs;

  bool get connected => _client != null;
  Client? get client => _client;

  List<Assignment> assignedMatches = <Assignment>[];

  bool? _loadingMatches;
  Future<void>? _loadingFuture;
  bool get loadingMatches => _loadingMatches == true;

  String _username = "scouter";

  ClientProvider() {
    SharedPreferences.getInstance().then((prefs) {
      _prefs = prefs;
      _username = _prefs!.getString('username') ?? "scouter";

      var port = prefs.getInt('port');

      if (port != null) {
        var host = InternetAddress(prefs.getString('host')!);
        connectToServer(host, port, showErrorAsNotification: true);
      }

      _loadingFuture = _loadAssignments();
    });
  }

  void updateName(String name) {
    _username = name; _prefs?.setString('username', name);
    if (client == null) return;

    client!.name = name;
    var namePacket = Packet.send(PacketType.username);
    namePacket.addU32(client!.id);
    namePacket.addString(client!.name);
    namePacket.send(client!.socket);
    client!.socket.flush();
  }

  void _onClientReceive(Uint8List bytes) async {
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
        if (_loadingFuture != null) {
          await _loadingFuture;
          _loadingFuture = null;
        }
        var count = packet.readU32();
        assignedMatches.clear();
        for (var i = 0; i < count; ++i) {
          assignedMatches.add(packet.readAssignment());
        }
        await _saveAssignments();
        notifyListeners();
      case PacketType.disconnect:
        _closeClient();
        ErrorDialog.show('Disconnected',
            'The server host has forcibly disconnected you.', () {});
      default:
        break;
    }
  }

  Future<void> _saveAssignments() async {
    if (dataPath == null) return;
    var data = ByteHelper.write();
    data.addU32(assignedMatches.length);
    for (var match in assignedMatches) {
      data.addAssignment(match);
    }
  
    await Directory('${dataPath!.path}/user').create();
    await File('${dataPath!.path}/user/matches.dat').writeAsBytes(data.bytes);
  }

  Future<void> _loadAssignments() async {
    if (dataPath == null) return;
    _loadingMatches = true;
    notifyListeners();
    var file = File('${dataPath!.path}/user/matches.dat');
    if (!await file.exists()) {
      _loadingMatches = false;
      notifyListeners();
      return;
    }
    var data = ByteHelper.read(await file.readAsBytes());
    var numMatches = data.readU32();
    for (var i = 0; i < numMatches; ++i) {
      assignedMatches.add(data.readAssignment());
    }
    _loadingMatches = false;
    notifyListeners();
  }

  Future<void> _closeClient() async {
    if (_client == null) return;
    await _client!.socket.close();
    _client = null;
    notifyListeners();
    showNotification('Disconnected from server.');
  }

  void _onClientError(Object? err) {
    ErrorDialog.show('Client error', err.toString(), () => {});
    _closeClient();
  }

  Future<void> connectToServer(InternetAddress host, int port, {bool showErrorAsNotification = false}) async {
    try {
      var sock = await Socket.connect(host, port);
      sock.listen(_onClientReceive,
          onError: _onClientError, onDone: _closeClient);
      _client = Client(id: -1, socket: sock);
      _client!.name = _username;
      _prefs?.setInt('port', port);
      _prefs?.setString('host', host.address);
      showNotification('Connected to server.');
    } catch (err) {
      if (!showErrorAsNotification) {
        ErrorDialog.show('Client error',
          'Failed to connect to server\n${err.toString()}', () => {});
      } else {
        showNotification('Failed to connect to server');
      }
    }
  }

  Future<void> assignMatch(Assignment match) async {
        if (_loadingFuture != null) {
          await _loadingFuture;
          _loadingFuture = null;
        }

        assignedMatches.add(match);
        await _saveAssignments();
        notifyListeners();
  }
}
