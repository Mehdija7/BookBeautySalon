import 'package:flutter/material.dart';

class ReviewStars extends StatelessWidget {
  const ReviewStars({super.key, required this.average});

  final double average;
  @override
  Widget build(BuildContext context) {
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
            const Icon(Icons.favorite_border_outlined),
          ],
        ),
        const Text(
          'Dodaj recenziju',
          style: TextStyle(color: Color.fromARGB(255, 92, 92, 92)),
        ),
      ],
    );
  }
}
