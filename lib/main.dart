import 'package:biden_blast/new_team_page.dart';
import 'package:biden_blast/share_page.dart';
import 'package:biden_blast/team_page.dart';
import 'package:biden_blast/team_select_page.dart';
import 'package:biden_blast/teams_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import 'big_card.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky).then((_) => runApp(MyApp()));
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});
  
  @override
  MyAppState createState() => MyAppState();
}

class MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) {
          final model = TeamsModel();
          model.load();
          return model;
        }),
      ],
      child: MaterialApp(
        title: 'Gamer App',
        theme: ThemeData(
          useMaterial3: true,
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.lime),
        ),
        home: HomePage(),
      ),
    );
  }
}

class HomePage extends StatefulWidget {
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  var selectedIndex = 0;
  var selectedTeam = 0;
  
  @override
  Widget build(BuildContext context) {
    Widget page = switch (selectedIndex) {
      0 => MainPage(),
      1 => TeamSelectPage(
        onTeamSelect: (id) => setState(() {
          selectedTeam = id;
          selectedIndex = 4;
      })),
      2 => NewTeamPage(
        onTeamCreated: (id) => setState(() {
          selectedTeam = id;
          selectedIndex = 4;
      })),
      3 => SharePage(),
      4 => TeamPage(id: selectedTeam),
      _ => throw UnimplementedError('Page with index $selectedIndex not found!'),
    };

    return LayoutBuilder(builder: (context, constraints) {
      return Scaffold(
        body: Row(
          children: [
            SafeArea(
              child: _makeNavRail(constraints),
            ),
            Expanded(
              child: Container(
                color: Theme.of(context).colorScheme.primaryContainer,
                child: page,
              ),
            ),
          ],
        ),
      );
    });
  }

  Consumer<TeamsModel> _makeNavRail(BoxConstraints constraints) {
    return Consumer<TeamsModel>(
      builder: (context, teams, _) => NavigationRail(
        extended: constraints.maxWidth >= 700,
        destinations: [
          NavigationRailDestination(icon: Icon(Icons.home), label: Text('Home')),
          NavigationRailDestination(icon: Icon(Icons.menu), label: Text('Teams')),
          NavigationRailDestination(icon: Icon(Icons.add), label: Text('New Team')),
          NavigationRailDestination(icon: Icon(Icons.share), label: Text('Share')),
          NavigationRailDestination(
            icon: Icon(teams.saved ? Icons.check_circle_outline : Icons.save_outlined),
            label: Text(teams.saved ? 'Changes Saved' : 'Unsaved Changes'),
          ),
          NavigationRailDestination(icon: Icon(Icons.archive), label: Text('Export Data')),
        ],
        selectedIndex: selectedIndex == 4 ? 1 : selectedIndex,
        onDestinationSelected: (dest) {
          if (dest == 4) {
            Provider.of<TeamsModel>(context, listen: false).save(context);
          } else if (dest == 5) {
            Provider.of<TeamsModel>(context, listen: false).export(context);
          } else {
            setState(() => selectedIndex = dest);
          }
        },
      ),
    );
  }
}

class MainPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          BigCard(text: "Scouting App"),
          SizedBox(height: 10),
          Image(image: AssetImage('assets/biden.jpg')),
          SizedBox(height: 10),
          const Text("Sponsored by Sleepy Joe Brandon"),
        ]
      )
    );
  }
}
