import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class TimeWidget extends StatelessWidget {
  const TimeWidget({super.key, required this.isDateSelected});

  final bool isDateSelected;

  @override
  Widget build(BuildContext context) {
    return isDateSelected
        ? Container(
            margin: const EdgeInsets.all(10),
            width: 70,
            height: 70,
            decoration: BoxDecoration(
              color: const Color.fromARGB(255, 187, 208, 216),
              borderRadius: BorderRadius.circular(10),
            ),
            child: const Center(
              child: Text('12:45'),
            ),
          )
        : const SizedBox(
            height: 2,
          );
  }
}
