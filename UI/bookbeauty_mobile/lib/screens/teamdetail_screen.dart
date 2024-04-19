import 'package:book_beauty/widgets/main_title.dart';
import 'package:flutter/material.dart';

class TeamDetailScreen extends StatelessWidget {
  const TeamDetailScreen({super.key, required this.name, required this.image});

  final String name;
  final String image;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(''),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            MainTitle(title: name),
            const SizedBox(height: 14),
            Image.asset(
              image,
              height: 300,
              width: double.infinity,
              fit: BoxFit.cover,
            ),
            Padding(
                padding: const EdgeInsets.only(left: 2, top: 15, bottom: 20),
                child: Container(
                  color: const Color.fromARGB(255, 174, 186, 189),
                  child: Text(
                    'ashbdhcndsh ajndvjhzfbaskh jabdjabv hdbfhjdsb hj dshj fads       dsfdsfnkjdasnv d jdsnfjdsfn ',
                    style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                )),
          ],
        ),
      ),
    );
  }
}
