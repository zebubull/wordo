import 'dart:io';

import 'package:flutter/material.dart';
import 'package:scouting_app/models/server/client.dart';

class ServerProvider extends ChangeNotifier {
  ServerSocket? _serverSocket;
  List<Client?> _clients = [];

  bool get running => _serverSocket != null;
  int get port => _serverSocket?.port ?? 0;
  int get numClients =>
      _clients.map((e) => e == null ? 0 : 1).reduce((a, b) => a + b);
  List<Client?> get clients => _clients;

  static const maxConnections = 10;

  Future<void> start(InternetAddress host, int port) async {
    _clients.length = maxConnections;
    _serverSocket = await ServerSocket.bind(host, port);

    _serverSocket!.listen(_addClient);
    notifyListeners();
  }

  void _addClient(Socket sock) {
    for (var i = 0; i < maxConnections; ++i) {
      if (_clients[i] == null) {
        _clients[i] = Client(id: i, socket: sock, server: this);
        notifyListeners();
        return;
      }
    }

    print('[Error] No space for client to connect');
  }

  void disconnect(Client client) {
    _clients[client.id] = null;
    notifyListeners();
  }

  void onReceiveData() {
    notifyListeners();
  }
}
