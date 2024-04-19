import 'package:book_beauty/screens/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

final theme = ThemeData(
    useMaterial3: true,
    // colorScheme: const ColorScheme(
    //     brightness: Brightness.dark,
    //     primary: Color.fromARGB(255, 58, 63, 63),
    //     onPrimary: Color.fromARGB(248, 255, 255, 255),
    //     secondary: Color.fromARGB(195, 245, 248, 250),
    //     onSecondary: Color.fromARGB(255, 2, 2, 2),
    //     error: Color.fromARGB(255, 233, 85, 85),
    //     onError: Color.fromARGB(255, 112, 103, 103),
    //     background: Colors.white,
    //     onBackground: Colors.black,
    //     surface: Color.fromARGB(255, 163, 164, 165),
    //     onSurface: Colors.black),
    textTheme: GoogleFonts.openSansTextTheme());

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        localizationsDelegates: const <LocalizationsDelegate<Object>>[
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
        ],
        supportedLocales: const <Locale>[
          Locale('en', 'US'),
          Locale('bs'),
        ],
        locale: const Locale('bs'),
        theme: theme,
        home: const HomeScreen());
  }
}
