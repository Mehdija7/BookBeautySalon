import 'package:book_beauty/widgets/product_text.dart';
import 'package:flutter/material.dart';

class ProductGridItem extends StatelessWidget {
  const ProductGridItem(
      {super.key,
      required this.name,
      required this.image,
      required this.onSelectProduct});

  final String name;
  final String image;
  final void Function(String name) onSelectProduct;

  @override
  Widget build(BuildContext context) {
    return Material(
      elevation: 4,
      child: ClipRRect(
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(5),
          topRight: Radius.circular(5),
          bottomLeft: Radius.circular(5),
          bottomRight: Radius.circular(5),
        ),
        clipBehavior: Clip.hardEdge,
        child: InkWell(
          onTap: () {
            onSelectProduct(name);
          },
          child: Container(
            color: const Color.fromARGB(207, 255, 253, 253),
            width: 50,
            height: 300,
            child: Stack(
              children: [
                Container(
                  width: double.infinity,
                  height: 120,
                  color: Colors.white,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(0),
                    child: Image.asset(
                      image,
                      width: 120,
                      height: 120,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                const Positioned(
                  bottom: 20,
                  left: 0,
                  right: 0,
                  child: Center(child: ProductText()),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
