import '../widgets/order/customer_info.dart';
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
          Expanded(child: CustomerInfo()),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.only(bottom: 20),
                child: ElevatedButton(
                  onPressed: () {},
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.resolveWith<Color?>(
                      (Set<MaterialState> states) {
                        if (states.contains(MaterialState.pressed)) {
                          return Color.fromARGB(255, 130, 206, 147);
                        }
                        return Color.fromARGB(255, 172, 247, 150);
                      },
                    ),
                    foregroundColor: MaterialStateProperty.all<Color>(
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
}
