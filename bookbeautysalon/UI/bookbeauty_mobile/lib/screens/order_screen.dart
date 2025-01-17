import 'package:book_beauty/widgets/main_title.dart';
import 'package:book_beauty/widgets/order_items.dart';
import 'package:flutter/material.dart';

import '../widgets/buy_button.dart';

class OrderScreen extends StatelessWidget {
  const OrderScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Column(
        children: [
          const MainTitle(title: 'Narudzba'),
          const Padding(
            padding: EdgeInsets.only(left: 10, top: 15, bottom: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Text(
                  "ID narudzbe: 0052",
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ),
          const OrderItems(),
          Padding(
            padding: const EdgeInsets.only(bottom: 20),
            child: BuyButton(
              validateInputs: () {
                return true;
              },
              isFromOrder: true,
            ),
          ),
        ],
      ),
    );
  }
}
