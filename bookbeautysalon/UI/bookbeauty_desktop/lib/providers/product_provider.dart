import 'dart:convert';
import 'package:bookbeauty_desktop/providers/base_provider.dart';
import 'package:http/http.dart' as http;
import 'package:bookbeauty_desktop/models/product.dart';

class ProductProvider extends BaseProvider<Product> {
  ProductProvider() : super("Product");

  @override
  Product fromJson(data) {
    return Product.fromJson(data);
  }

  Future<Product> activateProduct(int id) async {
    var uri = Uri.parse('${BaseProvider.baseUrl}Product/$id/activate');
    print("************ URI ********** $uri");

    var headers = createHeaders();
    print('*****   URI HEADERS    ******** $headers');

    var response = await http.put(uri, headers: headers);
    print(
        '*****   URI RESPONSE STATUS CODE    ******** ${response.statusCode}');
    print('*****   URI RESPONSE BODY    ******** ${response.body}');

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      print("PRODUCT FROM PRODUCT PROVIDER ${Product.fromJson(data)}");
      return Product.fromJson(data);
    } else {
      throw Exception('Failed to activate product');
    }
  }

  Future<Product> hideProduct(int id) async {
    var uri = Uri.parse('${BaseProvider.baseUrl}Product/$id/hide');
    print("************ URI ********** $uri");

    var headers = createHeaders();
    print('*****   URI HEADERS    ******** $headers');

    var response = await http.put(uri, headers: headers);
    print(
        '*****   URI RESPONSE STATUS CODE    ******** ${response.statusCode}');
    print('*****   URI RESPONSE BODY    ******** ${response.body}');

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      print("PRODUCT FROM PRODUCT PROVIDER ${Product.fromJson(data)}");
      return Product.fromJson(data);
    } else {
      throw Exception('Failed to activate product');
    }
  }

  Future<Product> editProduct(int id) async {
    var uri = Uri.parse('${BaseProvider.baseUrl}Product/$id/edit');
    print("************ URI ********** $uri");

    var headers = createHeaders();
    print('*****   URI HEADERS    ******** $headers');

    var response = await http.put(uri, headers: headers);
    print(
        '*****   URI RESPONSE STATUS CODE    ******** ${response.statusCode}');
    print('*****   URI RESPONSE BODY    ******** ${response.body}');

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      print("PRODUCT FROM PRODUCT PROVIDER ${Product.fromJson(data)}");
      return Product.fromJson(data);
    } else {
      throw Exception('Failed to put product in draft state');
    }
  }
}
