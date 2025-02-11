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

class StartScreen extends StatelessWidget {
  const StartScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Expanded(
          child: Container(
            decoration: BoxDecoration(
              color: const Color.fromARGB(255, 190, 187, 168).withOpacity(0.4),
            ),
            child: const Padding(
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
