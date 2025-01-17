import 'package:book_beauty/widgets/profile_item_card.dart';
import 'package:flutter/material.dart';

class MainDrawer extends StatelessWidget {
  const MainDrawer({
    super.key,
    required this.goToScreen,
  });

  final void Function(String name, int index) goToScreen;

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Center(
        child: Column(
          children: [
            Expanded(
              child: ListView(
                padding: EdgeInsets.zero,
                children: <Widget>[
                  SizedBox(height: 30),
                  ListTile(
                    title: ProfileItemCard(
                      text: 'Pozdrav, Mehdija',
                      icon: Icons.waving_hand,
                    ),
                  ),
                  SizedBox(height: 80),
                  ListTile(
                    title: ProfileItemCard(
                      text: 'Omiljeni proizvodi',
                      icon: Icons.favorite,
                    ),
                    onTap: () {
                      goToScreen('Pocetna', 0);
                      Navigator.pop(context);
                    },
                  ),
                  ListTile(
                      title: ProfileItemCard(
                          text: 'Historija narudzbi',
                          icon: Icons.note_outlined),
                      onTap: () {
                        Navigator.pop(context);
                        goToScreen('narudzbe', 1);
                      }),
                  ListTile(
                    title:
                        ProfileItemCard(text: 'Uredi profil', icon: Icons.edit),
                    onTap: () {
                      Navigator.pop(context);
                      goToScreen('Termini', 2);
                    },
                  ),
                ],
              ),
            ),
            Padding(
              padding: EdgeInsets.only(right: 15, bottom: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  ProfileItemCard(text: 'Odjavi se', icon: Icons.logout)
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
