import 'package:flutter/material.dart';

class ProductSearchBox extends StatelessWidget {
  const ProductSearchBox({super.key, required TextField child});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(left: 10, right: 10),
      alignment: Alignment.center,
      width: 350,
      height: 40,
      decoration: BoxDecoration(
        color: const Color.fromARGB(255, 248, 249, 250),
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
