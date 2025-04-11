import 'package:book_beauty/models/favoriteproduct.dart';
import 'package:book_beauty/models/product.dart';
import 'package:book_beauty/models/search_result.dart';
import 'package:book_beauty/providers/favoriteproduct_provider.dart';
import 'package:book_beauty/providers/user_provider.dart';
import 'package:flutter/material.dart';
import 'package:book_beauty/screens/review_screen.dart';

class ReviewStars extends StatefulWidget {
  const ReviewStars({super.key, required this.average, required this.product});

  final double average;
  final Product product;

  @override
  State<ReviewStars> createState() => _ReviewStarsState();
}

class _ReviewStarsState extends State<ReviewStars> {
  final FavoriteProductProvider _favoriteProductProvider = FavoriteProductProvider();
   late bool fav = false;
    bool isLoading = false;
   @override
  void initState() {
    super.initState();
    _fetchFavorite();
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
    bool newvalue=false;
    print("============== TOGGLE FAV FUNCTION =================");
    print(fav);
    if (fav) {
      print("     entry in delete function         ");
      SearchResult<FavoriteProduct> result =
          await _favoriteProductProvider.get(filter: {
        'ProductId': widget.product.productId.toString(),
        'UserId': UserProvider.globalUserId.toString()
      });
      var data = result.result;
      
      var item = data.first.favoriteProductsId;
      print("=============================== FAVORITEPRODUCTS ID ================================================" );
      await _favoriteProductProvider.toggleFavorite(false);
       setState(() {
      fav = newvalue;
      FavoriteProductProvider.globalIsFavorite=fav;
      isLoading = false;
    });
      var r = await _favoriteProductProvider.delete(item!);
    } else {
      print("     +++  entry in insert function   ====");
      FavoriteProduct newFav = FavoriteProduct(
        addingDate: DateTime.now(),
        userId: UserProvider.globalUserId,
        productId: widget.product.productId,
      );
      await _favoriteProductProvider.insert(newFav);
      await _favoriteProductProvider.toggleFavorite(true);
      newvalue = true;
       setState(() {
      fav = newvalue;
      FavoriteProductProvider.globalIsFavorite=fav;
      isLoading = false;
    });
    }
   
    print("-----------    state changed -----------");
    print(fav);
    
    
  }

  @override
  Widget build(BuildContext context) {
    void openAddReviewOverlay() {
      showModalBottomSheet(
        useSafeArea: true,
        isScrollControlled: true,
        context: context,
        builder: (ctx) => ReviewScreen(
          product: widget.product.productId!,
        ),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Icon(Icons.star,
                color: widget.average >= 1
                    ? const Color.fromARGB(255, 255, 186, 59)
                    : Colors.white),
            Icon(Icons.star,
                color: widget.average >= 1.5
                    ? const Color.fromARGB(255, 255, 186, 59)
                    : Colors.white),
            Icon(Icons.star,
                color: widget.average >= 2.5
                    ? const Color.fromARGB(255, 255, 186, 59)
                    : Colors.white),
            Icon(Icons.star,
                color: widget.average >= 3.5
                    ? const Color.fromARGB(255, 255, 186, 59)
                    : Colors.white),
            Icon(Icons.star,
                color: widget.average >= 4.5
                    ? const Color.fromARGB(255, 255, 186, 59)
                    : Colors.white),
            const SizedBox(
              width: 10,
            ),
            Text(
              widget.average.toStringAsFixed(2),
              style: const TextStyle(color: Color.fromARGB(255, 116, 116, 116)),
            ),
             SizedBox(
              width:130,
            ),
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
        ),
        TextButton(
          onPressed: () {
            openAddReviewOverlay();
          },
          child: const Text(
            'Add review',
            style: TextStyle(color: Color.fromARGB(255, 92, 92, 92)),
          ),
        )
      ],
    );
  }
}
