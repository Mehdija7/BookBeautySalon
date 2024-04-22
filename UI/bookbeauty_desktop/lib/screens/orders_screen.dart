import 'package:bookbeauty_desktop/screens/new_orders.dart';
import '../widgets/shared/card.dart';
import 'package:flutter/material.dart';

class OrdersScreen extends StatelessWidget {
  const OrdersScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          GestureDetector(
            onTap: () {
              Navigator.of(context)
                  .push(MaterialPageRoute(builder: (ctx) => NewOrders()));
            },
            child: CardItem(title: 'NOVO', color: Colors.green),
          ),
          CardItem(title: 'SPAKOVANO', color: Colors.orange),
          CardItem(title: 'POSLANO', color: Colors.red)
        ],
      ),
    );
  }
}
