import 'package:book_beauty/screens/teamdetail_screen.dart';
import 'package:book_beauty/widgets/main_title.dart';
import 'package:book_beauty/widgets/team_grid_item.dart';
import 'package:flutter/material.dart';

class OurTeamScreen extends StatelessWidget {
  const OurTeamScreen({super.key, required this.title});

  final String title;

  @override
  Widget build(BuildContext context) {
    void selectingPerson(String name) {
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (ctx) =>
              TeamDetailScreen(name: name, image: 'assets/images/sisanje.webp'),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text(''),
      ),
      body: Column(
        children: [
          MainTitle(title: title),
          Expanded(
            child: GridView(
              padding: const EdgeInsets.all(10),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: 2 / 2,
                crossAxisSpacing: 10,
                mainAxisSpacing: 10,
              ),
              children: [
                TeamGridItem(
                    name: 'Ajla',
                    image: 'assets/images/sisanje.webp',
                    onSelectPerson: selectingPerson),
                TeamGridItem(
                    name: 'Ajla Ajlic',
                    image: 'assets/images/sisanje.webp',
                    onSelectPerson: selectingPerson),
                TeamGridItem(
                    name: 'Ajla',
                    image: 'assets/images/sisanje.webp',
                    onSelectPerson: selectingPerson),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
