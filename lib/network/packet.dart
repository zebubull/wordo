import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:scouting_app/models/assignment.dart';
import 'package:scouting_app/models/team.dart';

enum PacketType {
  welcome,
  username,
  assignment,
  assignmentRequest,
}

enum _PacketMode {
  send,
  receive,
}

class InvalidModeError {
  String message;

  InvalidModeError(this.message);

  @override
  String toString() {
    return 'Invalid Packet Mode: $message';
  }
}

class Packet {
  BytesBuilder? _send;
  Uint8List? _receive;
  int _receiveIndex = 0;
  late PacketType type;
  _PacketMode _mode;

  List<int> get bytes => _send!.toBytes();

  Packet.send(this.type)
      : _send = BytesBuilder(),
        _mode = _PacketMode.send {
    addU32(type.index);
  }

  Packet.receive(Uint8List bytes)
      : _receive = bytes,
        _mode = _PacketMode.receive {
    type = PacketType.values[readU32()];
  }

  void _assertSend() {
    if (_mode != _PacketMode.send) {
      throw InvalidModeError("expected send mode");
    }
  }

  void send(Socket sock) {
    _assertSend();
    sock.add(bytes);
  }

  void addU32(int data) {
    _assertSend();
    _send!.add(Uint8List(4)..buffer.asUint32List()[0] = data);
  }

  void addString(String data) {
    _assertSend();
    addU32(data.length);
    _send!.add(utf8.encode(data));
  }

  void addTeam(Team team) {
    _assertSend();
    addU32(team.number);
    addString(team.name ?? "");
  }

  void addAssignment(Assignment assignment) {
    _assertSend();
    addTeam(assignment.team);
    addU32(assignment.matchNumber);
  }

  void _assertReceive() {
    if (_mode != _PacketMode.receive) {
      throw InvalidModeError("expected receive mode");
    }
  }

  int readU32() {
    _assertReceive();
    var data = _receive!.sublist(_receiveIndex).buffer.asUint32List()[0];
    _receiveIndex += 4;
    return data;
  }

  String readString() {
    _assertReceive();
    var length = readU32();
    var data =
        utf8.decode(_receive!.sublist(_receiveIndex, _receiveIndex + length));
    _receiveIndex += length;
    return data;
  }

  Team readTeam() {
    _assertReceive();
    var number = readU32();
    var name = readString();
    return Team(number: number, name: name);
  }

  Assignment readAssignment() {
    _assertReceive();
    var team = readTeam();
    var number = readU32();
    return Assignment(team: team, matchNumber: number);
  }
}
