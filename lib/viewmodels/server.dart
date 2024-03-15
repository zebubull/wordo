import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';

class ServerViewModel extends ChangeNotifier {
  ServerSocket? _serverSocket;

  void initializeServer() async {
    if (_serverSocket != null) {
      await _serverSocket!.close();
    }

    _serverSocket = await ServerSocket.bind('0.0.0.0', 42069);

    _serverSocket!.listen((socket) {
      socket.add(Uint8List.fromList([0,0,0,0,69]));
      socket.flush();

      socket.listen((List<int> data) async {});
    });
  }
}
