
import 'package:bookbeauty_desktop/models/category.dart';
import 'package:bookbeauty_desktop/models/product.dart';

class ProductBucket {
  const ProductBucket({required this.category, required this.products});

  final Category category;
  final List<Product> products;

  ProductBucket.forCategory(List<Product> allProducts, this.category)
      : products = allProducts
            .where((e) => e.categoryId == category.categoryId)
            .toList();

  double get totalSum {
    double sum = 0;
    for (final product in products) {
      sum += product.price!;
    }
    return sum;
  }
}
