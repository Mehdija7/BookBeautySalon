/*import '../widgets/order/customer_info.dart';
import '../widgets/shared/main_title.dart';
import '../widgets/order/order_items.dart';
import 'package:flutter/material.dart';

class NewOrderScreen extends StatelessWidget {
  const NewOrderScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Column(
        children: [
          const MainTitle(title: 'Narudzba'),
          const Padding(
            padding: EdgeInsets.only(left: 20, top: 15, bottom: 10),
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
          const Expanded(child: CustomerInfo()),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.only(bottom: 20),
                child: ElevatedButton(
                  onPressed: () {},
                  style: ButtonStyle(
                    backgroundColor: WidgetStateProperty.resolveWith<Color?>(
                      (Set<WidgetState> states) {
                        if (states.contains(WidgetState.pressed)) {
                          return const Color.fromARGB(255, 130, 206, 147);
                        }
                        return const Color.fromARGB(255, 172, 247, 150);
                      },
                    ),
                    foregroundColor: WidgetStateProperty.all<Color>(
                        const Color.fromARGB(255, 245, 245, 245)),
                  ),
                  child: const Text('Oznaci kao spakovano'),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}*/
import 'package:bookbeauty_desktop/models/order.dart';

import '../widgets/order/customer_info.dart';
import '../widgets/shared/main_title.dart';
import '../widgets/order/order_items.dart';
import 'package:flutter/material.dart';

class NewOrderScreen extends StatelessWidget {
  const NewOrderScreen({super.key, required this.order});
  final Order order;

  @override
  Widget build(BuildContext context) {
    late Color buttonColor;
    late String buttonText;

    switch (order.status) {
      case 'novo':
        buttonColor = const Color.fromARGB(255, 172, 247, 150); // Green
        buttonText = 'Oznaci kao spakovano';
        break;
      case 'spakovano':
        buttonColor = const Color.fromARGB(255, 255, 165, 0); // Orange
        buttonText = 'Oznaci kao poslano';
        break;
      case 'poslano':
        buttonColor = const Color.fromARGB(255, 255, 69, 58); // Red
        buttonText = 'Narudzba je poslana';
        break;
    }

    return Scaffold(
      appBar: AppBar(),
      body: Column(
        children: [
          const MainTitle(title: 'Narudzba'),
          const Padding(
            padding: EdgeInsets.only(left: 20, top: 15, bottom: 10),
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
          const Expanded(child: CustomerInfo()),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.only(bottom: 20),
                child: ElevatedButton(
                  onPressed: () {},
                  style: ButtonStyle(
                    backgroundColor: WidgetStateProperty.all(buttonColor),
                    foregroundColor: WidgetStateProperty.all<Color>(
                        const Color.fromARGB(255, 245, 245, 245)),
                  ),
                  child: Text(buttonText),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
