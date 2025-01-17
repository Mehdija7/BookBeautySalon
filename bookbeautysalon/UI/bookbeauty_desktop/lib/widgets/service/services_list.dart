import 'package:bookbeauty_desktop/models/category.dart';
import 'package:bookbeauty_desktop/models/service.dart';
import 'package:bookbeauty_desktop/widgets/product/category_item.dart';
import 'package:bookbeauty_desktop/widgets/service/service_item.dart';
import 'package:flutter/material.dart';

class ServicesList<T> extends StatelessWidget {
  const ServicesList(
      {required this.servicesList, required this.isService, super.key});

  final List<T> servicesList;
  final bool isService;
  @override
  Widget build(BuildContext context) {
    return isService
        ? Column(
            children: servicesList
                .map((service) => ServiceItem(service as Service))
                .toList(),
          )
        : Column(
            children:
                servicesList.map((c) => CategoryItem(c as Category)).toList(),
          );
  }
}
