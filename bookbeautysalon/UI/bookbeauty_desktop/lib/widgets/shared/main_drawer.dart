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
              isAdmin ? 'Administrator' : 'Hairdresser',
              style: const TextStyle(
                color: Colors.white,
                fontSize: 24,
              ),
            ),
          ),
          ListTile(
            title: const Text('Reports'),
            onTap: () {
              goToScreen('Reports', 0);
              Navigator.pop(context);
            },
          ),
          ListTile(
              title: const Text('Orders'),
              onTap: () {
                Navigator.pop(context);
                goToScreen('Orders', 1);
              }),
          ListTile(
            title: const Text('Appointments'),
            onTap: () {
              Navigator.pop(context);
              goToScreen('Appointments', 2);
            },
          ),
          ListTile(
            title: const Text('Products'),
            onTap: () {
              goToScreen('Products', 3);
              Navigator.pop(context);
            },
          ),
          ListTile(
            title: const Text('Services'),
            onTap: () {
              goToScreen('Services', 4);
              Navigator.pop(context);
            },
          ),
          ListTile(
            title: const Text('Categories'),
            onTap: () {
              goToScreen('Categories', 5);
              Navigator.pop(context);
            },
          ),
          ListTile(
            title: const Text('News'),
            onTap: () {
              goToScreen('News', 6);
              Navigator.pop(context);
            },
          ),
          isAdmin
              ? ListTile(
                  title: const Text('Haidressers'),
                  onTap: () {
                    goToScreen('Haidressers', 7);
                    Navigator.pop(context);
                  },
                )
              : const SizedBox(height: 50),
          const SizedBox(
            height: 60,
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
                label: const Text('Log out'),
                style: TextButton.styleFrom(),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
