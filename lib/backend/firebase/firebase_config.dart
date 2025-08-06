import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';

Future initFirebase() async {
  if (kIsWeb) {
    await Firebase.initializeApp(
        options: FirebaseOptions(
            apiKey: "AIzaSyAbjPEX-cMwxO1nWH0Q4S48GokY3_q-fk4",
            authDomain: "pakaije-89pzxl.firebaseapp.com",
            projectId: "pakaije-89pzxl",
            storageBucket: "pakaije-89pzxl.firebasestorage.app",
            messagingSenderId: "1024515856953",
            appId: "1:1024515856953:web:edad6348780905d9e10be8"));
  } else {
    await Firebase.initializeApp();
  }
}
