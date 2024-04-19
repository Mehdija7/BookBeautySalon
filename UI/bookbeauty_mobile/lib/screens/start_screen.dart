import 'package:flutter/material.dart';
import '../widgets/home_card.dart';

class StartScreen extends StatelessWidget {
  const StartScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 10, top: 30),
            child: Text(
              "Spremni za",
              style: Theme.of(context).textTheme.titleLarge!.copyWith(
                  color: Theme.of(context).colorScheme.onBackground,
                  fontWeight: FontWeight.bold),
            ),
          ),
          const SizedBox(
            height: 2,
          ),
          Padding(
            padding: const EdgeInsets.only(left: 10, top: 2, bottom: 20),
            child: Text(
              "PROMJENU",
              style: Theme.of(context).textTheme.titleLarge!.copyWith(
                    color: Theme.of(context).colorScheme.onBackground,
                    fontSize: 30,
                  ),
            ),
          ),
          const HomeCard(
              title: 'Naše usluge',
              image: 'assets/images/pranje_kose.jpg',
              id: 1),
          const HomeCard(
            title: 'Naš tim',
            image: 'assets/images/haidressers.jpg',
            id: 2,
          )
        ],
      ),
    );
  }
}
