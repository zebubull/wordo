import 'dart:io';
import 'dart:typed_data';

import 'package:scouting_app/models/assignment.dart';
import 'package:scouting_app/models/team.dart';
import 'package:scouting_app/network/packet.dart';
import 'package:scouting_app/providers/server.dart';

class Client {
  final int id;
  Socket socket;
  ServerProvider server;

  String username = "scouter";

  void _onRecieveData(Uint8List bytes) {
    var packet = Packet.receive(bytes);
    switch (packet.type) {
      case PacketType.username:
        username = packet.readString();
        server.onReceiveData();
      case PacketType.assignmentRequest:
        var assignment = Packet.send(PacketType.assignment);
        assignment.addAssignment(Assignment(
            team: Team(number: 8873, name: "Test Team"), matchNumber: 7));
        assignment.send(socket);

        socket.flush();
      default:
        break;
    }
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
    var idPacket = Packet.send(PacketType.welcome);
    idPacket.addU32(id);
    idPacket.send(socket);
    socket.flush();

    socket.listen(_onRecieveData, onError: _onError, onDone: _closeClient);
  }
}
