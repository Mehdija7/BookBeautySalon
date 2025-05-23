import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:bookbeauty_desktop/models/order.dart';
import 'package:bookbeauty_desktop/providers/order_provider.dart';
import 'package:bookbeauty_desktop/screens/new_order_screen.dart';

class OrdersScreen extends StatefulWidget {
  const OrdersScreen({super.key});

  @override
  State<OrdersScreen> createState() => _OrdersScreenState();
}

class _OrdersScreenState extends State<OrdersScreen> with RouteAware {
  late List<Order> orders = [];
  late OrderProvider orderProvider;
  bool isLoading = true;
  String? selectedPriceOrder;
  String? selectedDateOrder;
  String? selectedStatusFilter;

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
      case 'created':
        return Colors.green;
      case 'sent':
        return Colors.orange;
      case 'delivered':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  void _clearFilters() {
    setState(() {
      selectedPriceOrder = null;
      selectedDateOrder = null;
      selectedStatusFilter = null;
    });
  }

  void _sortOrdersByPrice() {
    if (selectedPriceOrder == 'From lowest price') {
      orders.sort((a, b) => (a.totalPrice ?? 0).compareTo(b.totalPrice ?? 0));
    } else if (selectedPriceOrder == 'From highest price') {
      orders.sort((a, b) => (b.totalPrice ?? 0).compareTo(a.totalPrice ?? 0));
    }
  }

  void _sortOrdersByDate() {
    if (selectedDateOrder == 'From newest') {
      orders.sort((a, b) => (b.dateTime ?? DateTime.now())
          .compareTo(a.dateTime ?? DateTime.now()));
    } else if (selectedDateOrder == 'From oldest') {
      orders.sort((a, b) => (a.dateTime ?? DateTime.now())
          .compareTo(b.dateTime ?? DateTime.now()));
    }
  }

  List<Order> _filterOrdersByStatus(List<Order> orders) {
    if (selectedStatusFilter != null && selectedStatusFilter!.isNotEmpty) {
      return orders.where((order) {
        return order.status?.toLowerCase() ==
            selectedStatusFilter!.toLowerCase();
      }).toList();
    }
    return orders;
  }

  @override
  Widget build(BuildContext context) {
    _sortOrdersByPrice();
    _sortOrdersByDate();
    final filteredOrders = _filterOrdersByStatus(orders);

    return Scaffold(
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                DropdownButton<String>(
                  hint: const Text('Filter by price'),
                  value: selectedPriceOrder,
                  items: <String>[
                    'From lowest price',
                    'From highest price',
                  ].map<DropdownMenuItem<String>>((String value) {
                    return DropdownMenuItem<String>(
                        value: value, child: Text(value));
                  }).toList(),
                  onChanged: (value) {
                    setState(() {
                      selectedPriceOrder = value;
                    });
                  },
                ),
                const SizedBox(width: 20),
                DropdownButton<String>(
                  hint: const Text('Filter by date'),
                  value: selectedDateOrder,
                  items: <String>[
                    'From newest',
                    'From oldest',
                  ].map<DropdownMenuItem<String>>((String value) {
                    return DropdownMenuItem<String>(
                        value: value, child: Text(value));
                  }).toList(),
                  onChanged: (value) {
                    setState(() {
                      selectedDateOrder = value;
                    });
                  },
                ),
                const SizedBox(width: 20),
                DropdownButton<String>(
                  hint: const Text('Filter by state'),
                  value: selectedStatusFilter,
                  items: <String>[
                    'Created',
                    'Sent',
                    'Delivered',
                  ].map<DropdownMenuItem<String>>((String value) {
                    return DropdownMenuItem<String>(
                        value: value, child: Text(value));
                  }).toList(),
                  onChanged: (value) {
                    setState(() {
                      selectedStatusFilter = value;
                    });
                  },
                ),
                const SizedBox(width: 20),
                IconButton(
                  icon: const Icon(
                    Icons.filter_alt_off,
                    color: Colors.redAccent,
                  ),
                  onPressed: _clearFilters,
                  tooltip: 'Delete all filters',
                ),
              ],
            ),
          ),
          Expanded(
            child: SingleChildScrollView(
              scrollDirection: Axis.vertical,
              child: isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: SizedBox(
                        width: MediaQuery.of(context).size.width,
                        child: DataTable(
                          columns: const [
                            DataColumn(label: Text('Order number')),
                            DataColumn(label: Text('Total price')),
                            DataColumn(label: Text('Date')),
                            DataColumn(label: Text('State')),
                          ],
                          rows: filteredOrders.map((order) {
                            return DataRow(
                              cells: [
                                DataCell(Text(order.orderNumber ?? "")),
                                DataCell(Text(
                                    order.totalPrice?.toStringAsFixed(2) ??
                                        "1")),
                                DataCell(Text(order.dateTime != null
                                    ? order.dateTime!
                                        .toLocal()
                                        .toString()
                                        .split(' ')[0]
                                    : "")),
                                DataCell(
                                  TextButton(
                                    onPressed: () {
                                      print('State: ${order.status}');
                                    },
                                    style: TextButton.styleFrom(
                                      backgroundColor: _getStatusColor(
                                          order.status ?? "unknown"),
                                      foregroundColor: Colors.white,
                                    ),
                                    child: Text(order.status ?? "unknown"),
                                  ),
                                ),
                              ],
                              onSelectChanged: (selected) async {
                                if (selected != null && selected) {
                                  final result =
                                      await Navigator.of(context).push(
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
          ),
        ],
      ),
    );
  }
}
