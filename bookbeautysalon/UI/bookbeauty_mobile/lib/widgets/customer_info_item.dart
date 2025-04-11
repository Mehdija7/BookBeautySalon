import 'package:flutter/material.dart';

class CustomerInfoItem extends StatelessWidget {
  const CustomerInfoItem({
    super.key,
    required this.title,
    required this.value,
    required this.titleStyle,
    required this.valueStyle,
    this.valueWidget,
  });

  final String title;
  final String value;
  final TextStyle titleStyle;
  final TextStyle valueStyle;
  final Widget? valueWidget;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 15, bottom: 15),
      child: Row(
        children: [
          Text(
            title,
            style: titleStyle,
          ),
          const SizedBox(width: 10),
          Expanded(
            child:
                valueWidget ?? 
                    Text(
                      value,
                      style: valueStyle,
                      overflow: TextOverflow.ellipsis,
                      softWrap: false,
                    ),
          ),
        ],
      ),
    );
  }
}
