import 'package:flutter/material.dart';

class ScouterView extends StatefulWidget {
  @override
  State<ScouterView> createState() => _ScouterViewState();
}

class _ScouterViewState extends State<ScouterView> {
  int currentPageIndex = 0;

  final List<String> pageNames = <String>['Scout', 'Connect'];
  int get logoutIndex => pageNames.length;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      if (constraints.maxWidth <= 650) {
        return Scaffold(
          appBar: AppBar(
            title: Text(pageNames[currentPageIndex]),
            automaticallyImplyLeading: false,
          ),
          bottomNavigationBar: makeNavigationBar(),
          body: Padding(
            padding: const EdgeInsets.all(8.0),
          ),
        );
      } else {
        return Scaffold(
          appBar: AppBar(
            title: Text(pageNames[currentPageIndex]),
            automaticallyImplyLeading: false,
          ),
          body: Row(
            children: [
              makeNavigationRail(constraints),
              const VerticalDivider(),
              Padding(
                padding: const EdgeInsets.all(8.0),
              ),
            ],
          ),
        );
      }
    });
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
