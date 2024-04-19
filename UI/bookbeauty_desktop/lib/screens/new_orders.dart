import 'package:bookbeauty_desktop/screens/new_order_screen.dart';
import 'package:bookbeauty_desktop/widgets/card.dart';
import 'package:flutter/material.dart';

class NewOrders extends StatelessWidget {
  const NewOrders({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Nove narudzbe"),
      ),
      body: Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            GestureDetector(
              onTap: () {
                Navigator.of(context).push(
                    MaterialPageRoute(builder: (ctx) => NewOrderScreen()));
              },
              child: const CardItem(
                title: "ID NARDUZBE: ",
                color: Color.fromARGB(255, 115, 204, 118),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
