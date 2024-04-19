import 'package:bookbeauty_desktop/models/service.dart';
import 'package:bookbeauty_desktop/widgets/new_service.dart';
import 'package:bookbeauty_desktop/widgets/services_list.dart';
import 'package:flutter/material.dart';

class ServicesScreen extends StatefulWidget {
  const ServicesScreen({super.key});

  @override
  State<ServicesScreen> createState() => _ServicesScreenState();
}

class _ServicesScreenState extends State<ServicesScreen> {
  final List<Service> _registeredServices = [
    Service(
      title: 'Sisanje',
      amount: 20.99,
    ),
    Service(
      title: 'Feniranje',
      amount: 10,
    ),
  ];

  void _addExpense(Service expense) {
    setState(() {
      _registeredServices.add(expense);
    });
  }

  void _openAddServiceOverlay() {
    showModalBottomSheet(
      useSafeArea: true,
      isScrollControlled: true,
      context: context,
      builder: (ctx) => NewService(_addExpense),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        IconButton(
          onPressed: _openAddServiceOverlay,
          icon: const Icon(Icons.add),
          padding: const EdgeInsets.only(left: 40, right: 40),
        ),
        ServicesList(servicesList: _registeredServices),
      ],
    );
  }
}
