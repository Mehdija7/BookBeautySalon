import 'package:flutter/material.dart';

class OnlinePayment extends StatelessWidget {
  const OnlinePayment({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text(
            'Ukupno: ',
            style: TextStyle(fontSize: 20),
          ),
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: () {},
            child: const Text('PayPal'),
          ),
        ],
      ),
    );
  }
}
