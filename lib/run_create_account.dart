import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'flutter_flow/nav/nav.dart'; // import your router setup
// import 'flutter_flow/flutter_flow_theme.dart'; // for theme if needed

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  runApp(MyTestApp());
}

class MyTestApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final appStateNotifier = AppStateNotifier.instance;

    return MaterialApp.router(
      title: 'CreateAccount Test',
      routerConfig: createRouter(appStateNotifier),
      debugShowCheckedModeBanner: false,
      theme: ThemeData(),
    );
  }
}
