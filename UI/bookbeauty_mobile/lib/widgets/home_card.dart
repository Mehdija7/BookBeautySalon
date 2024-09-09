import 'package:book_beauty/screens/products_screen.dart';
import 'package:book_beauty/screens/services_screen.dart';
import 'package:flutter/material.dart';
import 'package:transparent_image/transparent_image.dart';

class HomeCard extends StatefulWidget {
  const HomeCard(
      {super.key, required this.title, required this.image, required this.id});

  final String title;
  final String image;
  final int id;

  @override
  State<HomeCard> createState() => _HomeCardState();
}

class _HomeCardState extends State<HomeCard> {
  void _selectCard(BuildContext context) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (ctx) => widget.id == 1
            ? ServicesScreen(mainTitle: widget.title)
            : const ProductsScreen(
                favoritesOnly: false,
              ),
      ),
    );
  }

  bool isHovered = false;
  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.all(20),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(24),
      ),
      clipBehavior: Clip.hardEdge,
      elevation: 1,
      child: MouseRegion(
        onEnter: (_) {
          setState(() {
            isHovered = true;
          });
        },
        onExit: (_) {
          setState(() {
            isHovered = false;
          });
        },
        child: InkWell(
          onTap: () {
            _selectCard(context);
          },
          child: Stack(children: [
            FadeInImage(
                placeholder: MemoryImage(kTransparentImage),
                image: AssetImage(widget.image),
                fit: BoxFit.cover,
                height: 220,
                width: double.infinity),
            Positioned.fill(
              child: Container(
                color: const Color.fromARGB(137, 252, 252, 252),
                child: Center(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Text(
                      widget.title,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontSize: 26,
                        color: Colors.black,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ]),
        ),
      ),
    );
  }
}
