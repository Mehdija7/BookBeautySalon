import 'package:bookbeauty_desktop/screens/appointment_screen.dart';
import 'package:bookbeauty_desktop/screens/orders_screen.dart';
import 'package:bookbeauty_desktop/screens/products_screen.dart';
import 'package:bookbeauty_desktop/screens/reports_screen.dart';
import 'package:bookbeauty_desktop/screens/services_screen.dart';
import 'package:bookbeauty_desktop/widgets/main_drawer.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<StatefulWidget> createState() {
    return _HomeScreen();
  }
}

class _HomeScreen extends State {
  int _selectedPageIndex = 0;
  String maintitle = 'Pocetna';

  void _setScreen(String title, int index) {
    setState(() {
      maintitle = title;
      _selectedPageIndex = index;
    });
  }

  final _widgetOptions = [
    const ReportsScreen(),
    const OrdersScreen(),
    const AppointmentScreen(),
    const ProductsScreen(),
    const ServicesScreen()
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: Text(maintitle)),
        drawer: MainDrawer(
          isAdmin: false,
          goToScreen: _setScreen,
        ),
        body: _widgetOptions.elementAt(_selectedPageIndex));
  }
}
