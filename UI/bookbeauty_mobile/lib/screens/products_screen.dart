import 'package:book_beauty/models/product.dart';
import 'package:book_beauty/providers/product_provider.dart';
import 'package:book_beauty/screens/productdetail_screen.dart';
import 'package:book_beauty/widgets/product_grid_item.dart';
import 'package:book_beauty/widgets/product_searchbox.dart';
import 'package:book_beauty/widgets/products_title.dart';
import 'package:flutter/material.dart';

class ProductsScreen extends StatefulWidget {
  const ProductsScreen({super.key, required this.favoritesOnly});

  final bool favoritesOnly;

  @override
  State<StatefulWidget> createState() {
    return _ProductsScreen();
  }
}

class _ProductsScreen extends State<ProductsScreen> {
  late List<Product> _registeredProducts = [];
  late bool isLoading = true;
  final ProductProvider productProvider = ProductProvider();

  @override
  void initState() {
    super.initState();
    _fetchProducts();
  }

  Future<void> _fetchProducts() async {
    try {
      List<Product> result = await productProvider.getMobile();
      setState(() {
        _registeredProducts = result;
        isLoading = false;
      });
    } catch (e) {
      print(
          "*****************************ERROR MESSAGE $e ***********************************");
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    void selectingProduct(Product product) {
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (ctx) => ProductDetailScreen(product: product),
        ),
      );
    }

    return Scaffold(
      backgroundColor:
          const Color.fromARGB(255, 190, 187, 168).withOpacity(0.4),
      body: Column(
        children: [
          const SizedBox(
            height: 16,
          ),
          const ProductsTitle(),
          const SizedBox(height: 12),
          const Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [ProductSearchBox()],
          ),
          Expanded(
            child: isLoading
                ? const Center(child: CircularProgressIndicator())
                : GridView.builder(
                    padding: const EdgeInsets.all(10),
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      childAspectRatio: 2 / 3,
                      crossAxisSpacing: 20,
                      mainAxisSpacing: 10,
                    ),
                    itemCount: _registeredProducts.length,
                    itemBuilder: (context, index) {
                      final product = _registeredProducts[index];
                      return ProductGridItem(
                        product: product,
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
