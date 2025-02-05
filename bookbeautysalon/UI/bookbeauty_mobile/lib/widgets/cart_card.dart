import 'dart:convert';

import 'package:book_beauty/models/order_item.dart';
import 'package:book_beauty/models/product.dart';
import 'package:book_beauty/providers/order_item_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CartCard extends StatelessWidget {
  const CartCard({super.key, required this.product});

  final OrderItem product;

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<OrderItemProvider>(context);

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
                  style: const TextStyle(fontSize: 14),
                ),
                Text(
                  '${product.product!.price}',
                  style: const TextStyle(
                      fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ),
          product.product!.image != null
              ? Image.memory(
                  base64Decode(product.product!
                      .image!), 
                  width: 100,
                  height: 200,
                  fit: BoxFit.cover,
                )
              : Image.asset(
                  "assets/images/logoBB.png", 
                  width: 100,
                  height: 200,
                  fit: BoxFit.cover,
                ),
          Padding(
            padding: const EdgeInsets.only(right: 5),
            child: Row(
              children: [
                IconButton(
                  icon: const Icon(
                    Icons.remove_circle,
                    color: Color.fromARGB(255, 252, 130, 122),
                  ),
                  onPressed: () {
                    provider.decreaseQuantity(product.productId!);
                  },
                ),
                Consumer<OrderItemProvider>(
                  builder: (context, provider, child) {
                    final quantity = provider.getQuantity(product.productId!);
                    return Text(
                      '$quantity',
                      style: const TextStyle(
                          fontSize: 16, fontWeight: FontWeight.w600),
                    );
                  },
                ),
                IconButton(
                  icon: const Icon(
                    Icons.add_circle,
                    color: Color.fromARGB(255, 154, 214, 119),
                  ),
                  onPressed: () {
                    provider.increaseQuantity(product.productId!);
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}







/*class CartCard extends StatefulWidget {
  const CartCard({super.key, required this.product});

  final OrderItem product;

  @override
  State<CartCard> createState() => _CartCardState();
}

class _CartCardState extends State<CartCard> {
  late String quantity = '';

  @override
  void initState() {
    super.initState();
    quantity = widget.product.quantity.toString();
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<OrderItemProvider>(context, listen: false);
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
                  widget.product.product!.name!,
                  style: const TextStyle(
                    fontSize: 14,
                  ),
                ),
                Text(
                  widget.product.product!.price.toString(),
                  style: const TextStyle(
                      fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ),
          Image.network(
            widget.product.product!.image!,
            width: 100,
            height: 80,
          ),
          Padding(
            padding: const EdgeInsets.only(right: 5),
            child: Row(
              children: [
                IconButton(
                  icon: const Icon(Icons.remove_circle,
                      color: Color.fromARGB(255, 252, 130, 122)),
                  onPressed: () {
                    provider.decreaseQuantity(widget.product.productId!);
                  },
                ),
                Text(
                  '${provider.getQuantity(widget.product.productId!)}',
                  style: const TextStyle(
                      fontSize: 16, fontWeight: FontWeight.w600),
                ),
                IconButton(
                  icon: const Icon(Icons.add_circle,
                      color: Color.fromARGB(255, 154, 214, 119)),
                  onPressed: () {
                    provider.increaseQuantity(widget.product.productId!);
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}*/
