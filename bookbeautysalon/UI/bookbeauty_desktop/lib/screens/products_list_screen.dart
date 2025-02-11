import 'package:bookbeauty_desktop/providers/product_provider.dart';
import 'package:bookbeauty_desktop/screens/product_detail_screen.dart';
import '../widgets/product/product_grid.dart';
import '../widgets/product/product_searchbox.dart';
import 'package:flutter/material.dart';
import '../models/product.dart';

class ProductsListScreen extends StatefulWidget {
  const ProductsListScreen({super.key});

  @override
  State<StatefulWidget> createState() {
    return _ProductsListScreen();
  }
}

class _ProductsListScreen extends State {
  late List<Product> _products = [];
  ProductProvider productProvider = ProductProvider();
  bool isLoading = true;
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _searchController.addListener(_onSearchChanged);
    _fetchProducts();
  }

  @override
  void dispose() {
    _searchController.removeListener(_onSearchChanged);
    _searchController.dispose();
    super.dispose();
  }

  void _onSearchChanged() {
    isLoading = true;
    print(
        '+++++++++++++++ METHOD ON SEARCH CHANGED CALLED +++++++++++++++++++ ${_searchController.text}');
    _fetchProducts(name: _searchController.text);
  }

  Future<void> _fetchProducts({String? name}) async {
    if (name == null || name.isEmpty) {
      try {
        var result = await productProvider.get();
        setState(() {
          _products = result.result.cast<Product>();
          isLoading = false;
        });
        print(_products);
      } catch (e) {
        print(
            "*****************************ERROR MESSAGE $e ***********************************");
        setState(() {
          isLoading = false;
        });
      }
    } else {
      var result = await productProvider.get();
      setState(() {
        var p = result.result.cast<Product>();
        print('............... from fetchproducts p .............. $p');
        _products = p
            .where((element) =>
                element.name!.toLowerCase().contains(name.toLowerCase()))
            .toList();
        isLoading = false;
      });
    }
  }

  Future<void> activeProduct(Product product) async {
    await productProvider.activateProduct(product.productId!);
    _fetchProducts();
  }

  Future<void> hideProduct(Product product) async {
    await productProvider.hideProduct(product.productId!);
    _fetchProducts();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _fetchProducts();
  }

  Future<void> editProduct(Product product) async {
    await productProvider.editProduct(product.productId!);
    print("|||||||||||| SUCCEED CHANGE STATE OF PRODUCT ||||||||||||");
    _fetchProducts();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Proizvodi")),
      body: isLoading
          ? const CircularProgressIndicator()
          : Column(
              children: [
                const SizedBox(height: 12),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    ProductSearchBox(titleController: _searchController)
                  ],
                ),
                _products.isEmpty
                    ? const Text("Trenutno nema proizvoda")
                    : Expanded(
                        child: GridView.builder(
                          padding: const EdgeInsets.all(10),
                          gridDelegate:
                              const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 3,
                            childAspectRatio: 4 / 3,
                            crossAxisSpacing: 10,
                            mainAxisSpacing: 10,
                          ),
                          itemCount: _products.length,
                          itemBuilder: (context, index) {
                            return GestureDetector(
                              onTap: () {
                                // Navigate to the ProductDetailScreen with the selected product
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => ProductDetailScreen(
                                        id: _products[index].productId!),
                                  ),
                                );
                              },
                              child: ProductGridItem(
                                product: _products[index],
                                activeProduct: activeProduct,
                                hideProduct: hideProduct,
                                editProduct: editProduct,
                              ),
                            );
                          },
                        ),
                      ),
              ],
            ),
    );
  }
}
