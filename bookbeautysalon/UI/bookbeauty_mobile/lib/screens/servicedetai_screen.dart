import 'dart:convert';
import 'package:book_beauty/models/service.dart';
import 'package:book_beauty/screens/reservation_screen.dart';
import 'package:book_beauty/widgets/main_title.dart';
import 'package:flutter/material.dart';

class ServiceDetailScreen extends StatelessWidget {
  const ServiceDetailScreen({super.key, required this.service});

  final Service service;

  @override
  Widget build(BuildContext context) {
    void goToReservation() {
      Navigator.of(context).push(
        MaterialPageRoute(
            builder: (ctx) => ReservationScreen(service: service)),
      );
    }

    return Scaffold(
      appBar: AppBar(
        forceMaterialTransparency: true,
        title: const Text(''),
        backgroundColor: const Color.fromARGB(255, 231, 228, 213),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          MainTitle(title: service.name!),
          const SizedBox(height: 14),
          Hero(
            tag: UniqueKey(),
            child: service.image != null
                ? Image.memory(
                    base64Decode(service.image!),
                    width: double.infinity,
                    height: 200,
                    fit: BoxFit.cover,
                  )
                : Image.asset(
                    "assets/images/pranje_kose.jpg",
                    width: double.infinity,
                    height: 200,
                    fit: BoxFit.cover,
                  ),
          ),
          Expanded(
            child: Container(
              color: const Color.fromARGB(255, 231, 228, 213),
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    service.shortDescription!,
                    style: Theme.of(context)
                        .textTheme
                        .titleMedium!
                        .copyWith(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 15),
                  Text(
                    service.longDescription!,
                    style: Theme.of(context)
                        .textTheme
                        .titleMedium!
                        .copyWith(fontWeight: FontWeight.bold),
                  ),
                  const Spacer(), 
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        '${service.price} BAM',
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(
                              vertical: 15, horizontal: 30),
                          backgroundColor:
                              const Color.fromARGB(255, 113, 121, 122),
                          foregroundColor:
                              const Color.fromARGB(255, 245, 245, 245),
                        ),
                        onPressed: goToReservation,
                        child: const Text(
                          'Reserve',
                          style: TextStyle(fontSize: 16),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20), 
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
