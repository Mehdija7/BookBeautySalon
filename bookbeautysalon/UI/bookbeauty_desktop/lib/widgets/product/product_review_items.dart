import 'package:bookbeauty_desktop/widgets/product/product_item_review.dart';
import 'package:flutter/material.dart';

class ProductReviewItems extends StatelessWidget {
  const ProductReviewItems({super.key, required this.name});

  final String name;
  @override
  Widget build(BuildContext context) {
    return const Column(
      children: [ProductItemReview(), ProductItemReview(), ProductItemReview()],
    );
  }
}
