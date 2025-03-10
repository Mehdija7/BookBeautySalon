import 'package:book_beauty/models/user.dart';
import 'package:book_beauty/screens/news_screen.dart';
import 'package:book_beauty/screens/products_screen.dart';
import 'package:book_beauty/screens/profile_screen.dart';
import 'package:book_beauty/screens/services_screen.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

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
      const NewsScreen(),
      const ProductsScreen(
        favoritesOnly: false,
      ),
      ServicesScreen(
        mainTitle: 'Usluge',
      ),
      const ProfileScreen()
    ];
  }

 

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      appBar: AppBar(
        title: Center(
          child: Text(
                    "Book Beauty Salon",
                    style: GoogleFonts.bigShouldersDisplay(
                      fontSize: screenWidth * 0.09, 
                      fontWeight: FontWeight.w400,
                      color: const Color.fromARGB(255, 63, 71, 83),
                    ),
                  ) ,),
        backgroundColor: Color.fromARGB(255, 190, 187, 168),
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
              unselectedItemColor: const Color.fromARGB(255, 83, 97, 109),
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
                    icon: Icon(Icons.shopping_bag), label: ''),
                BottomNavigationBarItem(
                    icon: Icon(Icons.content_cut), label: ''),
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
