import 'dart:convert';
import 'package:book_beauty/models/gender.dart';
import 'package:book_beauty/providers/base_provider.dart';
import 'package:http/http.dart' as http;

class GenderProvider extends BaseProvider<Gender> {
  GenderProvider() : super("Gender");

  @override
  Gender fromJson(data) {
    return Gender.fromJson(data);
  }

  Future<List<Gender>> fetchGenders() async {
    var uri = Uri.parse('${BaseProvider.baseUrl}Gender/getGenders');
    print(uri);
    final response = await http.get(uri);

    print(response.statusCode);
    if (response.statusCode == 200) {
      List<dynamic> genderJson = json.decode(response.body);
      return genderJson.map((json) => Gender.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load genders');
    }
  }
}
