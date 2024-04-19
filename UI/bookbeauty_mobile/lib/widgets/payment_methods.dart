import 'package:book_beauty/widgets/payment_method_card.dart';
import 'package:flutter/material.dart';

class PaymentMethods extends StatelessWidget {
  const PaymentMethods({super.key});

  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.only(top: 20, left: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Nacin placanja: ",
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              PaymentMethodCard(
                  method: "Karticno", icon: (Icons.payment_rounded)),
              PaymentMethodCard(
                  method: "Pouzecem", icon: Icons.delivery_dining_outlined),
            ],
          )
        ],
      ),
    );
  }
}
