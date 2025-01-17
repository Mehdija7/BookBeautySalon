import 'package:flutter/material.dart';

class ApointmentTrait extends StatelessWidget {
  const ApointmentTrait({super.key, required this.date, required this.icon});

  final String date;
  final IconData icon;
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(
          icon,
          color: const Color.fromARGB(255, 255, 255, 255),
          size: 20,
        ),
        Text(
          date,
          style: const TextStyle(
            color: Color.fromARGB(255, 247, 245, 245),
          ),
        ),
      ],
    );
  }
}
