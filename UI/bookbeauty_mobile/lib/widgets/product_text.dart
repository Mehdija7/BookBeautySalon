import 'package:book_beauty/models/favorite.dart';
import 'package:book_beauty/models/order_item.dart';
import 'package:book_beauty/models/product.dart';
import 'package:book_beauty/models/search_result.dart';
import 'package:book_beauty/providers/favorite_provider.dart';
import 'package:book_beauty/providers/order_item_provider.dart';
import 'package:book_beauty/providers/user_provider.dart';
import 'package:flutter/material.dart';

class ProductText extends StatefulWidget {
  const ProductText({super.key, required this.product});

  final Product product;

  @override
  State<ProductText> createState() => _ProductTextState();
}

class _ProductTextState extends State<ProductText> {
  late bool fav = false;
  bool isLoading = true;
  final FavoriteProvider _favoriteProvider = FavoriteProvider();

  @override
  void initState() {
    fetchFavorite();
    super.initState();
  }

  Future<void> fetchFavorite() async {
    setState(() {
      isLoading = true;
    });
    try {
      var user = UserProvider.globalUserId!;
      print(
          "************************************************ user *******************************************");
      print(user);
      print(
          "************************************************ widget.product.productId *******************************************");
      print(widget.product.productId);
      var b =
          await _favoriteProvider.isProductFav(widget.product.productId!, user);
      print(
          "************************************************ b *******************************************");
      print(b);
      setState(() {
        fav = b;
      });
    } catch (e) {
      print("Error in fetchFavorite: $e");
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  Future<void> addToFavorite() async {
    setState(() {
      isLoading = true;
    });
    try {
      if (fav) {
        var filter = {
          'userId': UserProvider.globalUserId,
          'productId': widget.product.productId
        };
        SearchResult<Favorite> result =
            (await _favoriteProvider.get(filter: filter));

        var obj = result.result.first;
        print(
            " -----------------+++++++++++++++++++++++   obj    ++++++++++++++++++++++++++++----------------------");
        await _favoriteProvider.delete(obj.favoriteProductsId);
      } else {
        Favorite newFav = Favorite(
          addingDate: DateTime.now(),
          userId: UserProvider.globalUserId,
          productId: widget.product.productId,
        );
        await _favoriteProvider.insert(newFav);
      }
    } catch (e) {
      print("Error in addToFavorite: $e");
    } finally {
      setState(() {
        fav = !fav;
        isLoading = false;
      });
    }
  }

  void buy() {
    OrderItem item = OrderItem(productId: widget.product.productId);
    OrderItemProvider.addOrderItem(item);

    for (var orderItem in OrderItemProvider.orderItems) {
      print('OrderItem - Product ID: ${orderItem.productId}');
    }
  }

  @override
  Widget build(BuildContext context) {
    return isLoading
        ? const Center(child: CircularProgressIndicator())
        : Column(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 2, horizontal: 5),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      widget.product.name!,
                      style: const TextStyle(fontSize: 16, color: Colors.black),
                    ),
                    IconButton(
                      icon: Icon(
                        Icons.favorite,
                        size: 20,
                        color: fav
                            ? const Color.fromARGB(255, 233, 83, 83)
                            : const Color.fromARGB(137, 158, 158, 158),
                      ),
                      onPressed: addToFavorite,
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 5),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text(
                      '${widget.product.price!} BAM',
                      style: const TextStyle(
                          fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    TextButton(
                      onPressed: buy,
                      style: TextButton.styleFrom(
                        padding: const EdgeInsets.symmetric(
                            vertical: 10, horizontal: 30),
                        backgroundColor:
                            const Color.fromARGB(255, 134, 165, 185),
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      child: const Text(
                        'Kupi',
                        textAlign: TextAlign.center,
                      ),
                    ),
                    const Icon(
                      Icons.star,
                      color: Color.fromARGB(255, 255, 192, 74),
                    ),
                  ],
                ),
              ),
            ],
          );
  }
}
