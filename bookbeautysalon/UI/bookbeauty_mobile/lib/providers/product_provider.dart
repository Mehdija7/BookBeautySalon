import 'dart:convert';
import 'package:book_beauty/models/product.dart';
import 'package:book_beauty/providers/base_provider.dart';
import 'package:http/http.dart' as http;

class ProductProvider extends BaseProvider<Product> {
  ProductProvider() : super("Product");

  @override
  Product fromJson(data) {
    return Product.fromJson(data);
  }
}
