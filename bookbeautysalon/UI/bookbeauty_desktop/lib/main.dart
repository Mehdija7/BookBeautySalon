import 'package:bookbeauty_desktop/screens/login_screen.dart';
import 'package:bookbeauty_desktop/screens/orders_screen.dart'; // Import your OrdersScreen
import 'package:flutter/material.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:provider/provider.dart';
import 'package:bookbeauty_desktop/providers/user_provider.dart';
import 'package:bookbeauty_desktop/providers/gender_provider.dart';
import 'package:bookbeauty_desktop/providers/appointment_provider.dart';
import 'package:bookbeauty_desktop/providers/category_provider.dart';
import 'package:bookbeauty_desktop/providers/order_item_provider.dart';
import 'package:bookbeauty_desktop/providers/order_provider.dart';
import 'package:bookbeauty_desktop/providers/product_provider.dart';
import 'package:bookbeauty_desktop/providers/review_provider.dart';
import 'package:bookbeauty_desktop/providers/service_provider.dart';
import 'package:bookbeauty_desktop/providers/transaction_provider.dart';

// Create the RouteObserver instance
final RouteObserver<PageRoute> routeObserver = RouteObserver<PageRoute>();

void main() async {
  await initializeDateFormatting('bs'); // Set up the locale
  runApp(MultiProvider(
    providers: [
      ChangeNotifierProvider(create: (_) => UserProvider()),
      ChangeNotifierProvider(create: (_) => GenderProvider()),
      ChangeNotifierProvider(create: (_) => AppointmentProvider()),
      ChangeNotifierProvider(create: (_) => CategoryProvider()),
      ChangeNotifierProvider(create: (_) => OrderItemProvider()),
      ChangeNotifierProvider(create: (_) => OrderProvider()),
      ChangeNotifierProvider(create: (_) => ProductProvider()),
      ChangeNotifierProvider(create: (_) => ReviewProvider()),
      ChangeNotifierProvider(create: (_) => ServiceProvider()),
      ChangeNotifierProvider(create: (_) => TransactionProvider()),
    ],
    child: const MyApp(),
  ));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Book Beauty',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(
              seedColor: const Color.fromARGB(255, 91, 100, 107)),
          useMaterial3: true,
        ),
        navigatorObservers: [routeObserver],
        home: LoginScreen(),
        );
  }
}
