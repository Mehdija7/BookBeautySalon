import 'package:bookbeauty_desktop/screens/product_detail_screen.dart';
import 'package:bookbeauty_desktop/widgets/product_grid.dart';
import 'package:bookbeauty_desktop/widgets/product_searchbox.dart';
import 'package:flutter/material.dart';

class ProductsListScreen extends StatefulWidget {
  const ProductsListScreen({super.key});

  @override
  State<StatefulWidget> createState() {
    return _ProductsListScreen();
  }
}

class _ProductsListScreen extends State {
  @override
  Widget build(BuildContext context) {
    void selectingProduct(String name) {
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (ctx) => ProductDetailScreen(name: name),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(title: Text("Proizvodi")),
      body: Column(
        children: [
          const SizedBox(height: 12),
          const Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [ProductSearchBox()],
          ),
          Expanded(
            child: GridView.builder(
              padding: const EdgeInsets.all(10),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                childAspectRatio: 4 / 3,
                crossAxisSpacing: 10,
                mainAxisSpacing: 10,
              ),
              itemCount: 7,
              itemBuilder: (context, index) {
                return ProductGridItem(
                  name: 'Krema',
                  image: 'assets/images/pravaslika.png',
                  onSelectProduct: selectingProduct,
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
