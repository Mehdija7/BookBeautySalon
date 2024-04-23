import 'package:book_beauty/widgets/customer_info.dart';
import 'package:book_beauty/widgets/customer_info_item.dart';
import 'package:flutter/material.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  int _selectedPageIndex = 0;
  String maintitle = 'Pocetna';

  void _setScreen(String title, int index) {
    setState(() {
      maintitle = title;
      _selectedPageIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Padding(
            padding: EdgeInsets.symmetric(vertical: 15),
            child: ClipOval(
              child: Image.asset(
                'assets/images/sisanje.webp',
                width: 200,
                height: 200,
                fit: BoxFit.cover,
              ),
            ),
          ),
          Text('Mehdija Sekic'),
          SizedBox(height: 50),
          CustomerInfoItem(title: 'Ime: ', value: 'Mehdija'),
          CustomerInfoItem(title: 'Prezime:', value: 'Sekic'),
          CustomerInfoItem(title: 'Grad:', value: 'Sanski Most'),
          CustomerInfoItem(title: 'Adresa:', value: 'Sanski Most'),
          CustomerInfoItem(title: 'Broj telefona:', value: 'Sanski Most')
        ],
      ),
    );
  }
}
