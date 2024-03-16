import 'dart:io';
import 'dart:typed_data';

import 'package:scouting_app/viewmodels/server.dart';

class Client {
  final int id;
  Socket socket;
  ServerViewModel server;

  void _onRecieveData(List<int> data) {
    // TODO: Implement method
    print('[Msg] ($id) ${String.fromCharCodes(data)}');
  }

  void _closeClient() {
    socket.close();
    server.disconnect(this);
  }

  void _onError(Object? error) {
    print('[Error] Error receiving client data: $error');
    _closeClient();
  }

  Client({required this.id, required this.socket, required this.server}) {
    var idPacket = Uint8List.fromList([0, 0, 0, 0, id]);
    socket.add(idPacket);
    socket.flush();

    socket.listen(_onRecieveData, onError: _onError, onDone: _closeClient);
  }
}
