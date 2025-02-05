import 'package:flutter/material.dart';

class CustomerInfoItem extends StatelessWidget {
  const CustomerInfoItem(
      {super.key,
      required this.title,
      required this.value,
      required TextStyle titleStyle,
      required TextStyle valueStyle});

  final String title;
  final String value;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 15, bottom: 15),
      child: Row(
        children: [
          Text(
            title,
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
          ),
          SizedBox(width: 10),
          Text(value,
              style: TextStyle(fontWeight: FontWeight.w400, fontSize: 20)),
        ],
      ),
    );
  }
}
