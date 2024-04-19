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
      required this.isNew});

  final String service;
  final DateTime date;
  final String time;
  final bool isNew;

  String get formattedDate {
    return formater.format(date);
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 350,
      height: 150,
      child: Card(
        color: isNew
            ? const Color.fromARGB(127, 178, 240, 127)
            : const Color.fromARGB(201, 207, 195, 195),
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
                  ApointmentTrait(
                      date: formattedDate, icon: Icons.calendar_month),
                  const SizedBox(
                    width: 120,
                  ),
                  ApointmentTrait(date: time, icon: Icons.watch_later_outlined),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
