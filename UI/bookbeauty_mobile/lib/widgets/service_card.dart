import 'package:flutter/material.dart';
import 'package:transparent_image/transparent_image.dart';

import '../screens/servicedetai_screen.dart';

class ServiceCard extends StatelessWidget {
  const ServiceCard({super.key, required this.image, required this.service});

  final String service;
  final String image;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.all(20),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(24),
      ),
      clipBehavior: Clip.hardEdge,
      elevation: 1,
      child: InkWell(
        onTap: () {
          _selectCard(context);
        },
        child: Stack(children: [
          Hero(
            tag: UniqueKey(),
            child: FadeInImage(
                placeholder: MemoryImage(kTransparentImage),
                image: AssetImage(image),
                fit: BoxFit.cover,
                height: 150,
                width: double.infinity),
          ),
          Positioned.fill(
            child: Container(
              color: const Color.fromARGB(121, 206, 206, 206),
              child: Center(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Text(
                    service,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontSize: 26,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ]),
      ),
    );
  }

  void _selectCard(BuildContext context) {
    Navigator.of(context).push(MaterialPageRoute(
      builder: (ctx) => ServiceDetailScreen(service: service, image: image),
    ));
  }
}