import 'package:book_beauty/models/favoriteproduct.dart';
import 'package:book_beauty/models/product.dart';
import 'package:book_beauty/models/search_result.dart';
import 'package:book_beauty/providers/favoriteproduct_provider.dart';
import 'package:book_beauty/providers/order_item_provider.dart';
import 'package:book_beauty/providers/product_provider.dart';
import 'package:book_beauty/providers/user_provider.dart';
import 'package:book_beauty/screens/productdetail_screen.dart';
import 'package:book_beauty/widgets/product_grid_item.dart';
import 'package:book_beauty/widgets/products_title.dart';
import 'package:book_beauty/widgets/product_searchbox.dart';
import 'package:flutter/material.dart';

class ProductsScreen extends StatefulWidget {
  const ProductsScreen({super.key, required this.favoritesOnly});

  final bool favoritesOnly;

  @override
  State<StatefulWidget> createState() => _ProductsScreenState();
}

class _ProductsScreenState extends State<ProductsScreen> {
  late List<Product> _allProducts = [];
  late List<Product> _filteredProducts = [];
  final ProductProvider productProvider = ProductProvider();
  final FavoriteProductProvider _favoriteProductProvider =
      FavoriteProductProvider();
  final TextEditingController searchController = TextEditingController();
  bool isLoading = true;

  @override
  void initState() {
    _fetchProducts();
    searchController.addListener(_filterProducts);
    super.initState();
  }

  @override
  void dispose() {
    searchController.removeListener(_filterProducts);
    searchController.dispose();
    super.dispose();
  }

  Future<void> _fetchProducts() async {
    setState(() {
      isLoading = true;
    });

    try {
      if (widget.favoritesOnly) {
        var filter = {'userId': UserProvider.globalUserId.toString()};
        SearchResult<FavoriteProduct> result =
            await _favoriteProductProvider.get(filter: filter);
        _allProducts = result.result.map((item) => item.product!).toList();
      } else {
        var result = await productProvider.get();
        _allProducts = result.result;
      }
      _filteredProducts = _allProducts;
    } catch (e) {
      print("Error fetching products: $e");
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  void _filterProducts() {
    final query = searchController.text.toLowerCase();
    setState(() {
      _filteredProducts = _allProducts
          .where((product) =>
              product.name!.toLowerCase().contains(query) ||
              product.description!.toLowerCase().contains(query))
          .toList();
    });
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
      /*  appBar: AppBar(
        title: widget.favoritesOnly
            ? const Text("Favorites")
            : const Text("Products"),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _fetchProducts,
          ),
        ],
      ),*/
      body: Column(
        children: [
          const SizedBox(height: 16),
          if (!widget.favoritesOnly) const ProductsTitle(),
          const SizedBox(height: 12),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10.0),
            child: ProductSearchBox(
              key: const Key("search-box"),
              child: TextField(
                controller: searchController,
                decoration: const InputDecoration(
                  hintText: "Trazi..",
                ),
              ),
            ),
          ),
          const SizedBox(height: 10),
          Expanded(
            child: isLoading
                ? const Center(child: CircularProgressIndicator())
                : _filteredProducts.isEmpty
                    ? const Center(child: Text("No products available."))
                    : GridView.builder(
                        padding: const EdgeInsets.all(10),
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          childAspectRatio: 2 / 3,
                          crossAxisSpacing: 20,
                          mainAxisSpacing: 10,
                        ),
                        itemCount: _filteredProducts.length,
                        itemBuilder: (context, index) {
                          final product = _filteredProducts[index];
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
