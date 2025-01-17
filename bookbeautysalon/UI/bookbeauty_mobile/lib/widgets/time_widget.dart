import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class TimeWidget extends StatelessWidget {
  const TimeWidget(
      {super.key, required this.isDateSelected, required this.time});

  final bool isDateSelected;
  final TimeOfDay time;

  @override
  Widget build(BuildContext context) {
    final String formattedTime =
        MaterialLocalizations.of(context).formatTimeOfDay(time);

    return isDateSelected
        ? Container(
            margin: const EdgeInsets.all(10),
            width: 70,
            height: 70,
            decoration: BoxDecoration(
              color: const Color.fromARGB(255, 187, 208, 216),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Center(
              child: Text(
                formattedTime, // Display the formatted time here
                style: const TextStyle(fontSize: 16),
              ),
            ),
          )
        : const SizedBox(
            height: 2,
          );
  }
}
