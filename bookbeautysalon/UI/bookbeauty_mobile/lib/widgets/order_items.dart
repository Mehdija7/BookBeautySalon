import 'package:flutter/material.dart';
import 'order_item.dart';

class OrderItems extends StatelessWidget {
  const OrderItems({super.key});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: ListView(
        children: [
          const OrderItem(),
          const OrderItem(),
          const OrderItem(),
          const OrderItem(),
          Container(
            height: 2,
            decoration: BoxDecoration(
                color: Colors.black, borderRadius: BorderRadius.circular(4)),
            margin: const EdgeInsets.only(bottom: 10),
          ),
          const Padding(
            padding: EdgeInsets.only(left: 5, bottom: 10),
            child: Row(
              children: [
                Text(
                  "Ukupno: 58.20KM",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
