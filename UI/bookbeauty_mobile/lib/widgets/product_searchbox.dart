import 'package:flutter/material.dart';

class ProductSearchBox extends StatelessWidget {
  const ProductSearchBox({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.topLeft,
      width: 150,
      height: 40,
      decoration: BoxDecoration(
        color: const Color.fromARGB(255, 255, 255, 255),
        borderRadius: BorderRadius.circular(10),
      ),
      child: const TextField(
        decoration: InputDecoration(
            hintStyle: TextStyle(color: Color.fromARGB(255, 82, 80, 80)),
            prefixIcon:
                Icon(Icons.search, color: Color.fromARGB(255, 56, 56, 56)),
            alignLabelWithHint: true,
            border: InputBorder.none),
      ),
    );
  }
}