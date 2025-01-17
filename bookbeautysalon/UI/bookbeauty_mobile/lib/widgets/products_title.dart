import 'package:book_beauty/screens/cart_screen.dart';
import 'package:flutter/material.dart';

class ProductsTitle extends StatelessWidget {
  const ProductsTitle({super.key});

  @override
  Widget build(BuildContext context) {
    void goToCart() {
      Navigator.of(context).push(
        MaterialPageRoute(builder: (ctx) => const CartScreen()),
      );
    }

    return Padding(
      padding: const EdgeInsets.only(left: 5, right: 5, top: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Text(
            'Proizvodi',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          IconButton(
            onPressed: goToCart,
            icon: const Icon(
              Icons.shopping_bag_outlined,
              size: 30,
            ),
          ),
        ],
      ),
    );
  }
}
