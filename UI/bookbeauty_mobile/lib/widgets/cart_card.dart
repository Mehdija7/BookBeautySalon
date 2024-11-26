import 'package:book_beauty/models/order_item.dart';
import 'package:book_beauty/models/product.dart';
import 'package:book_beauty/widgets/item_count.dart';
import 'package:flutter/material.dart';

class CartCard extends StatelessWidget {
  const CartCard({super.key, required this.product});

  final OrderItem product;

  @override
  Widget build(BuildContext context) {
    var count = product.quantity!.toString();
    return Card(
      margin: const EdgeInsets.all(10),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      clipBehavior: Clip.hardEdge,
      elevation: 2,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  product.product!.name!,
                  style: const TextStyle(
                    fontSize: 14,
                  ),
                ),
                Text(
                  product.product!.price.toString(),
                  style: const TextStyle(
                      fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ),
          Image.network(
            product.product!.image!,
            width: 100,
            height: 80,
          ),
          Padding(
            padding: const EdgeInsets.only(right: 5),
            child: ItemCount(count: count),
          )
        ],
      ),
    );
  }
}
