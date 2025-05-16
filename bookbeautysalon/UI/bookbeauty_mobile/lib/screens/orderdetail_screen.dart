import 'package:flutter/material.dart';
import 'package:book_beauty/models/order.dart';

class OrderDetailScreen extends StatelessWidget {
  final Order order;

  const OrderDetailScreen({super.key, required this.order});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Order #${order.orderNumber}')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildDetailRow('Status:', order.status ?? 'Unknown'),
            _buildDetailRow('Total Price:', '\$${order.totalPrice?.toStringAsFixed(2) ?? "0.00"}'),
            _buildDetailRow('Date:', order.dateTime?.toLocal().toString().split(' ')[0] ?? 'N/A'),
            const SizedBox(height: 20),
            const Text(
              'Items:',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            Expanded(
              child: order.orderItems == null || order.orderItems!.isEmpty
                  ? const Text('No items found.')
                  : ListView.builder(
                      itemCount: order.orderItems!.length,
                      itemBuilder: (context, index) {
                        final item = order.orderItems![index];
                        return Card(
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12)),
                          elevation: 2,
                          margin: const EdgeInsets.symmetric(vertical: 6),
                          child: ListTile(
                            title: Text(item.product?.name ?? 'Unknown product'),
                            subtitle: Text('Quantity: ${item.quantity}'),
                            trailing: Text(
                              '\$${item.product!.price?.toStringAsFixed(2) ?? "0.00"}',
                              style: const TextStyle(fontWeight: FontWeight.bold),
                            ),
                          ),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Text(
            label,
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          const SizedBox(width: 8),
          Text(value),
        ],
      ),
    );
  }
}
