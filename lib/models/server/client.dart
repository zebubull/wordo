import 'dart:io';
import 'dart:typed_data';

import 'package:scouting_app/models/assignment.dart';
import 'package:scouting_app/network/packet.dart';
import 'package:scouting_app/providers/server.dart';

class Client {
  final int id;
  Socket socket;
  ServerProvider server;

  String username = "scouter";

  List<Assignment> assignments;

  void _onRecieveData(Uint8List bytes) {
    var packet = Packet.receive(bytes);
    switch (packet.type) {
      case PacketType.username:
        username = packet.readString();
        server.markDirty();
      case PacketType.assignmentRequest:
        _sendAssignments();
      default:
        break;
    }
  }

  void _sendAssignments() {
    var assignment = Packet.send(PacketType.assignment);
    assignment.addU32(assignments.length);
    for (var match in assignments) {
      assignment.addAssignment(match);
    }

    assignment.send(socket);
    socket.flush();
  }

  void _closeClient() {
    socket.close();
    server.disconnect(this);
  }

  void _onError(Object? error) {
    print('[Error] Error receiving client data: $error');
    _closeClient();
  }

  void assign(Assignment match) {
    assignments.add(match);
    server.markDirty();
    _sendAssignments();
  }

  void unassign(Assignment match) {
    assignments.remove(match);
    server.markDirty();
    _sendAssignments();
  }

  Client({required this.id, required this.socket, required this.server})
      : assignments = [] {
    var idPacket = Packet.send(PacketType.welcome);
    idPacket.addU32(id);
    idPacket.send(socket);
    socket.flush();

    socket.listen(_onRecieveData, onError: _onError, onDone: _closeClient);
  }
}
