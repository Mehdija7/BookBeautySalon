import 'package:book_beauty/models/product.dart';
import 'package:book_beauty/providers/base_provider.dart';

class ProductProvider extends BaseProvider<Product> {
  ProductProvider() : super("Product");

  @override
  Product fromJson(data) {
    return Product.fromJson(data);
  }
}
