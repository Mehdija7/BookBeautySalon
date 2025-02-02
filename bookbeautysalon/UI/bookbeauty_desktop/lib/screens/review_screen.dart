import 'package:bookbeauty_desktop/models/review.dart';
import 'package:bookbeauty_desktop/providers/review_provider.dart';
import 'package:bookbeauty_desktop/widgets/product/review_stars.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ReviewScreen extends StatefulWidget {
  const ReviewScreen({super.key});

  @override
  State<ReviewScreen> createState() => _ReviewScreenState();
}

class _ReviewScreenState extends State<ReviewScreen> {
  late List<Review> _reviews = [];
  late ReviewProvider _provider;

  bool isLoading = true;

  @override
  void initState() {
    _provider = context.read<ReviewProvider>();
    super.initState();
    _fetchReviews();
  }

  Future<void> _fetchReviews() async {
    try {
      print("RESULT FROM CATEGORIES SCREEN");
      var result = await _provider.get();
      print(result.count);
      print(result.result);
      setState(() {
        _reviews = result.result;
        isLoading = false;
      });
    } catch (e) {
      print(
          "*****************************ERROR MESSAGE $e ***********************************");
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text("Recenzije"),
        ),
        body: isLoading
            ? const CircularProgressIndicator()
            : Expanded(
                child: ListView.builder(
                  itemCount: _reviews.length,
                  itemBuilder: (ctx, index) {
                    return Card(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 20,
                          vertical: 16,
                        ),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Text(_reviews[index].user!.username!),
                            Text(_reviews[index].product!.name!),
                            ReviewStars(
                              average: _reviews[index].mark!.toDouble(),
                            )
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ));
  }
}
