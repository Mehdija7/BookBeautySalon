import 'package:bookbeauty_desktop/widgets/review_stars.dart';
import 'package:flutter/material.dart';

class ProductItemReview extends StatelessWidget {
  const ProductItemReview({super.key});

  @override
  Widget build(BuildContext context) {
    return const Card(
      child: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: 20,
          vertical: 16,
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Text('Proizvod'),
            Text('Korisnik'),
            ReviewStars(average: 2.3)
          ],
        ),
      ),
    );
  }
}
