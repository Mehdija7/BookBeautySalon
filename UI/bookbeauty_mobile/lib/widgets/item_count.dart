import 'package:flutter/material.dart';

class ItemCount extends StatelessWidget {
  const ItemCount({super.key});

  @override
  Widget build(BuildContext context) {
    return const Row(
      children: [
        Icon(Icons.remove_circle, color: Color.fromARGB(255, 252, 130, 122)),
        Text(
          '1',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
        ),
        Icon(Icons.add_circle, color: Color.fromARGB(255, 154, 214, 119))
      ],
    );
  }
}
