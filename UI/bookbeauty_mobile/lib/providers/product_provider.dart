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

  Future<List<Product>> getMobile() async {
    var uri = Uri.parse('${BaseProvider.baseUrl}Product/Mobile');

    var headers = createHeaders();

    print('****************** URI *******************************************');
    print(uri);

    var response = await http.get(uri, headers: headers);

    if (isValidResponse(response)) {
      print("response: ${response.request}");

      print("RESPONSE BODYYYYYYYYYYYYYYYYYYYY");
      print(" ${response.body}");
      List<Product> products = (jsonDecode(response.body) as List)
          .map((productJson) => Product.fromJson(productJson))
          .toList();
      print("++++++++++++++++++++++++ DATA +++++++++++++++++++++++++++++");
      print(" ${products}");

      return products;
    } else {
      throw new Exception("Unknown error");
    }
  }
}
