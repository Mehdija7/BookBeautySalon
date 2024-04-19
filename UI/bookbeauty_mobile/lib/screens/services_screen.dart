import 'package:book_beauty/widgets/main_title.dart';
import 'package:book_beauty/widgets/service_card.dart';
import 'package:flutter/material.dart';

class ServicesScreen extends StatelessWidget {
  const ServicesScreen({super.key, required this.mainTitle});

  final String mainTitle;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(''),
        forceMaterialTransparency: true,
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          MainTitle(title: mainTitle),
          Expanded(
            child: ListView(
              children: const [
                ServiceCard(
                  service: 'Šišanje',
                  image: 'assets/images/sisanje.webp',
                ),
                ServiceCard(
                  service: 'Feniranje',
                  image: 'assets/images/sisanje.webp',
                ),
                ServiceCard(
                  service: 'Frizure',
                  image: 'assets/images/sisanje.webp',
                ),
                ServiceCard(
                  service: 'Frizure',
                  image: 'assets/images/sisanje.webp',
                ),
                ServiceCard(
                  service: 'Frizure',
                  image: 'assets/images/sisanje.webp',
                ),
                ServiceCard(
                  service: 'Frizure',
                  image: 'assets/images/sisanje.webp',
                ),
                ServiceCard(
                  service: 'Frizure',
                  image: 'assets/images/sisanje.webp',
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
