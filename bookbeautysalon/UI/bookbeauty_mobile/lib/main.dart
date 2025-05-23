import 'package:book_beauty/providers/order_item_provider.dart';
import 'package:book_beauty/providers/order_provider.dart';
import 'package:book_beauty/providers/transaction_provider.dart';
import 'package:book_beauty/screens/login_screen.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:provider/provider.dart';

final theme =
    ThemeData(useMaterial3: true, textTheme: GoogleFonts.openSansTextTheme());

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => OrderItemProvider()),
        ChangeNotifierProvider(create: (_) => OrderProvider()),
        ChangeNotifierProvider(create: (_) => TransactionProvider()),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        localizationsDelegates: GlobalMaterialLocalizations.delegates,
        supportedLocales: const [
          Locale('en', 'US'),
        ],
        theme: theme,
        home: const LoginScreen());
  }
}
