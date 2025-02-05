import 'dart:convert';

import 'package:book_beauty/models/order_item.dart';
import 'package:flutter/material.dart';
import 'package:flutter_swiper_null_safety/flutter_swiper_null_safety.dart';
import 'package:provider/provider.dart';
import '../models/product.dart';
import '../providers/order_item_provider.dart';
import '../providers/product_provider.dart';
import '../providers/recommend_result_provider.dart';
import '../widgets/home_card.dart';

class StartScreen extends StatefulWidget {
  const StartScreen({super.key});

  @override
  State<StartScreen> createState() => _StartScreenState();
}

class _StartScreenState extends State<StartScreen> {
  late List<Product> _allProducts = [];
  final ProductProvider productProvider = ProductProvider();
  final RecommendResultProvider recommendResultProvider =
      RecommendResultProvider();
  bool _isLoading = true;

  Future<void> _fetchProducts(List<OrderItem> orderItems) async {
    try {
      if (orderItems.isEmpty) {
        final products = await productProvider.get();
        var p = products.result;
        setState(() {
          _allProducts = p.take(3).toList();
          _isLoading = false;
        });
      } else {
        final firstOrderItem = orderItems.first;
        final recommendResult = await recommendResultProvider.get();
        final recommendations = recommendResult.result
            .where((x) => x.productId == firstOrderItem.product!.productId)
            .toList();

        if (recommendations.isNotEmpty) {
          final matchingRecommendation = recommendations.first;
          final recommendedProducts = await Future.wait([
            productProvider.getById(matchingRecommendation.firstproductId!),
            productProvider.getById(matchingRecommendation.secondproductId!),
            productProvider.getById(matchingRecommendation.thirdproductId!),
          ]);

          setState(() {
            _allProducts = recommendedProducts;
            _isLoading = false;
          });
        } else {
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
            content: Text("No matching recommendations found"),
          ));
        }
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text("Something went wrong. Please try again."),
      ));
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<OrderItemProvider>(
      builder: (context, orderItemProvider, child) {
        if (_isLoading) {
          _fetchProducts(orderItemProvider.orderItems);
        }

        return Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  color:
                      const Color.fromARGB(255, 190, 187, 168).withOpacity(0.4),
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
                        _isLoading
                            ? const CircularProgressIndicator()
                            : _allProducts.isNotEmpty
                                ? SizedBox(
                                    height: 220,
                                    width: 342,
                                    child: Swiper(
                                      itemCount: _allProducts.length,
                                      autoplay: true,
                                      autoplayDelay: 5000,
                                      pagination: SwiperPagination(
                                        builder: DotSwiperPaginationBuilder(
                                          activeColor: Colors.blueGrey,
                                          color:
                                              Colors.blueGrey.withOpacity(0.5),
                                        ),
                                      ),
                                      control: const SwiperControl(
                                          color: Color.fromARGB(
                                              255, 70, 107, 126)),
                                      itemBuilder: (context, index) {
                                        return Card(
                                          elevation: 4,
                                          shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(12),
                                          ),
                                          child: ClipRRect(
                                            borderRadius:
                                                BorderRadius.circular(12),
                                            child: _allProducts[index].image !=
                                                    null
                                                ? Image.memory(
                                                    base64Decode(
                                                        _allProducts[index]
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
                                  )
                                : const Text("Nema proizvoda za prikazati"),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}
