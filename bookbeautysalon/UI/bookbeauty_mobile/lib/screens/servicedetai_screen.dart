import 'dart:convert';

import 'package:book_beauty/models/service.dart';
import 'package:book_beauty/screens/reservation_screen.dart';
import 'package:book_beauty/widgets/main_title.dart';
import 'package:flutter/material.dart';
import 'package:transparent_image/transparent_image.dart';

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
      body: SingleChildScrollView(
        child: Column(
          children: [
            MainTitle(title: service.name!),
            const SizedBox(height: 14),
            Hero(
              tag: UniqueKey(),
              child: service.image != null
                  ? Image.memory(
                      base64Decode(service
                          .image!), // Assuming it's a Uint8List if not null
                      width: 100,
                      height: 200,
                      fit: BoxFit.cover,
                    )
                  : Image.asset(
                      "assets/images/logoBB.png", // Fallback asset image when image is null
                      width: 100,
                      height: 200,
                      fit: BoxFit.cover,
                    ),
            ),
            Container(
              color: const Color.fromARGB(255, 231, 228, 213),
              height: 400,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                mainAxisSize: MainAxisSize.max,
                children: [
                  Padding(
                    padding:
                        const EdgeInsets.only(left: 5, top: 15, bottom: 20),
                    child: Column(
                      children: [
                        Text(
                          service.shortDescription!,
                          style: Theme.of(context)
                              .textTheme
                              .titleMedium!
                              .copyWith(fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(
                          height: 15,
                        ),
                        Text(
                          service.longDescription!,
                          style: Theme.of(context)
                              .textTheme
                              .titleMedium!
                              .copyWith(fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 5),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text('${service.price} BAM'),
                        TextButton(
                          style: ButtonStyle(
                            fixedSize: WidgetStateProperty.all(
                              const Size(150, 60),
                            ),
                            backgroundColor: WidgetStateProperty.all<Color>(
                              const Color.fromARGB(255, 113, 121, 122),
                            ),
                            foregroundColor: WidgetStateProperty.all<Color>(
                                const Color.fromARGB(255, 245, 245, 245)),
                            overlayColor:
                                WidgetStateProperty.resolveWith<Color?>(
                              (Set<WidgetState> states) {
                                if (states.contains(WidgetState.hovered)) {
                                  return const Color.fromARGB(185, 48, 49, 49)
                                      .withOpacity(0.04);
                                }
                                if (states.contains(WidgetState.focused) ||
                                    states.contains(WidgetState.pressed)) {
                                  return const Color.fromARGB(
                                          214, 126, 129, 131)
                                      .withOpacity(0.12);
                                }
                                return null;
                              },
                            ),
                          ),
                          onPressed: goToReservation,
                          child: const Text(
                            'Rezerviši termin',
                            style: TextStyle(fontSize: 16),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
