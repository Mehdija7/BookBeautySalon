import 'package:flutter/material.dart';

class ProductText extends StatelessWidget {
  const ProductText(
      {super.key, required this.onSelectProduct, required this.name});

  final void Function(String name) onSelectProduct;
  final String name;
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
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              TextButton(
                onPressed: buy,
                style: TextButton.styleFrom(
                  padding:
                      const EdgeInsets.symmetric(vertical: 10, horizontal: 30),
                  backgroundColor: Color.fromARGB(255, 243, 100, 112),
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                child: const Text(
                  'Izbrisi',
                  textAlign: TextAlign.center,
                ),
              ),
              const SizedBox(
                width: 5,
              ),
              TextButton(
                onPressed: () {
                  onSelectProduct(name);
                },
                style: TextButton.styleFrom(
                  padding:
                      const EdgeInsets.symmetric(vertical: 10, horizontal: 30),
                  backgroundColor: Color.fromARGB(255, 243, 205, 100),
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                child: const Text(
                  'Uredi',
                  textAlign: TextAlign.center,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
