import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

// Import your app's files
import 'lib/backend/firebase/firebase_config.dart';
import 'lib/flutter_flow/flutter_flow_theme.dart';
import 'lib/flutter_flow/flutter_flow_util.dart';
import 'lib/flutter_flow/internationalization.dart';
import 'lib/user/home_page/home_page_widget.dart';
import 'lib/auth/firebase_auth/auth_util.dart';
import 'lib/auth/firebase_auth/firebase_user_provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Initialize Firebase
  await initFirebase();
  
  runApp(TestHomePageApp());
}

class TestHomePageApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Test Home Page - Pakaije',
      debugShowCheckedModeBanner: false,
      localizationsDelegates: [
        FFLocalizationsDelegate(),
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [
        Locale.fromSubtags(languageCode: 'zh', scriptCode: 'Hans'),
        Locale('en'),
      ],
      theme: ThemeData(
        brightness: Brightness.light,
        useMaterial3: false,
      ),
      home: TestHomePage(),
    );
  }
}

class TestHomePage extends StatefulWidget {
  @override
  _TestHomePageState createState() => _TestHomePageState();
}

class _TestHomePageState extends State<TestHomePage> {
  bool _firebaseInitialized = false;
  bool _authInitialized = false;
  String _firebaseStatus = 'Checking...';
  String _authStatus = 'Checking...';
  String _firestoreStatus = 'Checking...';
  User? _currentUser;

  @override
  void initState() {
    super.initState();
    _checkFirebaseConnection();
  }

  Future<void> _checkFirebaseConnection() async {
    try {
      // Check Firebase initialization
      if (Firebase.apps.isNotEmpty) {
        setState(() {
          _firebaseInitialized = true;
          _firebaseStatus = '✅ Firebase initialized successfully';
        });

        // Check Firebase Auth
        _currentUser = FirebaseAuth.instance.currentUser;
        setState(() {
          _authInitialized = true;
          if (_currentUser != null) {
            _authStatus = '✅ User authenticated: ${_currentUser!.email ?? 'Anonymous'}';
          } else {
            _authStatus = '⚠️ No user authenticated (Guest mode)';
          }
        });

        // Test Firestore connection
        try {
          await FirebaseFirestore.instance
              .collection('test')
              .limit(1)
              .get()
              .timeout(Duration(seconds: 5));
          setState(() {
            _firestoreStatus = '✅ Firestore connection working';
          });
        } catch (e) {
          setState(() {
            _firestoreStatus = '⚠️ Firestore connection: ${e.toString()}';
          });
        }
      } else {
        setState(() {
          _firebaseStatus = '❌ Firebase not initialized';
        });
      }
    } catch (e) {
      setState(() {
        _firebaseStatus = '❌ Firebase error: ${e.toString()}';
      });
    }
  }

  Future<void> _signInAnonymously() async {
    try {
      UserCredential userCredential = await FirebaseAuth.instance.signInAnonymously();
      setState(() {
        _currentUser = userCredential.user;
        _authStatus = '✅ Anonymous user signed in: ${_currentUser!.uid}';
      });
    } catch (e) {
      setState(() {
        _authStatus = '❌ Anonymous sign-in failed: ${e.toString()}';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Test Home Page - Firebase Connection'),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Firebase Status Card
            Card(
              child: Padding(
                padding: EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Firebase Connection Status',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 12),
                    Text(_firebaseStatus),
                    SizedBox(height: 8),
                    Text(_authStatus),
                    SizedBox(height: 8),
                    Text(_firestoreStatus),
                    SizedBox(height: 12),
                    if (!_authInitialized || _currentUser == null)
                      ElevatedButton(
                        onPressed: _signInAnonymously,
                        child: Text('Sign In Anonymously for Testing'),
                      ),
                  ],
                ),
              ),
            ),
            
            SizedBox(height: 20),
            
            // Navigation Buttons
            Card(
              child: Padding(
                padding: EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Test Navigation',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 12),
                    Row(
                      children: [
                        Expanded(
                          child: ElevatedButton(
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => HomePageWidget(),
                                ),
                              );
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.green,
                              foregroundColor: Colors.white,
                            ),
                            child: Text('Open Home Page'),
                          ),
                        ),
                        SizedBox(width: 12),
                        Expanded(
                          child: ElevatedButton(
                            onPressed: _checkFirebaseConnection,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.orange,
                              foregroundColor: Colors.white,
                            ),
                            child: Text('Refresh Status'),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            
            SizedBox(height: 20),
            
            // Firebase Project Info
            Card(
              child: Padding(
                padding: EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Firebase Project Information',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 12),
                    Text('Project ID: pakaije-89pzxl'),
                    Text('Auth Domain: pakaije-89pzxl.firebaseapp.com'),
                    Text('Storage Bucket: pakaije-89pzxl.firebasestorage.app'),
                    SizedBox(height: 8),
                    Text(
                      'This test app will help you verify:',
                      style: TextStyle(fontWeight: FontWeight.w600),
                    ),
                    Text('• Firebase initialization'),
                    Text('• Authentication status'),
                    Text('• Firestore connectivity'),
                    Text('• Home page functionality'),
                  ],
                ),
              ),
            ),
            
            SizedBox(height: 20),
            
            // Instructions
            Card(
              color: Colors.blue.shade50,
              child: Padding(
                padding: EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Testing Instructions',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.blue.shade800,
                      ),
                    ),
                    SizedBox(height: 12),
                    Text(
                      '1. Check the Firebase connection status above\n'
                      '2. If needed, sign in anonymously for testing\n'
                      '3. Click "Open Home Page" to test the actual page\n'
                      '4. Verify that all UI elements load correctly\n'
                      '5. Test navigation buttons in the home page\n'
                      '6. Check if data loads from Firebase backend',
                      style: TextStyle(color: Colors.blue.shade700),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}