import 'package:flutter/material.dart';

class TeamGridItem extends StatelessWidget {
  const TeamGridItem({
    super.key,
    required this.name,
    required this.image,
    required this.onSelectPerson,
  });

  final String name;
  final String image;
  final void Function(String name) onSelectPerson;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        onSelectPerson(name);
      },
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: Container(
          color: const Color.fromARGB(207, 97, 94, 94),
          width: 150,
          height: 150,
          child: Stack(
            fit: StackFit.expand,
            children: [
              Center(
                child: Container(
                  width: 120,
                  height: 120,
                  color: Colors.white,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(20),
                    child: Image.asset(
                      image,
                      width: 120,
                      height: 120,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ),
              Positioned(
                bottom: 5,
                left: 0,
                right: 0,
                child: Center(
                  child: Text(
                    name,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
