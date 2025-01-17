import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'appointment_trait.dart';

final formater = DateFormat('dd/MM/yyyy');

class AppointmentCard extends StatelessWidget {
  const AppointmentCard(
      {super.key,
      required this.service,
      required this.date,
      required this.time,
      required this.isNew,
      required this.price});

  final String service;
  final String date;
  final String time;
  final bool isNew;
  final String price;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 350,
      height: 150,
      child: Card(
        color: isNew
            ? const Color.fromARGB(125, 125, 252, 22)
            : const Color.fromARGB(255, 230, 197, 108),
        margin: const EdgeInsets.all(20),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(24),
        ),
        clipBehavior: Clip.hardEdge,
        elevation: 1,
        child: Stack(
          children: [
            Center(
              child: Text(
                service.toUpperCase(),
                style: const TextStyle(
                  fontSize: 24,
                  color: Color.fromARGB(255, 255, 255, 255),
                ),
              ),
            ),
            Positioned(
              bottom: 10,
              left: 10,
              child: Row(
                children: [
                  ApointmentTrait(date: date, icon: Icons.calendar_month),
                  const SizedBox(
                    width: 60,
                  ),
                  ApointmentTrait(date: time, icon: Icons.watch_later_outlined),
                  const SizedBox(
                    width: 60,
                  ),
                  ApointmentTrait(
                      date: price, icon: Icons.monetization_on_sharp),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
