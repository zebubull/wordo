import 'dart:convert';
import 'dart:io';

import 'package:biden_blast/team.dart';
import 'package:biden_blast/teams_model.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:network_info_plus/network_info_plus.dart';
import 'package:provider/provider.dart';
import 'package:udp/udp.dart';

class SharePage extends StatefulWidget {
  @override
  State<SharePage> createState() => _SharePageState();
}

Future<void> shareTeams(BuildContext context, InternetAddress? target) async {
  if (!context.mounted) return;

  if (target == null) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: const Text('IP Address was null.')),
    );
  }

  final teamsJson = jsonEncode(Provider.of<TeamsModel>(context, listen: false).teams.map((t) => t.toJson()).toList());

  var sender = await UDP.bind(Endpoint.any(port: Port(8872)));
  if (!context.mounted) return;
  await sender.send(teamsJson.codeUnits,
    Endpoint.broadcast(port: Port(8873)));

  sender.close();
  if (context.mounted) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: const Text('IP Address was null.')),
    );
  }
}

List<Team> _parseTeams(String data) {
  final List json = jsonDecode(data);

  return json.map((j) => Team.fromJson(j)).toList();
}

Future<void> receiveTeams(BuildContext context) async {
  if (!context.mounted) return;

  final teamsModel = Provider.of<TeamsModel>(context, listen: false);

  var receiver = await UDP.bind(Endpoint.any(port: Port(8873)));
  final datagram = await receiver.asStream(timeout: Duration(seconds: 20)).single;

  final teamsList = await compute(_parseTeams, datagram!.data.toString());

  receiver.close();
  teamsModel.addTeams(teamsList);
  if (context.mounted) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('${teamsList.length} teams received.')),
    );
  }
}

class _SharePageState extends State<SharePage> {
  final _formKey = GlobalKey<FormState>();

  InternetAddress? targetAddress;
  String myAddress = 'Getting IP';

  Future<void> getIP() async {
    String addr = (await NetworkInfo().getWifiIP()) ?? 'Failed to get local IP';

    setState(() => myAddress = addr);
  }

  @override
  void initState() {
    super.initState();
    getIP();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            decoration: BoxDecoration(
              color: theme.colorScheme.background,
              borderRadius: BorderRadius.only(topLeft: Radius.circular(16.0), topRight: Radius.circular(16.0))
            ),
            child: ExpansionTile(
              title: Text('Send'),
              shape: const Border(),
              children: [
                Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      TextFormField(
                      decoration: const InputDecoration(hintText: 'Target IP', border: OutlineInputBorder()),
                      keyboardType: TextInputType.number,
                      validator: (s) => s != null && InternetAddress.tryParse(s) == null ? 'Enter a valid IP Adress' : null,
                      onSaved: (String? val) => targetAddress = InternetAddress(val!),
                      ),
                      ElevatedButton.icon(
                        icon: Icon(Icons.file_upload_outlined),
                        label: const Text('Share'),
                        onPressed: () => shareTeams(context, targetAddress),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Container(
            decoration: BoxDecoration(
              color: theme.colorScheme.background,
              borderRadius: BorderRadius.only(bottomLeft: Radius.circular(16.0), bottomRight: Radius.circular(16.0))
            ),
            child: ExpansionTile(
              title: Text('Receive'),
              shape: const Border(),
              children: [
                Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      Text('IP Address: $myAddress'),
                      ElevatedButton.icon(
                        icon: Icon(Icons.file_upload_outlined),
                        label: const Text('Share'),
                        onPressed: () => receiveTeams(context),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}