import 'package:bookbeauty_desktop/models/product.dart';
import 'package:bookbeauty_desktop/widgets/chart/chart.dart';
import 'package:flutter/material.dart';

class ReportScreen extends StatefulWidget {
  const ReportScreen({super.key});

  @override
  State<StatefulWidget> createState() {
    return _ReportScreen();
  }
}

class _ReportScreen extends State<ReportScreen> {
  final List<Product> _registeredProducts = [
    Product(
        id: '1', title: 'Shampoo', amount: 20.99, category: Category.shampoo),
    Product(id: '2', title: 'Cream', amount: 10, category: Category.cream),
    Product(id: '3', title: 'Oil', amount: 38.70, category: Category.oil)
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Izvjestaji"),
      ),
      body: Column(
        children: [
          Chart(products: _registeredProducts),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Padding(
                padding: EdgeInsets.only(right: 15),
                child: ElevatedButton(
                  onPressed: () {},
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.resolveWith<Color?>(
                      (Set<MaterialState> states) {
                        if (states.contains(MaterialState.pressed)) {
                          return Color.fromARGB(255, 102, 102, 102);
                        }
                        return Color.fromARGB(255, 146, 146, 146);
                      },
                    ),
                    foregroundColor: MaterialStateProperty.all<Color>(
                        const Color.fromARGB(255, 245, 245, 245)),
                  ),
                  child: Text('Printaj'),
                ),
              ),
            ],
          ),
          const SizedBox(height: 100),
          Chart(products: _registeredProducts),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Padding(
                padding: EdgeInsets.only(right: 15),
                child: ElevatedButton(
                  onPressed: () {},
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.resolveWith<Color?>(
                      (Set<MaterialState> states) {
                        if (states.contains(MaterialState.pressed)) {
                          return Color.fromARGB(255, 102, 102, 102);
                        }
                        return Color.fromARGB(255, 146, 146, 146);
                      },
                    ),
                    foregroundColor: MaterialStateProperty.all<Color>(
                        const Color.fromARGB(255, 245, 245, 245)),
                  ),
                  child: Text('Printaj'),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
