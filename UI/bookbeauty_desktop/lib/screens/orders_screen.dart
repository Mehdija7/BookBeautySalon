import 'package:bookbeauty_desktop/models/order.dart';
import 'package:bookbeauty_desktop/screens/new_order_screen.dart';
import 'package:flutter/material.dart';

class OrdersScreen extends StatefulWidget {
  const OrdersScreen({super.key});

  @override
  State<OrdersScreen> createState() => _OrdersScreenState();
}

class _OrdersScreenState extends State<OrdersScreen> {
  final List<Order> orders = [
    Order(
        totalPrice: 50.0,
        dateTime: DateTime.now(),
        customerId: 1,
        orderNumber: '001',
        status: 'novo',
        address: '123 Main St'),
    Order(
        totalPrice: 75.5,
        dateTime: DateTime.now(),
        customerId: 2,
        orderNumber: '002',
        status: 'spakovano',
        address: '456 Oak St'),
    Order(
        totalPrice: 100.0,
        dateTime: DateTime.now(),
        customerId: 3,
        orderNumber: '003',
        status: 'poslano',
        address: '789 Pine St'),
  ];

  Color _getStatusColor(String status) {
    switch (status) {
      case 'novo':
        return Colors.green;
      case 'spakovano':
        return Colors.orange;
      case 'poslano':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: SizedBox(
            width: MediaQuery.of(context).size.width,
            child: DataTable(
              columns: const [
                DataColumn(label: Text('Order Number')),
                DataColumn(label: Text('Total Price')),
                DataColumn(label: Text('Date')),
                DataColumn(label: Text('Customer ID')),
                DataColumn(label: Text('Address')),
                DataColumn(label: Text('Status')),
              ],
              rows: orders.map((order) {
                return DataRow(
                  cells: [
                    DataCell(Text(order.orderNumber!)),
                    DataCell(Text(order.totalPrice!.toStringAsFixed(2))),
                    DataCell(Text(
                        order.dateTime!.toLocal().toString().split(' ')[0])),
                    DataCell(Text(order.customerId.toString())),
                    DataCell(Text(order.address!)),
                    DataCell(
                      TextButton(
                        onPressed: () {
                          print('Status: ${order.status}');
                        },
                        style: TextButton.styleFrom(
                          backgroundColor: _getStatusColor(order.status!),
                          foregroundColor: Colors.white,
                        ),
                        child: Text(order.status!),
                      ),
                    ),
                  ],
                  onSelectChanged: (selected) {
                    if (selected != null && selected) {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => NewOrderScreen(
                            order: order,
                          ),
                        ),
                      );
                    }
                  },
                );
              }).toList(),
            ),
          ),
        ),
      ),
    );
  }
}
