import 'dart:io';
import 'dart:typed_data';

import 'package:scouting_app/util/byte_helper.dart';

enum PacketType {
  welcome,
  disconnect,
  username,
  assignment,
}

class Packet extends ByteHelper {
  late PacketType type;

  Packet.send(this.type) : super.write() {
    addU32(type.index);
  }

  Packet.receive(Uint8List bytes) : super.read(bytes) {
    type = PacketType.values[readU32()];
  }

  void send(Socket sock) {
    sock.add(bytes);
  }
}
