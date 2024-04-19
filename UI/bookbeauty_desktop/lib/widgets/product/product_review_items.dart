import 'package:bookbeauty_desktop/widgets/product_item_review.dart';
import 'package:flutter/material.dart';

class ProductReviewItems extends StatelessWidget {
  const ProductReviewItems(
      {super.key, required this.image, required this.name});

  final String name;
  final String image;
  @override
  Widget build(BuildContext context) {
    return const Column(
      children: [ProductItemReview(), ProductItemReview(), ProductItemReview()],
    );
  }
}
