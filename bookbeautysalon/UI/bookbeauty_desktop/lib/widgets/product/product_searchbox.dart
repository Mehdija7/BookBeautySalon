import 'package:flutter/material.dart';

class ProductSearchBox extends StatelessWidget {
  const ProductSearchBox({super.key, required this.titleController});

  final TextEditingController titleController;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        alignment: Alignment.center,
        width: 600,
        height: 40,
        decoration: BoxDecoration(
          color: const Color.fromARGB(255, 255, 255, 255),
          borderRadius: BorderRadius.circular(10),
        ),
        child: TextField(
          controller: titleController,
          decoration: const InputDecoration(
              hintStyle: TextStyle(color: Color.fromARGB(255, 82, 80, 80)),
              prefixIcon:
                  Icon(Icons.search, color: Color.fromARGB(255, 56, 56, 56)),
              alignLabelWithHint: true,
              border: InputBorder.none),
        ),
      ),
    );
  }
}
