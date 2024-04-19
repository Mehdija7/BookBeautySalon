import 'package:book_beauty/widgets/buy_button.dart';
import 'package:book_beauty/widgets/cart_card.dart';
import 'package:flutter/material.dart';
import '../widgets/main_title.dart';

class CartScreen extends StatelessWidget {
  const CartScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('')),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const MainTitle(title: 'Korpa'),
          Expanded(
            child: ListView(
              children: const [
                CartCard(),
                CartCard(),
                CartCard(),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Padding(
                      padding: EdgeInsets.only(top: 5, right: 15, bottom: 15),
                      child: Text(
                        'Ukupno: 213111 KM',
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(bottom: 30),
            child: BuyButton(
              validateInputs: () {
                return true;
              },
              isFromOrder: false,
            ),
          ),
        ],
      ),
    );
  }
}
