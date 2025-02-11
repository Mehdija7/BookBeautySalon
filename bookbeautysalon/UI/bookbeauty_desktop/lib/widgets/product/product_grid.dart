import 'dart:convert';
import 'dart:typed_data';

import 'package:bookbeauty_desktop/models/product.dart';
import 'package:bookbeauty_desktop/widgets/product/product_text.dart';
import 'package:flutter/material.dart';

class ProductGridItem extends StatelessWidget {
  const ProductGridItem(
      {super.key,
      required this.product,
      required this.activeProduct,
      required this.hideProduct,
      required this.editProduct});

  final Product product;
  final void Function(Product product) activeProduct;
  final void Function(Product product) hideProduct;
  final void Function(Product product) editProduct;
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
                height: 200,
                color: Colors.white,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(0),
                  child: product.image != null
                      ? Image.memory(
                          base64Decode(product
                              .image!), // Assuming it's a Uint8List if not null
                          width: 100,
                          height: 200,
                          fit: BoxFit.cover,
                        )
                      : Image.asset(
                          "assets/images/logoBB.png", // Fallback asset image when image is null
                          width: 100,
                          height: 200,
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
                      product: product,
                      activeProduct: activeProduct,
                      hideProduct: hideProduct,
                      editProduct: editProduct),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
