import 'package:book_beauty/screens/order_screen.dart';
import 'package:book_beauty/screens/successful_screen.dart';
import 'package:flutter/material.dart';

class BuyButton extends StatelessWidget {
  const BuyButton(
      {super.key, required this.validateInputs, required this.isFromOrder});

  final bool Function() validateInputs;
  final bool isFromOrder;
  @override
  Widget build(BuildContext context) {
    void buy() {
      if (validateInputs()) {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (ctx) => const OrderScreen(),
          ),
        );
      }
      if (isFromOrder) {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (ctx) => const SuccessfulScreen(),
          ),
        );
      }
    }

    return TextButton(
      onPressed: buy,
      style: TextButton.styleFrom(
        padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 50),
        backgroundColor: const Color.fromARGB(255, 41, 40, 40),
        foregroundColor: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
      ),
      child: const Text(
        'Kupi',
        textAlign: TextAlign.center,
        style: TextStyle(fontSize: 16),
      ),
    );
  }
}
