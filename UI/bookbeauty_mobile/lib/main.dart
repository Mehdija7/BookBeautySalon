import 'package:book_beauty/screens/home_screen.dart';
import 'package:book_beauty/screens/login_screen.dart';
import 'package:book_beauty/screens/registration_screen.dart';
import 'package:book_beauty/screens/start_screen.dart';
import 'package:book_beauty/screens/test.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

final theme =
    ThemeData(useMaterial3: true, textTheme: GoogleFonts.openSansTextTheme());

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        localizationsDelegates: GlobalMaterialLocalizations.delegates,
        supportedLocales: const [
          Locale('en', 'US'),
          Locale('bs'),
        ],
        locale: const Locale('bs'),
        theme: theme,
        home: const LoginScreen());
  }
}
