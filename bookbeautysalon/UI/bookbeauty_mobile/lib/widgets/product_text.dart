import 'dart:convert';

import 'package:book_beauty/models/order_item.dart';
import 'package:book_beauty/models/product.dart';
import 'package:book_beauty/providers/favoriteproduct_provider.dart';
import 'package:book_beauty/providers/order_item_provider.dart';
import 'package:book_beauty/providers/product_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_swiper_null_safety/flutter_swiper_null_safety.dart';
import 'package:provider/provider.dart';

class ProductText extends StatefulWidget {
  const ProductText({super.key, required this.product});

  final Product product;

  @override
  State<ProductText> createState() => _ProductTextState();
}

class _ProductTextState extends State<ProductText> {
  bool isLoading = false;
  @override
  void initState() {
    super.initState();
  }

  void buy() {
    final provider = Provider.of<OrderItemProvider>(context, listen: false);
    provider.addProduct(widget.product);
    _recommendDialog(widget.product);
  }

  Future<void> _recommendDialog(Product product) async {
    final productProvider = ProductProvider();
    List<Product> recommendProducts = [];
    var resultRec = await productProvider.getRecommended(product.productId!);
    recommendProducts = resultRec.result;

    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            'Možda Vam se svidi i ovaj proizvod',
            textAlign: TextAlign.center,
          ),
          content: recommendProducts.isNotEmpty
              ? SizedBox(
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
                          child: recommendProducts[index].image != null
                              ? Image.memory(
                                  base64Decode(recommendProducts[index].image!),
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
          actions: <Widget>[
            Center(
              child: TextButton(
                child: Text('OK'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return isLoading
        ? const Center(child: CircularProgressIndicator())
        : Column(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 2, horizontal: 5),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      widget.product.name!,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(fontSize: 16, color: Colors.black),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 5),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text(
                      '${widget.product.price!} BAM',
                      style: const TextStyle(
                          fontSize: 20, fontWeight: FontWeight.bold),
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
                        padding: const EdgeInsets.symmetric(
                            vertical: 10, horizontal: 30),
                        backgroundColor:
                            const Color.fromARGB(255, 134, 165, 185),
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
                  ],
                ),
              ),
            ],
          );
  }
}
