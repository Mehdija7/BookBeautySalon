import 'dart:convert';
import 'package:book_beauty/models/user.dart';
import 'package:book_beauty/providers/base_provider.dart';
import 'package:flutter/material.dart';
import '../providers/auth_provider.dart';

class UserProvider extends BaseProvider<User> {
  UserProvider() : super("User");

  static int? globalUserId;

  static int? get getUserId => globalUserId;

  @override
  User fromJson(data) {
    return User.fromJson(data);
  }

  Future<User> authenticate(String username, String password) async {
    var uri = Uri.parse('${BaseProvider.baseUrl}User/Authenticate');
    print("************ URI ********** $uri");

    var headers = createHeaders();
    print('*****   URI HEADERS    ******** $headers');

    var body = jsonEncode({
      'username': username,
      'password': password,
    });

    print('*****   URI HEADERS    ******** $headers');
    print('*****   BODY    ******** $body');

    var response = await http!.post(uri, headers: headers, body: body);

    if (response.statusCode == 200) {
      var data = jsonDecode(response.body);
      User user = User.fromJson(data);
      globalUserId = user.userId;
      return user;
    } else if (response.statusCode == 401) {
      throw Exception("Wrong username or password");
    } else {
      print(
          '################################################### RESPONSE STATUS CODE ###########################################');
      print(response.statusCode.toString());
      print(
          '################################################### RESPONSE BODY ###########################################');
      print(response.body);
      print(
          '################################################### END ###########################################');

      throw Exception("Error occurred during login ");
    }
  }

  Future<List<User>> getHairdressers() async {
    final url = Uri.parse('${BaseProvider.baseUrl}GetHairdressersMobile');
    var headers = createHeaders();

    final response = await http!.get(url, headers: headers);

    print('Status Code: ${response.statusCode}');
    print('Response Body: ${response.body}');

    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);

      return data.map((json) => User.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load users');
    }
  }
}
