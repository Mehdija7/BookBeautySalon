import 'package:book_beauty/models/product.dart';
import 'package:book_beauty/providers/review_provider.dart';
import 'package:book_beauty/widgets/main_title.dart';
import 'package:flutter/material.dart';

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
  @override
  void initState() {
    super.initState();
    _fetchAverage();
  }

  void _fetchAverage() async {
    var r = await _reviewProvider.getAverageRating(widget.product.productId!);
    setState(() {
      rating = r;
    });
  }

  @override
  Widget build(BuildContext context) {
    void buy() {}
    return Scaffold(
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
              Image.network(widget.product.image!),
              Padding(
                padding: const EdgeInsets.all(15),
                child: ReviewStars(average: rating, product: widget.product),
              ),
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
                padding: const EdgeInsets.only(top: 20, bottom: 10, left: 10),
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
