import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:scouting_app/models/server/server.dart';
import 'package:scouting_app/models/server/team_store.dart';
import 'package:scouting_app/providers/client.dart';
import 'package:watch_it/watch_it.dart';

import 'views/home.dart';

void main() async {
  di.registerLazySingleton<Server>(
      () => Server(InternetAddress.anyIPv4, 42069));
  di.registerLazySingleton<TeamStore>(() => TeamStore());

  WidgetsFlutterBinding.ensureInitialized();
  await SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);
  runApp(MultiProvider(providers: [
    ChangeNotifierProvider(create: (_) => ClientProvider()),
  ], child: App()));
}

class App extends StatefulWidget {
  const App({super.key});

  @override
  AppState createState() => AppState();
}

class AppState extends State<App> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: '8873 Scouting',
      theme: ThemeData(
        useMaterial3: true,
        colorSchemeSeed: Colors.lightBlue,
      ),
      darkTheme: ThemeData(
        useMaterial3: true,
        brightness: Brightness.dark,
        colorSchemeSeed: Colors.lightBlue,
      ),
      themeMode: ThemeMode.system,
      home: HomeView(),
    );
  }
}
