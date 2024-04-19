import 'package:bookbeauty_desktop/widgets/product_text.dart';
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
        child: Container(
          color: const Color.fromARGB(207, 255, 253, 253),
          width: 50,
          height: 100,
          child: Stack(
            children: [
              Container(
                width: double.infinity,
                height: 100,
                color: Colors.white,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(0),
                  child: Image.asset(
                    image,
                    width: 100,
                    height: 100,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              Positioned(
                bottom: 20,
                left: 0,
                right: 0,
                child: Center(
                  child: ProductText(
                    name: name,
                    onSelectProduct: onSelectProduct,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
