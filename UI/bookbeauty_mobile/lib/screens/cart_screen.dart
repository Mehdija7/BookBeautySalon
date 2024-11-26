import 'package:book_beauty/models/order_item.dart';
import 'package:book_beauty/providers/order_item_provider.dart';
import 'package:book_beauty/widgets/buy_button.dart';
import 'package:book_beauty/widgets/cart_card.dart';
import 'package:flutter/material.dart';
import '../widgets/main_title.dart';

class CartScreen extends StatefulWidget {
  const CartScreen({super.key});

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('')),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const MainTitle(title: 'Korpa'),
          Expanded(
            child: ListView.builder(
              itemCount: (OrderItemProvider.orderItems?.length ?? 0) + 1,
              itemBuilder: (context, index) {
                if (index < (OrderItemProvider.orderItems?.length ?? 0)) {
                  final orderItem = OrderItemProvider.orderItems![index];
                  return orderItem != null
                      ? CartCard(product: orderItem)
                      : const SizedBox.shrink();
                } else {
                  return Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(
                            top: 5, right: 15, bottom: 15),
                        child: Text(
                          'Ukupno: ${calculateTotal()} KM',
                          style: const TextStyle(
                              fontSize: 16, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ],
                  );
                }
              },
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

  double calculateTotal() {
    if (OrderItemProvider.orderItems == null) return 0;

    return OrderItemProvider.orderItems!
        .where((item) => item.product != null && item.product!.price != null)
        .fold(0, (sum, item) => sum + item.product!.price!);
  }
}
