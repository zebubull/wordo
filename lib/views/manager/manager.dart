import 'package:flutter/material.dart';
import 'package:scouting_app/views/manager/clients.dart';
import 'package:scouting_app/views/manager/network.dart';
import 'package:scouting_app/views/manager/teams.dart';
import 'package:scouting_app/views/manager/users.dart';

class ManagerView extends StatefulWidget {
  @override
  State<ManagerView> createState() => _ManagerViewState();
}

class _ManagerViewState extends State<ManagerView> {
  int currentPageIndex = 0;

  final List<String> pageNames = <String>[
    'Clients',
    'Users',
    'Teams',
    'Network'
  ];
  int get logoutIndex => pageNames.length;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      return constraints.maxWidth <= 650
          ? makeMobileLayout()
          : makeDesktopLayout(constraints);
    });
  }

  Scaffold makeMobileLayout() {
    return Scaffold(
      bottomNavigationBar: makeNavigationBar(),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: makeCurrentView(),
      ),
    );
  }

  Scaffold makeDesktopLayout(BoxConstraints constraints) {
    return Scaffold(
      body: Row(
        children: [
          makeNavigationRail(constraints),
          const VerticalDivider(),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: makeCurrentView(),
            ),
          ),
        ],
      ),
    );
  }

  Widget makeCurrentView() {
    switch (currentPageIndex) {
      case 0:
        return ClientListView();
      case 1:
        return UserListView();
      case 2:
        return TeamsView();
      case 3:
        return NetworkView();
      default:
        throw UnimplementedError();
    }
  }

  Widget makeNavigationRail(BoxConstraints constraints) {
    return NavigationRail(
      extended: constraints.maxWidth >= 1200,
      onDestinationSelected: updateSelectedPage,
      selectedIndex: currentPageIndex,
      labelType:
          constraints.maxWidth >= 1200 ? null : NavigationRailLabelType.all,
      destinations: [
        NavigationRailDestination(
            selectedIcon: const Icon(Icons.person),
            icon: const Icon(Icons.person_outlined),
            label: const Text('Clients')),
        NavigationRailDestination(
            icon: const Icon(Icons.list), label: const Text('Users')),
        NavigationRailDestination(
          selectedIcon: const Icon(Icons.theater_comedy_rounded),
          icon: const Icon(Icons.theater_comedy_outlined),
          label: const Text('Teams'),
        ),
        NavigationRailDestination(
            selectedIcon: const Icon(Icons.signal_wifi_4_bar),
            icon: const Icon(Icons.signal_wifi_0_bar_outlined),
            label: const Text('Network')),
        NavigationRailDestination(
            icon: const Icon(Icons.logout_rounded),
            label: const Text('Logout')),
      ],
    );
  }

  Widget makeNavigationBar() {
    return NavigationBar(
      onDestinationSelected: updateSelectedPage,
      selectedIndex: currentPageIndex,
      destinations: <Widget>[
        NavigationDestination(
          selectedIcon: const Icon(Icons.person),
          icon: const Icon(Icons.person_outlined),
          label: 'Clients',
        ),
        NavigationDestination(
          icon: const Icon(Icons.list),
          label: 'Users',
        ),
        NavigationDestination(
          selectedIcon: const Icon(Icons.theater_comedy_rounded),
          icon: const Icon(Icons.theater_comedy_outlined),
          label: 'Teams',
        ),
        NavigationDestination(
          selectedIcon: const Icon(Icons.signal_wifi_4_bar_outlined),
          icon: const Icon(Icons.signal_wifi_0_bar_outlined),
          label: 'Network',
        ),
        NavigationDestination(
          icon: const Icon(Icons.logout_rounded),
          label: 'Logout',
        ),
      ],
    );
  }

  void updateSelectedPage(int index) {
    if (index == logoutIndex) {
      Navigator.pop(context);
      return;
    }

    setState(() => currentPageIndex = index);
  }
}
