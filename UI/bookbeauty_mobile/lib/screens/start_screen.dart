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
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: ListView(
                children: const [
                  Text(
                    'Dobro dosli u aplikaciju BookBeauty, pogledajte nase usluge i proizvode.',
                    style: TextStyle(
                      fontSize: 18,
                    ),
                  ),
                  HomeCard(
                    title: 'Naše usluge',
                    image: 'assets/images/pranje_kose.jpg',
                    id: 1,
                  ),
                  HomeCard(
                    title: 'Naši proizvodi',
                    image: 'assets/images/proizvodi.jpg',
                    id: 2,
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
