import 'package:book_beauty/screens/products_screen.dart';
import 'package:flutter/material.dart';

class ProfileItemCard extends StatelessWidget {
  const ProfileItemCard({super.key, required this.text, required this.icon});

  final String text;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(top: 30, left: 15),
      child: GestureDetector(
        onTap: () {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (ctx) => const ProductsScreen(
                favoritesOnly: true,
              ),
            ),
          );
        },
        child: Row(
          children: [
            Icon(icon),
            Text(text,
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
          ],
        ),
      ),
    );
  }
}
