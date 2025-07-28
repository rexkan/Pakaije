import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'flutter_flow/nav/nav.dart'; // import your router setup
import '/index.dart'; // for CreateAccountWidget

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  // Disable splash for testing
  AppStateNotifier.instance.stopShowingSplashImage();

  runApp(MyTestApp());
}

class MyTestApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'CreateAccount Test',
      debugShowCheckedModeBanner: false,
      home: CreateAccountWidget(), // directly show the page
    );
  }
}
