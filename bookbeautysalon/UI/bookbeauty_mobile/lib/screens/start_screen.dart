import 'dart:convert';

import 'package:book_beauty/models/order_item.dart';
import 'package:book_beauty/models/search_result.dart';
import 'package:book_beauty/providers/order_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_swiper_null_safety/flutter_swiper_null_safety.dart';
import 'package:provider/provider.dart';
import '../models/product.dart';
import '../providers/order_item_provider.dart';
import '../providers/product_provider.dart';
import '../widgets/home_card.dart';

class StartScreen extends StatefulWidget {
  const StartScreen({super.key});

  @override
  State<StartScreen> createState() => _StartScreenState();
}

class _StartScreenState extends State<StartScreen> {
  late List<Product> _recommendProducts = [];
  final ProductProvider productProvider = ProductProvider();
  final OrderProvider orderProvider = OrderProvider();
  late OrderItemProvider orderItemProvider;

  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    orderItemProvider = Provider.of<OrderItemProvider>(context);
  }

  Future<void> _fetchProducts() async {
    var list = orderItemProvider.orderItems ?? [];
    if (list.isEmpty) {
      return;
    }
    Product product = list[0].product!;
    var result = await productProvider.getRecommended(product.productId!);
    setState(() {
      _recommendProducts = result.result;
    });
  }

  @override
  Widget build(BuildContext context) {
    /* return Consumer<OrderItemProvider>(
      builder: (context, orderItemProvider, child) {
        if (_isLoading) {
          _fetchProducts();
        }
*/
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Expanded(
          child: Container(
            decoration: BoxDecoration(
              color: const Color.fromARGB(255, 190, 187, 168).withOpacity(0.4),
            ),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    const Text(
                      'Dobro dosli u aplikaciju BookBeauty, pogledajte nase usluge i proizvode.',
                      style: TextStyle(fontSize: 18),
                    ),
                    const HomeCard(
                      title: 'Naše usluge',
                      image: 'assets/images/pranje_kose.jpg',
                      id: 1,
                    ),
                    const HomeCard(
                      title: 'Naši proizvodi',
                      image: 'assets/images/proizvodi.jpg',
                      id: 2,
                    ),
                    const SizedBox(height: 6),
                    const Text(
                      "Preporuke za vas",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 6),
                    /* SizedBox(
                                height: 220,
                                width: 342,
                                child: Swiper(
                                  itemCount: 3,
                                  autoplay: true,
                                  autoplayDelay: 5000,
                                  pagination: SwiperPagination(
                                    builder: DotSwiperPaginationBuilder(
                                      activeColor: Colors.blueGrey,
                                      color: Colors.blueGrey.withOpacity(0.5),
                                    ),
                                  ),
                                  control: const SwiperControl(
                                      color: Color.fromARGB(255, 70, 107, 126)),
                                  itemBuilder: (context, index) {
                                    return Card(
                                      elevation: 4,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                      child: ClipRRect(
                                        borderRadius: BorderRadius.circular(12),
                                        child: _recommendProducts[index]
                                                    .image !=
                                                null
                                            ? Image.memory(
                                                base64Decode(
                                                    _recommendProducts[index]
                                                        .image!),
                                                width: 100,
                                                height: 200,
                                                fit: BoxFit.cover,
                                              )
                                            : Image.asset(
                                                "assets/images/logoBB.png",
                                                width: 100,
                                                height: 200,
                                                fit: BoxFit.cover,
                                              ),
                                      ),
                                    );
                                  },
                                ),
                              )*/
                    const Text("Nema proizvoda za prikazati"),
                  ],
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
