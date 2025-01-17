import 'package:book_beauty/models/product.dart';
import 'package:flutter/material.dart';
import 'package:book_beauty/screens/review_screen.dart';

class ReviewStars extends StatelessWidget {
  const ReviewStars({super.key, required this.average, required this.product});

  final double average;
  final Product product;

  @override
  Widget build(BuildContext context) {
    void openAddReviewOverlay() {
      showModalBottomSheet(
        useSafeArea: true,
        isScrollControlled: true,
        context: context,
        builder: (ctx) => ReviewScreen(
          product: product.productId!,
        ),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(Icons.star,
                color: average >= 1
                    ? const Color.fromARGB(255, 255, 186, 59)
                    : Colors.white),
            Icon(Icons.star,
                color: average >= 1.5
                    ? const Color.fromARGB(255, 255, 186, 59)
                    : Colors.white),
            Icon(Icons.star,
                color: average >= 2.5
                    ? const Color.fromARGB(255, 255, 186, 59)
                    : Colors.white),
            Icon(Icons.star,
                color: average >= 3.5
                    ? const Color.fromARGB(255, 255, 186, 59)
                    : Colors.white),
            Icon(Icons.star,
                color: average >= 4.5
                    ? const Color.fromARGB(255, 255, 186, 59)
                    : Colors.white),
            const SizedBox(
              width: 10,
            ),
            Text(
              average.toString(),
              style: const TextStyle(color: Color.fromARGB(255, 116, 116, 116)),
            ),
            const SizedBox(
              width: 180,
            ),
          ],
        ),
        TextButton(
          onPressed: () {
            openAddReviewOverlay();
          },
          child: const Text(
            'Dodaj recenziju',
            style: TextStyle(color: Color.fromARGB(255, 92, 92, 92)),
          ),
        )
      ],
    );
  }
}
