import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:scouting_app/models/server/server.dart';
import 'package:scouting_app/models/server/team_store.dart';
import 'package:scouting_app/providers/client.dart';
import 'package:scouting_app/widgets/error_dialog.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:watch_it/watch_it.dart';

import 'views/home.dart';

final navigatorKey = GlobalKey<NavigatorState>();
Directory? dataPath;

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
  Future<void> _loadDataPath() async {
    final prefs = await SharedPreferences.getInstance();
    var path = prefs.getString('dataPath');
    if (path == null) {
      ErrorDialog.show('No data path',
          'Please select a folder to act as the root data directory for the application.',
          () async {
        final result = await FilePicker.platform.getDirectoryPath(
            dialogTitle: 'Select a folder', lockParentWindow: true);
        if (result == null) {
          ErrorDialog.show(
              'No folder selected',
              'Data will not be saved until you restart the application and select a save path.',
              () {});
          return;
        }
        prefs.setString('dataPath', result);
        dataPath = Directory(result);
      });
    } else {
      dataPath = Directory(path);
    }
  }

  @override
  void initState() {
    super.initState();
    _loadDataPath();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      navigatorKey: navigatorKey,
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
