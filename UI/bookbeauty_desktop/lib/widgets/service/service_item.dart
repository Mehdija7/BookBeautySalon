import 'package:bookbeauty_desktop/models/service.dart';
import 'package:flutter/material.dart';

class ServiceItem extends StatelessWidget {
  const ServiceItem(this.service, {super.key});

  final Service service;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: 20,
          vertical: 16,
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Text(
              service.name!,
            ),
            const SizedBox(height: 4),
            Text('BAM ${service.price!.toStringAsFixed(2)}'),
            Text('min ${service.duration!.toString()}'),
          ],
        ),
      ),
    );
  }
}
