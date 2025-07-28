import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/internationalization.dart';
import 'user/home_page/home_page_widget.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await FFLocalizations.initialize(); // so SharedPreferences is ready
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Pakaije Home Test',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      // ✅ Use your generated delegate
      localizationsDelegates: const [
        FFLocalizationsDelegate(),
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: FFLocalizations.languages()
          .map((lang) => createLocale(lang))
          .toList(),
      home: const HomePageWidget(),
    );
  }
}

// Helper if it's not already defined in your file
Locale createLocale(String language) {
  if (language.contains('_')) {
    final parts = language.split('_');
    return Locale(parts[0], parts[1]);
  }
  return Locale(language);
}
