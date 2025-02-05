import 'dart:convert';

import 'package:book_beauty/models/favoriteproduct.dart';
import 'package:book_beauty/models/product.dart';
import 'package:book_beauty/models/search_result.dart';
import 'package:book_beauty/providers/favoriteproduct_provider.dart';
import 'package:book_beauty/providers/order_item_provider.dart';
import 'package:book_beauty/providers/review_provider.dart';
import 'package:book_beauty/providers/user_provider.dart';
import 'package:book_beauty/widgets/main_title.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../widgets/review_stars.dart';

class ProductDetailScreen extends StatefulWidget {
  const ProductDetailScreen({super.key, required this.product});

  final Product product;

  @override
  State<ProductDetailScreen> createState() => _ProductDetailScreenState();
}

class _ProductDetailScreenState extends State<ProductDetailScreen> {
  final ReviewProvider _reviewProvider = ReviewProvider();
  double rating = 0.0;
  final FavoriteProductProvider _favoriteProductProvider =
      FavoriteProductProvider();
  late bool fav = false;
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    _fetchFavorite();
    _fetchAverage();
  }

  void buy() {
    final provider = Provider.of<OrderItemProvider>(context, listen: false);
    provider.addProduct(widget.product);
  }

  void _fetchAverage() async {
    var r = await _reviewProvider.getAverageRating(widget.product.productId!);
    setState(() {
      rating = r;
    });
  }

  Future<void> _fetchFavorite() async {
    try {
      var user = UserProvider.globalUserId!;
      var favoriteStatus = await _favoriteProductProvider.isProductFav(
          widget.product.productId!, user);
      print(
          "+++++++++++++++++++++++++++++++++++++++++++++ GLOBAL FAVORITE ID ++++++++++++++++++++++++++");
      print(FavoriteProductProvider.globalIsFavorite);
      setState(() {
        fav = favoriteStatus;
      });
    } catch (e) {
      print("Error in fetchFavoriteProductProduct: $e");
    }
  }

  Future<void> toggleFav() async {
    setState(() {
      isLoading = true;
    });
    if (fav) {
      SearchResult<FavoriteProduct> result =
          await _favoriteProductProvider.get(filter: {
        'ProductId': widget.product.productId.toString(),
        'UserId': UserProvider.globalUserId.toString()
      });
      var data = result.result;

      var item = data.first.favoriteProductsId;
      await _favoriteProductProvider.delete(item!);
      await _favoriteProductProvider.toggleFavorite(false);
    } else {
      FavoriteProduct newFav = FavoriteProduct(
        addingDate: DateTime.now(),
        userId: UserProvider.globalUserId,
        productId: widget.product.productId,
      );
      await _favoriteProductProvider.insert(newFav);
      await _favoriteProductProvider.toggleFavorite(true);
    }
    setState(() {
      fav = FavoriteProductProvider.globalIsFavorite!;
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return isLoading
        ? const Center(child: CircularProgressIndicator())
        : Scaffold(
            appBar: AppBar(
              title: const Text(''),
              backgroundColor: const Color.fromARGB(157, 201, 198, 198),
            ),
            body: Container(
              height: MediaQuery.of(context).size.height,
              padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 0),
              color: const Color.fromARGB(157, 201, 198, 198),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    MainTitle(title: widget.product.name!),
                    widget.product.image != null
                        ? Image.memory(
                            base64Decode(widget.product
                                .image!), // Assuming it's a Uint8List if not null
                            width: 100,
                            height: 200,
                            fit: BoxFit.cover,
                          )
                        : Image.asset(
                            "assets/images/logoBB.png", // Fallback asset image when image is null
                            width: 100,
                            height: 200,
                            fit: BoxFit.cover,
                          ),
                    Padding(
                        padding: const EdgeInsets.all(5),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            ReviewStars(
                                average: rating, product: widget.product),
                            IconButton(
                              icon: Icon(Icons.favorite,
                                  size: 20,
                                  color: fav
                                      ? const Color.fromARGB(255, 233, 83, 83)
                                      : Colors.grey),
                              onPressed: () {
                                toggleFav();
                              },
                            ),
                          ],
                        )),
                    Padding(
                      padding: const EdgeInsets.all(8),
                      child: Text(
                        widget.product.description!,
                        style: const TextStyle(
                            fontSize: 14, fontWeight: FontWeight.bold),
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              vertical: 10, horizontal: 15),
                          child: Text(
                            '${widget.product.price} BAM',
                            style: const TextStyle(
                                fontSize: 20, fontWeight: FontWeight.bold),
                          ),
                        ),
                      ],
                    ),
                    Padding(
                      padding:
                          const EdgeInsets.only(top: 20, bottom: 10, left: 10),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          TextButton(
                            onPressed: buy,
                            style: TextButton.styleFrom(
                              padding: const EdgeInsets.symmetric(
                                  vertical: 15, horizontal: 50),
                              backgroundColor:
                                  const Color.fromARGB(255, 134, 165, 185),
                              foregroundColor: Colors.white,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(25),
                              ),
                            ),
                            child: const Text(
                              'Kupi',
                              textAlign: TextAlign.center,
                              style: TextStyle(fontSize: 18),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
  }
}
