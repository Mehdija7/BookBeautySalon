import 'package:flutter/material.dart';

class ProductText extends StatelessWidget {
  const ProductText({super.key});

  @override
  Widget build(BuildContext context) {
    void buy() {}
    return Column(
      children: [
        const Padding(
          padding: EdgeInsets.symmetric(vertical: 2, horizontal: 5),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Krema UNO",
                style: TextStyle(fontSize: 16, color: Colors.black),
              ),
              Icon(
                Icons.favorite_border,
                size: 20,
                color: Colors.grey,
              )
            ],
          ),
        ),
        const Padding(
          padding: EdgeInsets.only(left: 5),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Text(
                "24.47 KM",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(left: 10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              TextButton(
                onPressed: buy,
                style: TextButton.styleFrom(
                  padding:
                      const EdgeInsets.symmetric(vertical: 10, horizontal: 30),
                  backgroundColor: const Color.fromARGB(255, 212, 146, 152),
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                child: const Text(
                  'Kupi',
                  textAlign: TextAlign.center,
                ),
              ),
              const Icon(
                Icons.star,
                color: Color.fromARGB(255, 255, 192, 74),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
