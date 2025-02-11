import 'package:bookbeauty_desktop/models/news.dart';
import 'package:bookbeauty_desktop/providers/news_provider.dart';
import 'package:bookbeauty_desktop/providers/user_provider.dart';
import 'package:bookbeauty_desktop/screens/addnews_screen.dart';
import 'package:bookbeauty_desktop/screens/oldnews_screen.dart';
import 'package:bookbeauty_desktop/widgets/shared/card.dart';
import 'package:flutter/material.dart';

class NewsScreen extends StatelessWidget {
  const NewsScreen({super.key});

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
                  .push(MaterialPageRoute(builder: (ctx) => AddnewsScreen()));
            },
            child: const CardItem(
              title: 'Dodaj novost',
              color: Color.fromARGB(255, 114, 199, 121),
            ),
          ),
          GestureDetector(
            onTap: () {
              Navigator.of(context)
                  .push(MaterialPageRoute(builder: (ctx) => OldnewsScreen()));
            },
            child: const CardItem(
              title: 'Arhiva novosti',
              color: Color.fromARGB(255, 214, 226, 109),
            ),
          ),
        ],
      ),
    );
  }
}
