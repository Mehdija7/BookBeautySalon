import 'package:bookbeauty_desktop/models/order.dart';
import 'package:bookbeauty_desktop/screens/appointment_screen.dart';
import 'package:bookbeauty_desktop/screens/categories_screen.dart';
import 'package:bookbeauty_desktop/screens/hairdresser_screen.dart';
import 'package:bookbeauty_desktop/screens/news_screen.dart';
import 'package:bookbeauty_desktop/screens/orders_screen.dart';
import 'package:bookbeauty_desktop/screens/products_screen.dart';
import 'package:bookbeauty_desktop/screens/reports_screen.dart';
import 'package:bookbeauty_desktop/screens/services_screen.dart';
import 'package:flutter/material.dart';
import '../widgets/shared/main_drawer.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key, required this.isAdmin});

  final bool isAdmin;

  @override
  State<StatefulWidget> createState() {
    return _HomeScreen();
  }
}

class _HomeScreen extends State<HomeScreen> {
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
    const ServicesScreen(),
    const CategoriesScreen(),
    const NewsScreen(),
    const HairdresserScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: Text(maintitle)),
        drawer: MainDrawer(
          isAdmin: widget.isAdmin,
          goToScreen: _setScreen,
        ),
        body: _widgetOptions.elementAt(_selectedPageIndex));
  }
}
