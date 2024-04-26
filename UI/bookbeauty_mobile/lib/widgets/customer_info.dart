import 'package:book_beauty/widgets/customer_info_item.dart';
import 'package:flutter/material.dart';

class CustomerInfo extends StatelessWidget {
  const CustomerInfo({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 15),
      child: Column(
        children: [
          CustomerInfoItem(title: 'Ime: ', value: 'Mehdija'),
          CustomerInfoItem(title: 'Prezime:', value: 'Sekic'),
          CustomerInfoItem(title: 'Adresa:', value: 'Sanski Most'),
        ],
      ),
    );
  }
}
