import 'package:book_beauty/models/favorite.dart';
import 'package:book_beauty/providers/base_provider.dart';

class FavoriteProvider extends BaseProvider<Favorite> {
  FavoriteProvider() : super("FavoriteProduct");

  @override
  Favorite fromJson(data) {
    return Favorite.fromJson(data);
  }

  Future<bool> isProductFav(int productId, int userId) async {
    var uri = Uri.parse(
        '${BaseProvider.baseUrl}Product/IsProductFav?productId=$productId&userId=$userId');
    var headers = createHeaders();

    var response = await http!.get(uri, headers: headers);
    if (response.statusCode == 200) {
      if (response.body.startsWith('t', 0)) {
        return true;
      } else {
        return false;
      }
    } else {
      return false;
    }
  }
}
