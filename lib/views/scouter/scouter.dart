import 'package:flutter/material.dart';
import 'package:scouting_app/views/scouter/connect.dart';
import 'package:scouting_app/views/scouter/scout.dart';
import 'package:scouting_app/views/scouter/settings.dart';

class ScouterView extends StatefulWidget {
  @override
  State<ScouterView> createState() => _ScouterViewState();
}

class _ScouterViewState extends State<ScouterView> {
  int currentPageIndex = 0;

  final List<String> pageNames = <String>['Scout', 'Settings', 'Connect'];
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
        return ScoutView();
      case 1:
        return ConnectView();
      case 2:
        return SettingsView();
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
            selectedIcon: const Icon(Icons.edit),
            icon: const Icon(Icons.edit_outlined),
            label: const Text('Scout')),
        NavigationRailDestination(
            selectedIcon: const Icon(Icons.cast_connected_rounded),
            icon: const Icon(Icons.cast_connected_outlined),
            label: const Text('Connect')),
        NavigationRailDestination(
          selectedIcon: const Icon(Icons.settings),
          icon: const Icon(Icons.settings_outlined),
          label: const Text('Settings'),
        ),
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
          selectedIcon: const Icon(Icons.edit),
          icon: const Icon(Icons.edit_outlined),
          label: 'Scout',
        ),
        NavigationDestination(
          selectedIcon: const Icon(Icons.cast_connected_rounded),
          icon: const Icon(Icons.cast_connected_outlined),
          label: 'Connect',
        ),
        NavigationDestination(
          selectedIcon: const Icon(Icons.settings),
          icon: const Icon(Icons.settings_outlined),
          label: 'Settings',
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
