import 'package:book_beauty/widgets/appointment_card.dart';
import 'package:book_beauty/widgets/main_title.dart';
import 'package:flutter/material.dart';

class AppointmentScreen extends StatelessWidget {
  const AppointmentScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const MainTitle(title: 'Termini'),
        AppointmentCard(
          service: 'Sisanje',
          date: DateTime.now(),
          time: '14:20',
          isNew: true,
        ),
        AppointmentCard(
          service: 'Feniranje',
          date: DateTime(2024, 2, 13),
          time: '09:20',
          isNew: false,
        ),
      ],
    );
  }
}
