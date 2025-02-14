import 'package:flutter/material.dart';
import 'package:book_beauty/models/order.dart';
import 'package:book_beauty/providers/order_provider.dart';
import 'package:book_beauty/providers/user_provider.dart';

class OrdersScreen extends StatefulWidget {
  const OrdersScreen({super.key});

  @override
  State<OrdersScreen> createState() => _OrdersScreenState();
}

class _OrdersScreenState extends State<OrdersScreen> {
  List<Order> orders = [];
  OrderProvider orderProvider = OrderProvider();
  bool isLoading = true;

  void fetchOrders() async {
    int id = UserProvider.globalUserId!;
    try {
      var r = await orderProvider.get();
      var list = r.result.where((o) => o.customerId == id);
      setState(() {
        orders = list.toList();
        isLoading = false;
      });
    } catch (e) {
      print(e);
    }
  }

  @override
  void initState() {
    fetchOrders();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Narudzbe'),
      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : orders.isEmpty
              ? Center(child: Text('No orders found'))
              : ListView.builder(
                  itemCount: orders.length,
                  itemBuilder: (context, index) {
                    final order = orders[index];
                    return Card(
                      margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                      child: ListTile(
                        title: Text('Narudzba #${order.orderNumber}'),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Status: ${order.status}'),
                            Text(
                                'Ukupna cijena: \$${order.totalPrice?.toStringAsFixed(2)}'),
                            Text(
                                'Datum: ${order.dateTime?.toLocal().toString().split(' ')[0]}'),
                          ],
                        ),
                        onTap: () {
                          // Handle order tap, maybe show order details
                        },
                      ),
                    );
                  },
                ),
    );
  }
}
