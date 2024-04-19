import 'package:flutter/material.dart';

import '../widgets/review_stars.dart';

class ProductDetailScreen extends StatelessWidget {
  const ProductDetailScreen({super.key, required this.name});

  final String name;
  @override
  Widget build(BuildContext context) {
    void edit() {}
    return Scaffold(
      appBar: AppBar(
        title: const Text('KREMA UNO'),
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
              Image.asset(
                'assets/images/pravaslika.png',
                width: 400,
                height: 400,
              ),
              const Padding(
                padding: EdgeInsets.all(8),
                child: TextField(
                  maxLines: 3,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    hintText:
                        'jdnkjdj jncjkd d dan jdznfj jhdanfb b dbjs da nhjdnhjv ndsvv ',
                  ),
                ),
              ),
              const Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Padding(
                    padding: EdgeInsets.symmetric(vertical: 10, horizontal: 15),
                    child: Text(
                      '26.70KM',
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                  ),
                ],
              ),
              const Padding(
                padding: EdgeInsets.all(15),
                child: ReviewStars(average: 3.6),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 20, bottom: 10, left: 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    TextButton(
                      onPressed: edit,
                      style: TextButton.styleFrom(
                        padding: const EdgeInsets.symmetric(
                            vertical: 15, horizontal: 50),
                        backgroundColor: Color.fromARGB(255, 145, 228, 163),
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(25),
                        ),
                      ),
                      child: const Text(
                        'Spremi',
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
