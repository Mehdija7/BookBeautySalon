import 'dart:convert';
import 'package:book_beauty/models/favoriteproduct.dart';
import 'package:book_beauty/providers/base_provider.dart';
import 'package:http/http.dart' as http;

class FavoriteProductProvider extends BaseProvider<FavoriteProduct> {
  FavoriteProductProvider() : super("FavoriteProduct");

  static bool? globalIsFavorite;

  @override
  FavoriteProduct fromJson(data) {
    return FavoriteProduct.fromJson(data);
  }

  Future<bool> isProductFav(int productId, int userId) async {
    var uri = Uri.parse(
        '${BaseProvider.baseUrl}Product/IsProductFav?productId=$productId&userId=$userId');
    var headers = createHeaders();

    var response = await http.get(uri, headers: headers);

    if (response.statusCode == 200) {
      final isFav = jsonDecode(response.body) as bool;
      globalIsFavorite = isFav;
      return isFav;
    } else {
      globalIsFavorite = false;
      return false;
    }
  }

  Future<void> toggleFavorite(bool value) async {
    globalIsFavorite = value;
  }
}
