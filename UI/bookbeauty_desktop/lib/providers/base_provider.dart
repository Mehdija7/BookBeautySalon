import 'dart:convert';

import 'package:bookbeauty_desktop/models/search_result.dart';
import 'package:bookbeauty_desktop/providers/auth_provider.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:http/http.dart';

abstract class BaseProvider<T> with ChangeNotifier {
  static String? _baseUrl;
  String _endpoint = "";

  BaseProvider(String endpoint) {
    _endpoint = endpoint;
    _baseUrl = const String.fromEnvironment("baseUrl",
        defaultValue: "http://localhost:5273/");
  }
  static String get baseUrl => _baseUrl!;

  Future<SearchResult<T>> get({dynamic filter}) async {
    var url = "$_baseUrl$_endpoint";

    if (filter != null) {
      var queryString = getQueryString(filter);
      url = "$url?$queryString";
    }

    var uri = Uri.parse(url);
    var headers = createHeaders();

    var response = await http.get(uri, headers: headers);

    if (isValidResponse(response)) {
      var data = jsonDecode(response.body);

      var result = SearchResult<T>();

      result.count = data['count'];

      for (var item in data['resultList']) {
        print(item);
        print(fromJson(item));
        result.result.add(fromJson(item));
      }
      print("RESULTSSS ${result.result}");
      return result;
    } else {
      print("*************** ERROR OCCURED DURING GET METHOD ****************");
      throw Exception("Unknown error");
    }
  }

  Future<T> insert(dynamic request) async {
    var url = "$_baseUrl$_endpoint";
    var uri = Uri.parse(url);
    var headers = createHeaders();

    print(
        "-----------------------------    URI    ----------------------------------------------- ");
    print(uri);

    print(
        "-----------------------------  HEADERS ----------------------------------------------- ");
    print(headers);

    var jsonRequest = jsonEncode(request);

    print(
        "-----------------------------  REQUEST ----------------------------------------------- ");
    print(request);

    var response = await http.post(uri, headers: headers, body: jsonRequest);

    print("||||||||||||||||||||| RESPONSE |||||||||||||||||||||||||");
    if (isValidResponse(response)) {
      var data = jsonDecode(response.body);
      return fromJson(data);
    } else {
      throw Exception("Unknown error");
    }
  }

  Future<T> update(int id, [dynamic request]) async {
    var url = "$_baseUrl$_endpoint/$id";
    var uri = Uri.parse(url);
    var headers = createHeaders();

    var jsonRequest = jsonEncode(request);
    var response = await http.put(uri, headers: headers, body: jsonRequest);

    if (isValidResponse(response)) {
      var data = jsonDecode(response.body);
      return fromJson(data);
    } else {
      throw Exception("Unknown error");
    }
  }

  T fromJson(data) {
    throw Exception("Method not implemented");
  }

  bool isValidResponse(Response response) {
    if (response.statusCode < 299) {
      return true;
    } else if (response.statusCode == 401) {
      throw Exception("Unauthorized");
    } else {
      print(response.body);
      throw Exception("Something bad happened please try again");
    }
  }

  Map<String, String> createHeaders() {
    String username = AuthProvider.username ?? "";
    String password = AuthProvider.password ?? "";

    print("passed creds: $username, $password");

    String basicAuth =
        "Basic ${base64Encode(utf8.encode('$username:$password'))}";

    var headers = {
      "Content-Type": "application/json",
      "Authorization": basicAuth
    };

    return headers;
  }

  String getQueryString(Map params,
      {String prefix = '&', bool inRecursion = false}) {
    String query = '';
    params.forEach((key, value) {
      if (inRecursion) {
        if (key is int) {
          key = '[$key]';
        } else if (value is List || value is Map) {
          key = '.$key';
        } else {
          key = '.$key';
        }
      }
      if (value is String || value is int || value is double || value is bool) {
        var encoded = value;
        if (value is String) {
          encoded = Uri.encodeComponent(value);
        }
        query += '$prefix$key=$encoded';
      } else if (value is DateTime) {
        query += '$prefix$key=${(value).toIso8601String()}';
      } else if (value is List || value is Map) {
        if (value is List) value = value.asMap();
        value.forEach((k, v) {
          query +=
              getQueryString({k: v}, prefix: '$prefix$key', inRecursion: true);
        });
      }
    });
    return query;
  }

  Future<T?> getById(int id) async {
    final url = '$_baseUrl$_endpoint/$id';
    print("//////////// URL FROM BASE PROVIDER /////////////// $url");
    try {
      var uri = Uri.parse(url);
      var headers = createHeaders();

      var response = await http.get(uri, headers: headers);

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);
        print(data);
        return fromJson(data);
      } else {
        debugPrint(
            'Failed to load entity. Status code: ${response.statusCode}');
        return null;
      }
    } catch (e) {
      debugPrint('Error fetching entity: $e');
      return null;
    }
  }
  /*Future<T> getById({required int id}) async {
    var url = "$_baseUrl$_endpoint";
    var uri = Uri.parse('${url}?id=$id');
    var headers = createHeaders();

    var response = await http.get(uri, headers: headers);

    Future<T> result;
    if (isValidResponse(response)) {
      var data = jsonDecode(response.body);
      result = data.fromJson();
      print("RESULTSSS ${result}");
      return result;
    } else {
      print("*************** ERROR OCCURED DURING GET METHOD ****************");
      throw Exception("Unknown error");
    }
  }*/
}