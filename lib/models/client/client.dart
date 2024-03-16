import 'dart:io';
import 'dart:typed_data';

class Client {
  int id;
  Socket socket;
  String name = "scouter";

  Uint8List get idBytes => Uint8List(4)..buffer.asUint32List(0)[0] = id;

  Client({required this.id, required this.socket});
}
