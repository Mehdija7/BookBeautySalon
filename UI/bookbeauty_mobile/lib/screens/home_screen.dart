import 'package:book_beauty/screens/appointment_screen.dart';
import 'package:book_beauty/screens/products_screen.dart';
import 'package:book_beauty/screens/profile_screen.dart';
import 'package:book_beauty/screens/start_screen.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 238, 238, 238),
        title: Text(
          'Book Beauty',
          style: Theme.of(context).textTheme.titleMedium!.copyWith(
              color: Theme.of(context).colorScheme.onBackground,
              fontWeight: FontWeight.bold,
              fontSize: 18,
              fontStyle: FontStyle.italic),
        ),
        centerTitle: true,
      ),
      body: _widgetOptions.elementAt(_selectedIndex),
      bottomNavigationBar: createBottombar(context),
    );
  }

  final _widgetOptions = [
    const StartScreen(),
    const ProductsScreen(),
    const AppointmentScreen(),
    const ProfileScreen()
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  ClipRRect createBottombar(BuildContext context) {
    return ClipRRect(
      borderRadius: const BorderRadius.only(
        topRight: Radius.circular(20),
        topLeft: Radius.circular(20),
      ),
      child: Stack(
        children: [
          BottomNavigationBar(
              onTap: _onItemTapped,
              currentIndex: _selectedIndex,
              unselectedItemColor: const Color.fromARGB(255, 167, 170, 170),
              selectedItemColor: Colors.white,
              type: BottomNavigationBarType.fixed,
              backgroundColor: const Color.fromARGB(255, 43, 41, 41),
              iconSize: 24,
              items: const [
                BottomNavigationBarItem(
                    backgroundColor: Color.fromARGB(255, 44, 45, 46),
                    icon: Icon(Icons.home_rounded, size: 30),
                    label: ''),
                BottomNavigationBarItem(
                    icon: Icon(
                      Icons.shopping_basket,
                    ),
                    label: ''),
                BottomNavigationBarItem(
                    icon: Icon(Icons.calendar_month), label: ''),
                BottomNavigationBarItem(icon: Icon(Icons.person), label: ''),
              ]),
          Positioned(
            bottom: 0,
            left: MediaQuery.of(context).size.width / 4 * _selectedIndex +
                MediaQuery.of(context).size.width / 8 -
                34,
            width: 70,
            child: Container(
              height: 4,
              decoration: BoxDecoration(
                  color: Colors.white, borderRadius: BorderRadius.circular(4)),
              margin: const EdgeInsets.only(bottom: 20),
            ),
          )
        ],
      ),
    );
  }
}