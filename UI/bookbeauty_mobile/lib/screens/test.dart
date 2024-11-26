import 'package:book_beauty/screens/review_screen.dart';
import 'package:flutter/material.dart';

class TestScreen extends StatelessWidget {
  const TestScreen({super.key});

  @override
  Widget build(BuildContext context) {
    void _openAddReviewOverlay() {
      showModalBottomSheet(
        useSafeArea: true,
        isScrollControlled: true,
        context: context,
        builder: (ctx) => ReviewScreen(
          product: 1022,
        ),
      );
    }

    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 161, 154, 133),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          TextButton(
              onPressed: () {
                _openAddReviewOverlay();
              },
              child: Text('dodaj recenziju'))
        ],
      ),
    );
  }
}
