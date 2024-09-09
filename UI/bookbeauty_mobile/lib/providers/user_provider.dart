import 'dart:convert';
import 'package:book_beauty/models/user.dart';
import 'package:book_beauty/providers/base_provider.dart';
import 'package:flutter/material.dart';
import '../providers/auth_provider.dart';

class UserProvider extends BaseProvider<User> {
  UserProvider() : super("User");

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
}
