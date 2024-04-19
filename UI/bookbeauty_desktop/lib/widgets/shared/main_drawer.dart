import 'package:flutter/material.dart';

class MainDrawer extends StatelessWidget {
  const MainDrawer({
    super.key,
    required this.isAdmin,
    required this.goToScreen,
  });

  final bool isAdmin;
  final void Function(String name, int index) goToScreen;

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          DrawerHeader(
            decoration: BoxDecoration(
              color: Color.fromARGB(255, 69, 71, 73),
            ),
            child: Text(
              isAdmin ? 'ADMIN PANEL' : 'Frizer panel',
              style: TextStyle(
                color: Colors.white,
                fontSize: 24,
              ),
            ),
          ),
          ListTile(
            title: Text('Pocetna'),
            onTap: () {
              goToScreen('Pocetna', 0);
              Navigator.pop(context);
            },
          ),
          ListTile(
              title: Text('Narudzbe'),
              onTap: () {
                Navigator.pop(context);
                goToScreen('narudzbe', 1);
              }),
          ListTile(
            title: Text('Termini'),
            onTap: () {
              Navigator.pop(context);
              goToScreen('Termini', 2);
            },
          ),
          ListTile(
            title: Text('Proizvodi'),
            onTap: () {
              goToScreen('proizvodi', 3);
              Navigator.pop(context);
            },
          ),
          ListTile(
            title: Text('Usluge'),
            onTap: () {
              goToScreen('usluge', 4);
              Navigator.pop(context);
            },
          ),
        ],
      ),
    );
  }
}
