import 'package:flutter/material.dart';

class ChartBar extends StatelessWidget {
  final double fill;
  final double totalSum;

  const ChartBar({
    super.key,
    required this.fill,
    required this.totalSum,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 4),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Text(
              totalSum.toStringAsFixed(0),
              style: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 4),
            Flexible(
              child: FractionallySizedBox(
                widthFactor: 0.3,
                heightFactor:
                    (fill + 1000) < totalSum ? fill.clamp(0.3, 1.0) : fill,
                child: const DecoratedBox(
                  decoration: BoxDecoration(
                      shape: BoxShape.rectangle,
                      borderRadius:
                          BorderRadius.vertical(top: Radius.circular(8)),
                      color: Colors.blueGrey),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
