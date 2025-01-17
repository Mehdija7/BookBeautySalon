import 'package:book_beauty/models/user.dart';
import 'package:book_beauty/screens/appointment_screen.dart';
import 'package:book_beauty/screens/products_screen.dart';
import 'package:book_beauty/screens/profile_screen.dart';
import 'package:book_beauty/screens/start_screen.dart';
import 'package:book_beauty/widgets/maindrawer.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key, required this.user});

  final User user;

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;
  String maintitle = 'Pocetna';
  late List<Widget> _widgetOptions;

  @override
  void initState() {
    super.initState();
    _widgetOptions = [
      const StartScreen(),
      const ProductsScreen(
        favoritesOnly: true,
      ),
      AppointmentScreen(userId: widget.user.userId!),
      const ProfileScreen()
    ];
  }

  void _setScreen(String title, int index) {
    setState(() {
      maintitle = title;
    });
  }

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Center(
          child: Image.asset(
            'assets/images/logoBB3.jpg',
            fit: BoxFit.cover,
            width: MediaQuery.of(context).size.width,
            height: 100,
          ),
        ),
        backgroundColor: Color.fromARGB(255, 190, 187, 168).withOpacity(0.4),
        key: _scaffoldKey,
        automaticallyImplyLeading: false,
      ),
      body: _widgetOptions.elementAt(_selectedIndex),
      bottomNavigationBar: createBottombar(context),
    );
  }

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
              unselectedItemColor: const Color.fromARGB(255, 92, 110, 110),
              selectedItemColor: Colors.white,
              type: BottomNavigationBarType.fixed,
              backgroundColor: const Color.fromARGB(255, 196, 189, 171),
              iconSize: 24,
              items: const [
                BottomNavigationBarItem(
                    backgroundColor: Color.fromARGB(255, 44, 45, 46),
                    icon: Icon(Icons.home_rounded, size: 30),
                    label: ''),
                BottomNavigationBarItem(
                    icon: Icon(
                      Icons.favorite,
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
