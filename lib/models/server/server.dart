import 'dart:collection';
import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:scouting_app/network/packet.dart';

import 'client.dart';

class Server extends ChangeNotifier {
  ServerSocket? _sock;
  List<Client?> _clients;

  bool get running => _sock != null;
  int get port => _sock?.port ?? 0;
  UnmodifiableListView<Client?> get clients => UnmodifiableListView(_clients);

  Server(InternetAddress host, int port) : _clients = [] {
    _start(host, port);
  }

  void _start(InternetAddress host, int port) async {
    _sock = await ServerSocket.bind(host, port);
    _sock!.listen(_receiveClient);
    notifyListeners();
  }

  void _receiveClient(Socket client) {
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
    notifyListeners();
  }

  void _onPacketGet(Uint8List data, int clientId) {
    var packet = Packet.receive(data);
    var id = packet.readU32();

    switch (packet.type) {
      case PacketType.username:
        String username = packet.readString();
        _clients[id]!.setName(username);
      default:
        break;
    }
  }
}
