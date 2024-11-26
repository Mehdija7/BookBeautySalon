import 'package:book_beauty/models/favorite.dart';
import 'package:book_beauty/models/product.dart';
import 'package:book_beauty/models/search_result.dart';
import 'package:book_beauty/providers/favorite_provider.dart';
import 'package:book_beauty/providers/order_item_provider.dart';
import 'package:book_beauty/providers/product_provider.dart';
import 'package:book_beauty/providers/user_provider.dart';
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
  final FavoriteProvider favoriteProvider = FavoriteProvider();
  final OrderItemProvider orderItemProvider = OrderItemProvider();

  @override
  void initState() {
    _fetchProducts();
    super.initState();
  }

  Future<void> _fetchProducts() async {
    setState(() {
      isLoading = true;
    });

    if (widget.favoritesOnly) {
      try {
        var filter = {
          'userId': UserProvider.globalUserId.toString(),
        };

        SearchResult<Favorite> result =
            (await favoriteProvider.get(filter: filter));

        List<Product> productList =
            result.result.map((item) => item.product!).toList();

        setState(() {
          _registeredProducts = productList;
          isLoading = false;
        });
      } catch (e) {
        print(
            "*****************************ERROR MESSAGE $e ***********************************");
        setState(() {
          isLoading = false;
        });
      }
    } else {
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
      backgroundColor: widget.favoritesOnly
          ? const Color.fromARGB(255, 190, 187, 168).withOpacity(0.4)
          : const Color.fromARGB(255, 218, 215, 201),
      body: Column(
        children: [
          const SizedBox(
            height: 16,
          ),
          widget.favoritesOnly
              ? const SizedBox(
                  height: 2,
                )
              : const ProductsTitle(),
          const SizedBox(height: 12),
          const Row(
            mainAxisAlignment: MainAxisAlignment.center,
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
                          f: widget.favoritesOnly);
                    },
                  ),
          ),
        ],
      ),
    );
  }
}
