import 'package:bookbeauty_desktop/models/service.dart';
import 'package:bookbeauty_desktop/widgets/service/service_item.dart';
import 'package:flutter/material.dart';

class ServicesList extends StatelessWidget {
  const ServicesList({required this.servicesList, super.key});

  final List<Service> servicesList;
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ServiceItem(servicesList[1]),
        ServiceItem(servicesList[0]),
      ],
    );
  }
}
