import 'package:bookbeauty_desktop/widgets/shared/main_title.dart';
import 'package:flutter/material.dart';

class CustomerInfo extends StatelessWidget {
  const CustomerInfo({super.key});

  @override
  Widget build(BuildContext context) {
    return const Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        MainTitle(title: 'Informacije o kupcu'),
        Padding(
          padding: EdgeInsets.only(right: 200, left: 20, bottom: 10),
          child: Text('Aresa:' + ' Azize Sacirbegovica Sarajevo'),
        ),
        Padding(
          padding: EdgeInsets.only(right: 200, left: 20, bottom: 20),
          child: Text('Ime: ' + ' Kupac Kupac'),
        ),
        Padding(
          padding: EdgeInsets.only(right: 200, left: 20, bottom: 20),
          child: Text('Broj: ' + '38760484854'),
        ),
      ],
    );
  }
}
