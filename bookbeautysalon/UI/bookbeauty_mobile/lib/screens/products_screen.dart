import 'package:book_beauty/models/favoriteproduct.dart';
import 'package:book_beauty/models/product.dart';
import 'package:book_beauty/models/search_result.dart';
import 'package:book_beauty/providers/favoriteproduct_provider.dart';
import 'package:book_beauty/providers/product_provider.dart';
import 'package:book_beauty/providers/user_provider.dart';
import 'package:book_beauty/screens/productdetail_screen.dart';
import 'package:book_beauty/widgets/product_grid_item.dart';
import 'package:book_beauty/widgets/products_title.dart';
import 'package:flutter/material.dart';

class ProductsScreen extends StatefulWidget {
  const ProductsScreen({super.key, required this.favoritesOnly});

  final bool favoritesOnly;

  @override
  State<StatefulWidget> createState() => _ProductsScreenState();
}

class _ProductsScreenState extends State<ProductsScreen> {
  List<Product> _allProducts = [];
  List<Product> _filteredProducts = [];
  final ProductProvider productProvider = ProductProvider();
  final FavoriteProductProvider _favoriteProductProvider = FavoriteProductProvider();
  final TextEditingController searchController = TextEditingController();
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchProducts();
    searchController.addListener(_filterProducts);
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
        SearchResult<FavoriteProduct> result = await _favoriteProductProvider.get(filter: filter);
        _allProducts = result.result.map((item) => item.product!).toList();
      } else {
        var result = await productProvider.get();
        _allProducts = result.result;
      }
      _filteredProducts = List.from(_allProducts); 
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
      _filteredProducts = _allProducts.where((product) =>
          product.name!.toLowerCase().contains(query) ||
          product.description!.toLowerCase().contains(query)).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
   void selectingProduct(Product product) async {
  await Navigator.of(context).push(
    MaterialPageRoute(
      builder: (ctx) => ProductDetailScreen(product: product),
    ),
  );

  _fetchProducts();
}

    return Scaffold(
      backgroundColor: !widget.favoritesOnly
          ? const Color.fromARGB(255, 190, 187, 168).withOpacity(0.4)
          : const Color.fromARGB(255, 215, 214, 211),
      appBar: widget.favoritesOnly
          ? AppBar(
              backgroundColor: const Color.fromARGB(255, 190, 187, 168),
              leading: IconButton(
                icon: const Icon(Icons.arrow_back),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
              title: const Text("Favorite products"),
            )
          : null,
      body: Column(
        children: [
          const SizedBox(height: 16),
          if (!widget.favoritesOnly) const ProductsTitle(),
          const SizedBox(height: 12),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10.0),
            child: !widget.favoritesOnly
                ? Container(
                    padding: const EdgeInsets.only(left: 10, right: 10),
                    alignment: Alignment.center,
                    width: 350,
                    height: 40,
                    decoration: BoxDecoration(
                      color: const Color.fromARGB(255, 248, 249, 250),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: TextField(
                      controller: searchController,
                      decoration: const InputDecoration(
                        hintText: "Search products...",
                        hintStyle: TextStyle(color: Color.fromARGB(255, 82, 80, 80)),
                        prefixIcon: Icon(Icons.search, color: Color.fromARGB(255, 56, 56, 56)),
                        alignLabelWithHint: true,
                        border: InputBorder.none,
                      ),
                    ),
                  )
                : const SizedBox(height: 10),
          ),
          const SizedBox(height: 10),
          Expanded(
            child: isLoading
                ? const Center(child: CircularProgressIndicator())
                : _filteredProducts.isEmpty
                    ? const Center(child: Text("There is no available products."))
                    : GridView.builder(
                        padding: const EdgeInsets.all(10),
                        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
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
