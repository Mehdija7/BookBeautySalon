import 'package:bookbeauty_desktop/models/product.dart';
import 'package:bookbeauty_desktop/widgets/shared/buttons_list.dart';
import 'package:flutter/material.dart';

class ProductText extends StatelessWidget {
  const ProductText(
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
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 2, horizontal: 5),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                product.name!,
                style: const TextStyle(fontSize: 16, color: Colors.black),
              ),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(left: 5),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Text(
                '${product.price!.toStringAsFixed(2)} BAM',
                style:
                    const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(left: 10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              ButtonsList(
                  product: product,
                  activeProduct: activeProduct,
                  hideProduct: hideProduct,
                  editProduct: editProduct)
            ],
          ),
        ),
      ],
    );
  }
}
