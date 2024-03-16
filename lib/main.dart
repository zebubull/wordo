import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:scouting_app/providers/client.dart';
import 'package:scouting_app/providers/server.dart';

import 'views/home.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky)
      .then((_) => runApp(MultiProvider(providers: [
            ChangeNotifierProvider(create: (_) => ClientProvider()),
            ChangeNotifierProvider(create: (_) => ServerProvider()),
          ], child: App())));
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
