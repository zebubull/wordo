import 'dart:convert';
import 'dart:typed_data';

enum PacketType {
  welcome,
  username,
}

class Packet {
  BytesBuilder? _send;
  Uint8List? _receive;
  int _receiveIndex = 0;
  late PacketType type;

  List<int> get bytes => _send!.toBytes();

  Packet.send(this.type) : _send = BytesBuilder() {
    addU32(type.index);
  }

  Packet.receive(Uint8List bytes) : _receive = bytes {
    type = PacketType.values[readU32()];
  }

  void addU32(int data) {
    _send?.add(Uint8List(4)..buffer.asUint32List()[0] = data);
  }

  void addString(String data) {
    addU32(data.length);
    _send?.add(utf8.encode(data));
  }

  int readU32() {
    var data = _receive?.sublist(_receiveIndex).buffer.asUint32List()[0];
    _receiveIndex += 4;
    return data ?? 0;
  }

  String readString() {
    var length = readU32();
    var data =
        utf8.decode(_receive!.sublist(_receiveIndex, _receiveIndex + length));
    _receiveIndex += length;
    return data;
  }
}
