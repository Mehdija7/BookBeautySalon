import 'package:book_beauty/models/service.dart'; 
import 'package:book_beauty/providers/service_provider.dart';
import 'package:book_beauty/widgets/service_card.dart';
import 'package:flutter/material.dart';

class ServicesScreen extends StatefulWidget {
  const ServicesScreen({super.key, required this.mainTitle});

  final String mainTitle;

  @override
  State<ServicesScreen> createState() => _ServicesScreenState();
}

class _ServicesScreenState extends State<ServicesScreen> {
  late List<Service> _registeredServices = [];
  late bool isLoading = true;
  final ServiceProvider serviceProvider = ServiceProvider();

  @override
  void initState() {
    super.initState();
    _fetchServices();
  }

  Future<void> _fetchServices() async {
    try {
      var result = await serviceProvider.get();
      List<Service> list = result.result;
     
      setState(() {
        _registeredServices = list;
        isLoading = false;
      });
    } catch (e) {
      print(
          "*****************************ERROR MESSAGE $e ***********************************");
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 190, 187, 168).withOpacity(0.4),
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Padding(
              padding: EdgeInsets.only(left: 8.0, bottom: 8.0),
              child: Text(
                'Services',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            Expanded(
              child: isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : _registeredServices.isEmpty
                      ? const Center(child: Text('There is no available services.'))
                      : Center(
                          child: ListView.builder(
                            padding: const EdgeInsets.all(12),
                            itemCount: _registeredServices.length,
                            itemBuilder: (context, index) {
                              final service = _registeredServices[index];
                              return ServiceCard(service: service);
                            },
                          ),
                        ),
            ),
          ],
        ),
      ),
    );
  }
}
