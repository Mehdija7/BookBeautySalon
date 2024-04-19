import 'package:bookbeauty_desktop/widgets/product_item_review.dart';
import 'package:bookbeauty_desktop/widgets/product_review_items.dart';
import 'package:flutter/material.dart';

class ReviewScreen extends StatelessWidget {
  const ReviewScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Recenzije"),
        ),
        body: ProductReviewItems(
            image: 'assets/images/pravaslika.png', name: 'Proizvod'));
  }
}
