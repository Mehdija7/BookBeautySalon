import 'package:bookbeauty_desktop/screens/login_screen.dart';
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
            decoration: const BoxDecoration(
              color: Color.fromARGB(255, 69, 71, 73),
            ),
            child: Text(
              isAdmin ? 'ADMIN PANEL' : 'Frizer panel',
              style: const TextStyle(
                color: Colors.white,
                fontSize: 24,
              ),
            ),
          ),
          ListTile(
            title: const Text('Pocetna'),
            onTap: () {
              goToScreen('Pocetna', 0);
              Navigator.pop(context);
            },
          ),
          ListTile(
              title: const Text('Narudzbe'),
              onTap: () {
                Navigator.pop(context);
                goToScreen('Narudzbe', 1);
              }),
          ListTile(
            title: const Text('Termini'),
            onTap: () {
              Navigator.pop(context);
              goToScreen('Termini', 2);
            },
          ),
          ListTile(
            title: const Text('Proizvodi'),
            onTap: () {
              goToScreen('Proizvodi', 3);
              Navigator.pop(context);
            },
          ),
          ListTile(
            title: const Text('Usluge'),
            onTap: () {
              goToScreen('Usluge', 4);
              Navigator.pop(context);
            },
          ),
          ListTile(
            title: const Text('Kategorije'),
            onTap: () {
              goToScreen('Kategorije', 5);
              Navigator.pop(context);
            },
          ),
          ListTile(
            title: const Text('Novosti'),
            onTap: () {
              goToScreen('Novosti', 6);
              Navigator.pop(context);
            },
          ),
          isAdmin
              ? ListTile(
                  title: const Text('Frizeri'),
                  onTap: () {
                    goToScreen('Frizeri', 7);
                    Navigator.pop(context);
                  },
                )
              : const SizedBox(height: 50),
          const SizedBox(
            height: 100,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              TextButton.icon(
                onPressed: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => LoginScreen(),
                    ),
                  );
                },
                icon: const Icon(Icons.logout),
                label: const Text('Odjava'),
                style: TextButton.styleFrom(),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
