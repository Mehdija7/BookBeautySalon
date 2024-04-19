import 'package:book_beauty/widgets/item_count.dart';
import 'package:flutter/material.dart';

class CartCard extends StatelessWidget {
  const CartCard({super.key});

  @override
  Widget build(BuildContext context) {
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
          const Padding(
            padding: EdgeInsets.only(left: 10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Serum Hemedy',
                  style: TextStyle(
                    fontSize: 14,
                  ),
                ),
                Text(
                  '34.70KM',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ),
          Image.asset(
            'assets/images/sisanje.webp',
            width: 100,
            height: 80,
          ),
          const Padding(
            padding: EdgeInsets.only(right: 5),
            child: ItemCount(),
          )
        ],
      ),
    );
  }
}
