import '../widgets/shared/card.dart';
import 'package:flutter/material.dart';
import '../screens/report_screen.dart';
import '../screens/review_screen.dart';

class ReportsScreen extends StatelessWidget {
  const ReportsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          GestureDetector(
            onTap: () {
              Navigator.of(context)
                  .push(MaterialPageRoute(builder: (ctx) => ReportScreen()));
            },
            child: const CardItem(
              title: 'Izvjestaji',
              color: Colors.grey,
            ),
          ),
          GestureDetector(
            onTap: () {
              Navigator.of(context)
                  .push(MaterialPageRoute(builder: (ctx) => ReviewScreen()));
            },
            child: const CardItem(
              title: 'Recenzije',
              color: Colors.blueGrey,
            ),
          ),
        ],
      ),
    );
  }
}
