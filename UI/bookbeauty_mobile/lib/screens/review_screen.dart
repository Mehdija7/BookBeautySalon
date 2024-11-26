import 'package:book_beauty/models/review.dart';
import 'package:book_beauty/providers/review_provider.dart';
import 'package:book_beauty/providers/user_provider.dart';
import 'package:flutter/material.dart';

class ReviewScreen extends StatefulWidget {
  const ReviewScreen({super.key, required this.product});

  final int product;

  @override
  State<ReviewScreen> createState() => _ReviewScreenState();
}

class _ReviewScreenState extends State<ReviewScreen> {
  int? _mark;
  final ReviewProvider _reviewProvider = ReviewProvider();

  void _handleReview() async {
    if (_mark == null) {
      _showMessageDialog('Molimo odaberite ocjenu prije potvrde.');
      return;
    }

    Review newReview = Review(
      productId: widget.product,
      userId: UserProvider.globalUserId,
      mark: _mark,
    );
    try {
      await _reviewProvider.insert(newReview);
      Navigator.of(context).pop();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Recenzija uspješno dodana!'),
          backgroundColor: Colors.green,
          duration: const Duration(seconds: 3),
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Greška pri dodavanju recenzije.'),
          backgroundColor: Colors.red,
          duration: const Duration(seconds: 3),
        ),
      );
    }
  }

  void _showMessageDialog(String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Poruka'),
          content: Text(message),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('ok'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final keyboardSpace = MediaQuery.of(context).viewInsets.bottom;
    return LayoutBuilder(
      builder: (ctx, constraints) {
        return SizedBox(
          height: double.infinity,
          child: SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.fromLTRB(16, 48, 16, keyboardSpace + 16),
              child: Column(
                children: [
                  const Text(
                    'Odaberite ocjenu:',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(5, (index) {
                      return IconButton(
                        icon: Icon(
                          Icons.star,
                          color: _mark != null && _mark! > index
                              ? Colors.amber
                              : Colors.grey,
                        ),
                        onPressed: () {
                          setState(() {
                            _mark = index + 1;
                          });
                        },
                      );
                    }),
                  ),
                  const SizedBox(height: 24),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      ElevatedButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        child: const Text(
                          'Odustani',
                          style:
                              TextStyle(color: Color.fromARGB(255, 70, 67, 67)),
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor:
                              const Color.fromARGB(255, 229, 236, 240),
                        ),
                      ),
                      ElevatedButton(
                        onPressed: () {
                          _handleReview();
                        },
                        child: const Text(
                          'Potvrdi',
                          style:
                              TextStyle(color: Color.fromARGB(255, 58, 57, 57)),
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor:
                              const Color.fromARGB(255, 229, 236, 240),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
