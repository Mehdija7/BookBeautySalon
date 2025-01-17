import 'dart:io';

import 'package:bookbeauty_desktop/models/service.dart';
import 'package:bookbeauty_desktop/providers/service_provider.dart';
import 'package:bookbeauty_desktop/providers/upload_provider.dart';
import 'package:bookbeauty_desktop/screens/new_service_screen.dart';
import '../widgets/service/new_service.dart';
import '../widgets/service/services_list.dart';
import 'package:flutter/material.dart';

class ServicesScreen extends StatefulWidget {
  const ServicesScreen({super.key});

  @override
  State<ServicesScreen> createState() => _ServicesScreenState();
}

class _ServicesScreenState extends State<ServicesScreen> {
  late List<Service> _registeredServices = [];
  ServiceProvider serviceProvider = ServiceProvider();
  FileUploadService uploadService = FileUploadService();
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchServices();
  }

  Future<void> _fetchServices() async {
    try {
      var result = await serviceProvider.get();
      setState(() {
        _registeredServices = result.result.cast<Service>();
        isLoading = false;
      });
      print(_registeredServices);
    } catch (e) {
      print(
          "*****************************ERROR MESSAGE $e ***********************************");
      setState(() {
        isLoading = false;
      });
    }
  }

  void _navigateToNewServiceScreen() async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const NewserviceScreen()),
    );

    if (result == 'service_added') {
      _fetchServices();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            IconButton(
              onPressed: _navigateToNewServiceScreen,
              icon: const Icon(Icons.add),
              padding: const EdgeInsets.only(left: 40, right: 40),
            ),
          ],
        ),
        _registeredServices.isEmpty
            ? const Text("Trenutno nema dodanih usluga")
            : ServicesList(
                servicesList: _registeredServices,
                isService: true,
              ),
      ],
    );
  }
}
