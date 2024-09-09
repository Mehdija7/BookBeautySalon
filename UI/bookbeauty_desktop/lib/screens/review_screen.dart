import '../widgets/product/product_review_items.dart';
import 'package:flutter/material.dart';

class ReviewScreen extends StatelessWidget {
  const ReviewScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Recenzije"),
      ),
      body: const ProductReviewItems(name: 'Proizvod'),
    );
  }
}
