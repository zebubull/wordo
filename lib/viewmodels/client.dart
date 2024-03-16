import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';

class ClientViewModel extends ChangeNotifier {
  Socket? _clientSocket;
  int _clientId = 0;

  bool get connected => _clientSocket != null;
  int get clientId => _clientId;

  void _onClientReceive(Uint8List bytes) {
    int packetId = bytes[0];
    switch (packetId) {
      case 0:
        if (bytes.length != 5) {
          print('[Error] Received bad welcome packet with id: $packetId');
          _closeClient();
          break;
        }
        _clientId = ByteData.sublistView(bytes, 1).getUint32(0);
        notifyListeners();
      default:
        print('[Error] Received unknown packet with id: $packetId');
        break;
    }
  }

  void _closeClient() async {
    if (_clientSocket == null) return;
    await _clientSocket!.close();
    _clientSocket = null;
    _clientId = 0;
    notifyListeners();
  }

  void _onClientError(Object? error) {
    print('$error');
    _closeClient();
  }

  void connectToServer(InternetAddress host, int port) async {
    try {
      _clientSocket = await Socket.connect(host, port);
      print('[Debug] Connected to server');
      _clientSocket!.listen(_onClientReceive,
          onError: _onClientError, onDone: _closeClient);
    } catch (err) {
      print('[Error] Failed to connect to server: $err');
    }
  }
}
