import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:provider/provider.dart';
import 'package:scouting_app/main.dart';
import 'package:scouting_app/providers/client.dart';
import 'package:scouting_app/util/byte_helper.dart';
import 'package:scouting_app/views/scouter/match.dart';
import 'package:scouting_app/widgets/centered_card.dart';

class ScoutView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<ClientProvider>(
      builder: (context, client, child) {
        if (client.loadingMatches) return CircularProgressIndicator();

        return CenteredCard(
            child: ListView(shrinkWrap: true, children: [
          if (client.assignedMatches.isEmpty) const Text('No matches assigned'),
          for (var match in client.assignedMatches)
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: ElevatedButton(
                  child: Text(
                      '${match.team.name} (${match.team.number}): ${match.matchNumber}'),
                  onPressed: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => MatchView(match)))),
            ),
            if (client.assignedMatches.isNotEmpty) Divider(),
            ElevatedButton.icon(label: const Text('Scan QR Code'), icon: const Icon(Icons.qr_code_scanner), onPressed: _readQr)
        ]));
      },
    );
  }

  void _readQr() {
    showDialog(context: navigatorKey.currentContext!, builder: (_) {
      return MobileScanner(onDetect: (capture) async {
        var bytes = capture.barcodes.firstOrNull?.rawBytes;
        if (bytes == null) return;
        var match = ByteHelper.read(bytes).readAssignment();
        await Provider.of<ClientProvider>(navigatorKey.currentContext!).assignMatch(match);
      });
    });
  }
}
