import 'package:flutter/material.dart';

class DropdownMenu extends StatefulWidget {
  const DropdownMenu({super.key});

  @override
  _DropdownMenuState createState() => _DropdownMenuState();
}

class _DropdownMenuState extends State<DropdownMenu> {
  String selectedValue = 'shampoo';

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 20, top: 15),
      child: DropdownButton<String>(
        focusColor: Colors.transparent,
        value: selectedValue,
        onChanged: (String? newValue) {
          setState(() {
            selectedValue = newValue!;
          });
        },
        items: <String>['shampoo', 'oil', 'serum'].map((String value) {
          return DropdownMenuItem<String>(
            value: value,
            child: Text(value),
          );
        }).toList(),
      ),
    );
  }
}
