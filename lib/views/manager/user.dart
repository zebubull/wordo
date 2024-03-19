import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:scouting_app/main.dart';
import 'package:scouting_app/models/assignment.dart';
import 'package:scouting_app/models/server/server.dart';
import 'package:scouting_app/models/team.dart';
import 'package:scouting_app/util/byte_helper.dart';
import 'package:scouting_app/widgets/centered_card.dart';
import 'package:scouting_app/widgets/match_input_card.dart';
import 'package:watch_it/watch_it.dart';

class UserView extends WatchingStatefulWidget {
  final User user;
  UserView(this.user);

  @override
  State<UserView> createState() => _UserViewState();
}

class _UserViewState extends State<UserView> {
  var _numberController = TextEditingController();
  Team? selectedTeam;

  @override
  void dispose() {
    _numberController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final user = watch(widget.user);

    return Scaffold(
      appBar: AppBar(title: Text(user.username)),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: CenteredCard(
            width: 600,
            child: ListView(shrinkWrap: true, children: [
              for (var match in user.matches)
                ListTile(
                    title: Text('(${match.matchNumber}) ${match.team.name}'),
                    trailing: IconButton(
                        icon: const Icon(Icons.delete_outline_rounded),
                        onPressed: () {
                          user.unassign(match);
                          di.get<Server>().checkAssignments(user);
                        })),
              if (user.matches.isNotEmpty)
                Divider(color: theme.colorScheme.onPrimaryContainer),
              if (user.matches.isNotEmpty)
                ElevatedButton(
                    onPressed: () => showDialog(
                        context: navigatorKey.currentContext!,
                        builder: (_) => _makeQr(user.matches)),
                    child: const Text('QR Code')),
              if (user.matches.isNotEmpty)
                Divider(color: theme.colorScheme.onPrimaryContainer),
              MatchInputCard(onPressed: (match) {
                user.assign(match);
                di.get<Server>().checkAssignments(user);
              }),
            ])),
      ),
    );
  }

  Widget _makeQr(List<Assignment> matches) {
    var data = ByteHelper.write();
    data.addU8(matches.length);
    for (var match in matches) {
      data.addU16(match.team.number);
      data.addU8(match.matchNumber);
    }

    final code = QrCode.fromUint8List(
        data: data.bytes, errorCorrectLevel: QrErrorCorrectLevel.L);
    return Dialog(
        child: Padding(
      padding: const EdgeInsets.all(8.0),
      child: QrImageView.withQr(
        qr: code,
        backgroundColor: Colors.white,
      ),
    ));
  }
}
