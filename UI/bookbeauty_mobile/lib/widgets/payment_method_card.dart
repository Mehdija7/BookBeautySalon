import 'package:book_beauty/screens/payment_screen.dart';
import 'package:flutter/material.dart';

class PaymentMethodCard extends StatelessWidget {
  const PaymentMethodCard(
      {super.key, required this.method, required this.icon});

  final String method;
  final IconData icon;
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.of(context).push(
          MaterialPageRoute(builder: (ctx) => const PaymentScreen()),
        );
      },
      child: SizedBox(
        width: 150,
        height: 150,
        child: Card(
          margin: const EdgeInsets.all(10),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          clipBehavior: Clip.hardEdge,
          elevation: 2,
          child: Center(
            child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    icon,
                    color: icon == Icons.payment_rounded
                        ? const Color.fromARGB(255, 129, 170, 204)
                        : const Color.fromARGB(255, 118, 211, 121),
                  ),
                  Text(
                    method,
                    style: const TextStyle(
                      fontSize: 20,
                      color: Colors.grey,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ]),
          ),
        ),
      ),
    );
  }
}
