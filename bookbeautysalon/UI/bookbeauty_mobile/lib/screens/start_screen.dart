import 'package:flutter/material.dart';
import '../widgets/home_card.dart';

class StartScreen extends StatelessWidget {
  const StartScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Expanded(
          child: Container(
            decoration: BoxDecoration(
              color: const Color.fromARGB(255, 190, 187, 168).withOpacity(0.4),
            ),
            child: const Padding(
              padding: const EdgeInsets.all(16),
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    const Text(
                      'Pogledajte nase proizvode i usluge',
                      style: TextStyle(fontSize: 18),
                    ),
                    const HomeCard(
                      title: 'Naše usluge',
                      image: 'assets/images/pranje_kose.jpg',
                      id: 1,
                    ),
                    const HomeCard(
                      title: 'Naši proizvodi',
                      image: 'assets/images/proizvodi.jpg',
                      id: 2,
                    ),
                    const SizedBox(height: 6),
                  ],
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
