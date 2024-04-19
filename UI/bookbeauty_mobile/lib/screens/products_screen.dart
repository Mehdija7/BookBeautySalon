import 'package:book_beauty/screens/productdetail_screen.dart';
import 'package:book_beauty/widgets/product_grid_item.dart';
import 'package:book_beauty/widgets/product_searchbox.dart';
import 'package:book_beauty/widgets/products_title.dart';
import 'package:flutter/material.dart';

class ProductsScreen extends StatefulWidget {
  const ProductsScreen({super.key});

  @override
  State<StatefulWidget> createState() {
    return _ProductsScreen();
  }
}

class _ProductsScreen extends State {
  @override
  Widget build(BuildContext context) {
    void selectingProduct(String name) {
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (ctx) => ProductDetailScreen(name: name),
        ),
      );
    }

    return Column(
      children: [
        const ProductsTitle(),
        const SizedBox(height: 12),
        const Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [ProductSearchBox()],
        ),
        Expanded(
          child: GridView.builder(
            padding: const EdgeInsets.all(10),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              childAspectRatio: 2 / 3,
              crossAxisSpacing: 20,
              mainAxisSpacing: 10,
            ),
            itemCount: 3,
            itemBuilder: (context, index) {
              return ProductGridItem(
                name: 'Krema',
                image: 'assets/images/sisanje.webp',
                onSelectProduct: selectingProduct,
              );
            },
          ),
        ),
      ],
    );
  }
}
