import 'package:bookbeauty_desktop/screens/new_product_screen.dart';
import 'package:bookbeauty_desktop/screens/products_list_screen.dart';
import '../widgets/shared/card.dart';
import 'package:flutter/material.dart';

class ProductsScreen extends StatelessWidget {
  const ProductsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          GestureDetector(
            onTap: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (ctx) => const NewProductScreen(),
                ),
              );
            },
            child: const CardItem(
              title: 'Dodaj novi proizvod',
              color: Color.fromARGB(255, 158, 228, 93),
            ),
          ),
          GestureDetector(
            onTap: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (ctx) => const ProductsListScreen(),
                ),
              );
            },
            child: const CardItem(
              title: 'Pregled proizvoda',
              color: Color.fromARGB(255, 250, 196, 125),
            ),
          ),
        ],
      ),
    );
  }
}
