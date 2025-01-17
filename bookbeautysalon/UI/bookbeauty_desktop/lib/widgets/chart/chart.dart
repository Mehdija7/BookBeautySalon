import 'package:bookbeauty_desktop/models/category.dart';
import 'package:bookbeauty_desktop/models/product.dart';
import 'package:flutter/material.dart';
import 'productTest.dart';
import './chart_bar.dart';

class Chart extends StatelessWidget {
  const Chart({super.key, required this.products, required this.categories});

  final List<Product> products;
  final List<Category> categories;

  List<ProductBucket> get buckets {
    return categories.map((category) {
      return ProductBucket.forCategory(products, category);
    }).toList();
  }

  double get maxTotalSum {
    double maxTotalSum = 0;
    for (final bucket in buckets) {
      if (bucket.totalSum > maxTotalSum) {
        maxTotalSum = bucket.totalSum;
      }
    }
    return maxTotalSum;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.symmetric(
        vertical: 16,
        horizontal: 8,
      ),
      width: double.infinity,
      height: 180,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          color: const Color.fromARGB(255, 255, 255, 255)),
      child: Column(
        children: [
          Expanded(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                for (final bucket in buckets)
                  ChartBar(
                    fill: bucket.totalSum == 0
                        ? 0
                        : (bucket.totalSum / maxTotalSum).clamp(0.03, 1.0),
                    totalSum: bucket.totalSum,
                  )
              ],
            ),
          ),
          const SizedBox(height: 12),
          Row(
            children: buckets
                .map(
                  (bucket) => Expanded(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 15),
                      child: Center(
                        child: Text(
                          bucket.category.name!,
                          style: const TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                          ),
                          //categoryName[bucket.category].toString(),
                        ),
                      ),
                    ),
                  ),
                )
                .toList(),
          )
        ],
      ),
    );
  }
}
