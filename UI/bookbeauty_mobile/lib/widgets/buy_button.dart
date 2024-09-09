import 'package:book_beauty/screens/order_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_paypal_payment/flutter_paypal_payment.dart';

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
        {
          Navigator.of(context).push(MaterialPageRoute(
            builder: (BuildContext context) => PaypalCheckoutView(
              sandboxMode: true,
              clientId: "YOUR_CLIENT_ID",
              secretKey: "YOUR_SECRET_KEY",
              transactions: const [
                {
                  "amount": {
                    "total": '100',
                    "currency": "USD",
                    "details": {
                      "subtotal": '100',
                      "shipping": '0',
                      "shipping_discount": 0
                    }
                  },
                  "description": "Sample payment transaction",
                  "item_list": {
                    "items": [
                      {
                        "name": "Sample Item",
                        "quantity": 1,
                        "price": '100',
                        "currency": "USD"
                      }
                    ]
                  }
                }
              ],
              note: "Thank you for your purchase!",
              onSuccess: (Map params) {
                print("Payment Success: $params");
                Navigator.pop(context);
              },
              onError: (error) {
                print("Payment Error: $error");
                Navigator.pop(context);
              },
              onCancel: () {
                print("Payment Canceled");
                Navigator.pop(context);
              },
            ),
          ));
        }
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
