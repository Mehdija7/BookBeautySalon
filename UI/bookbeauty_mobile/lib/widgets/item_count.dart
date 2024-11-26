import 'package:flutter/material.dart';

class ItemCount extends StatelessWidget {
  const ItemCount({super.key, required this.count});

  final String count;
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const Icon(Icons.remove_circle,
            color: Color.fromARGB(255, 252, 130, 122)),
        Text(
          count,
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
        ),
        const Icon(Icons.add_circle, color: Color.fromARGB(255, 154, 214, 119))
      ],
    );
  }
}
