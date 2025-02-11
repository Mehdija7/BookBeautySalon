import 'dart:convert';
import 'dart:core';
import 'package:bookbeauty_desktop/models/user.dart';
import 'package:bookbeauty_desktop/models/user_roles.dart';
import 'package:bookbeauty_desktop/providers/base_provider.dart';
import 'package:http/http.dart' as http;

class UserProvider extends BaseProvider<User> {
  UserProvider() : super("User");

  @override
  User fromJson(data) {
    return User.fromJson(data);
  }

  static int? globalUserId;
  static User? globaluser;

  static int? get getUserId => globalUserId;
  static User? get getuser => globaluser;

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

    var response = await http.post(uri, headers: headers, body: body);

    if (response.statusCode == 200) {
      var data = jsonDecode(response.body);
      User user = User.fromJson(data);
      globaluser = user;
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

  Future<List<UserRoles>> getRoles(int id) async {
    var uri = Uri.parse('${BaseProvider.baseUrl}User/$id/GetRoles');
    print("************ URI ********** $uri");

    var headers = createHeaders();
    print('*****   URI HEADERS    ******** $headers');

    var response = await http.get(uri, headers: headers);

    if (response.statusCode == 200) {
      var data = jsonDecode(response.body);

      List<UserRoles> userRoles = (data as List)
          .map((roleData) => UserRoles.fromJson(roleData))
          .toList();

      return userRoles;
    } else if (response.statusCode == 401) {
      throw Exception("Unauthorized access");
    } else {
      throw Exception("Error occurred during login");
    }
  }

  Future<List<User>> getHairdressers() async {
    final url = Uri.parse('${BaseProvider.baseUrl}GetHairdressers');

    var headers = createHeaders();

    final response = await http.get(url, headers: headers);

    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);

      return data.map((json) => User.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load users');
    }
  }

  Future<User?> addRole(int id, String namerole) async {
    final url = Uri.parse('${BaseProvider.baseUrl}User/$id/AddRole');

    var headers = createHeaders();

    var body = jsonEncode(namerole);
    print("-------------URL---------------");
    print(url);
    print("-------------HEADERS---------------");
    print(headers);
    print("-------------BODY---------------");
    print(body);
    try {
      final response = await http.post(url, headers: headers, body: body);

      if (response.statusCode == 200) {
        final Map<String, dynamic> userData = jsonDecode(response.body);
        return User.fromJson(userData);
      } else {
        print('Failed to add role: ${response.body}');
        return null;
      }
    } catch (e) {
      print('Error adding role: $e');
      return null;
    }
  }

  Future<void> deleteUserRoles(int id) async {
    final url = Uri.parse('${BaseProvider.baseUrl}DeleteUserRoles?userId=$id');
    print("DLETE URL");
    print(url);
    var headers = createHeaders();
    try {
      final response = await http.delete(url, headers: headers);

      if (response.statusCode == 200) {
        return null;
      } else {
        print('Failed to delete entity: ${response.body}');
        return null;
      }
    } catch (e) {
      print('Error deleting entity: $e');
      return null;
    }
  }
}
