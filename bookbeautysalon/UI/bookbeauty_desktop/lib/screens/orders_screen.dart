import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:bookbeauty_desktop/models/order.dart';
import 'package:bookbeauty_desktop/providers/order_provider.dart';
import 'package:bookbeauty_desktop/screens/new_order_screen.dart';
import 'package:flutter/widgets.dart';

class OrdersScreen extends StatefulWidget {
  const OrdersScreen({super.key});

  @override
  State<OrdersScreen> createState() => _OrdersScreenState();
}

class _OrdersScreenState extends State<OrdersScreen> with RouteAware {
  late List<Order> orders = [];
  late OrderProvider orderProvider;
  bool isLoading = true;

  @override
  void initState() {
    orderProvider = context.read<OrderProvider>();
    super.initState();
    _fetchOrders();
  }

  @override
  void didPopNext() {
    super.didPopNext();
    _fetchOrders();
  }

  @override
  void dispose() {
    super.dispose();
  }

  Future<void> _fetchOrders() async {
    try {
      var result = await orderProvider.get();
      setState(() {
        orders = result.result;
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        isLoading = false;
      });
    }
  }

  Color _getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'kreirana':
        return Colors.green;
      case 'isporucena':
        return Colors.orange;
      case 'dostavljena':
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
        child: isLoading
            ? const CircularProgressIndicator()
            : SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: SizedBox(
                  width: MediaQuery.of(context).size.width,
                  child: DataTable(
                    columns: const [
                      DataColumn(label: Text('Broj narudzbe')),
                      DataColumn(label: Text('Ukupna cijena')),
                      DataColumn(label: Text('Datum')),
                      DataColumn(label: Text('Status')),
                    ],
                    rows: orders.map((order) {
                      return DataRow(
                        cells: [
                          DataCell(Text(order.orderNumber!)),
                          DataCell(Text(order.totalPrice!.toStringAsFixed(2))),
                          DataCell(Text(order.dateTime!
                              .toLocal()
                              .toString()
                              .split(' ')[0])),
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
                        onSelectChanged: (selected) async {
                          if (selected != null && selected) {
                            final result = await Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (context) => NewOrderScreen(
                                  order: order,
                                ),
                              ),
                            );

                            if (result == true) {
                              _fetchOrders();
                            }
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
