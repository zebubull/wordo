import 'package:flutter/material.dart';
import 'package:scouting_app/models/server/server.dart';
import 'package:scouting_app/views/manager/user.dart';
import 'package:scouting_app/widgets/centered_card.dart';
import 'package:watch_it/watch_it.dart';

class UserListView extends WatchingStatefulWidget {
  @override
  State<StatefulWidget> createState() => _UserListViewState();
}

class _UserListViewState extends State<UserListView> {
  final _nameController = TextEditingController();

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final users = watchPropertyValue((Server s) => s.users);
    final clients = watchPropertyValue((Server s) => s.clients);

    return CenteredCard(
      width: 600,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: ListView(
          shrinkWrap: true,
          children: [
            if (users.isEmpty) const Text('No users registered'),
            for (var user in users)
              Padding(
                padding: const EdgeInsets.all(4.0),
                child: ElevatedButton(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Expanded(child: Center(child: Text(user.username))),
                        Icon(clients
                                .where((c) =>
                                    c != null && c.username == user.username)
                                .isNotEmpty
                            ? Icons.circle
                            : Icons.circle_outlined),
                      ],
                    ),
                    onPressed: () => Navigator.push(context,
                        MaterialPageRoute(builder: (_) => UserView(user)))),
              ),
            Divider(color: theme.colorScheme.onPrimaryContainer),
            ExpansionTile(
                title: const Text('Add user'),
                shape: const Border(),
                key: PageStorageKey('Add user'),
                children: [
                  TextField(
                    controller: _nameController,
                    key: PageStorageKey('users_nametext'),
                    decoration: InputDecoration(
                        hintText: 'Username', border: OutlineInputBorder()),
                  ),
                  SizedBox(height: 8.0),
                  IconButton(
                      icon: const Icon(Icons.add_box_outlined),
                      onPressed: () {
                        di.get<Server>().registerUser(_nameController.text);
                        _nameController.clear();
                      }),
                ])
          ],
        ),
      ),
    );
  }
}
