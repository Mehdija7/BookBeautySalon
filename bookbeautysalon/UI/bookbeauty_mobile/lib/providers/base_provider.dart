import 'dart:convert';
import 'package:book_beauty/models/search_result.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:http/http.dart';

import '../utils.dart';

abstract class BaseProvider<T> with ChangeNotifier {
  static String? baseUrl;
  String _endpoint = "";

  BaseProvider(String endpoint) {
    _endpoint = endpoint;
    baseUrl = const String.fromEnvironment("baseUrl",
        defaultValue: "http://10.0.2.2:5266/");
  }

  Future<SearchResult<T>> get({dynamic filter}) async {
    var url = "$baseUrl$_endpoint";

    if (filter != null) {
      var querryString = getQueryString(filter);
      url = "$url?$querryString";
    }

    var uri = Uri.parse(url);
    var headers = createHeaders();

    print("--------- base url in get method ----------");
    print(uri);
    print(headers.toString());
    var response = await http.get(uri, headers: headers);

    if (isValidResponse(response)) {
      var data = jsonDecode(response.body);

      var result = SearchResult<T>();
      print(response.statusCode);
      print(data);
      result.count = data['count'];
      print(result.count);
      for (var item in data['resultList']) {
        result.result.add(fromJson(item));
      }
      print(result.result);
      return result;
    } else {
      throw new Exception("Upps, something went wrong");
    }
  }
  Future<SearchResult<T>> getRecommended(int id) async {
    var url = "$baseUrl$_endpoint/$id/recommend";

    var uri = Uri.parse(url);
    var headers = createHeaders();

    var response = await http.get(uri, headers: headers);

    if (response.body == "") {
      SearchResult<T> newList = SearchResult();
      return newList;
    }

    if (isValidResponse(response)) {
      var data = jsonDecode(response.body);

      var result = SearchResult<T>();

      result.count = 3;

      for (var item in data) {
        result.result.add(fromJson(item));
      }

      return result;
    } else {
      throw  Exception("Upps, something went wrong");
    }
  }

  Future<T> getById(int id) async {
    var url = "$baseUrl$_endpoint/$id";
    var uri = Uri.parse(url);
    var headers = createHeaders();

    var response = await http.get(uri, headers: headers);

    if (isValidResponse(response)) {
      var data = jsonDecode(response.body);
      return fromJson(data);
    } else {
      throw  Exception("Unknown error");
    }
  }

  Future<T> insert(dynamic request) async {
    var url = "$baseUrl$_endpoint";
    var uri = Uri.parse(url);
    var headers = createHeaders();
    print(request);
    var jsonRequest = jsonEncode(request);
    print(jsonRequest);
    var response = await http.post(uri, headers: headers, body: jsonRequest);

    print("|||||||||| RESPONSE ||||||||||||||||||||");
    print(response.statusCode);
    print(response.body);
    if (isValidResponse(response)) {
      var data = jsonDecode(response.body);
      return fromJson(data);
    } else {
      throw  Exception("Unknown error");
    }
  }

  T fromJson(data) {
    throw Exception("Method not implemented");
  }

  Future<T> update(int id, [dynamic request]) async {
    var url = "$baseUrl$_endpoint/$id";
    var uri = Uri.parse(url);
    var headers = createHeaders();

    var jsonRequest = jsonEncode(request);
    print('TEST');
    print(jsonRequest);
    var response = await http.put(uri, headers: headers, body: jsonRequest);

    if (isValidResponse(response)) {
      var data = jsonDecode(response.body);
      return fromJson(data);
    } else {
      throw  Exception("Unknown error");
    }
  }

  Future<T> delete(int id) async {
    var url = "$baseUrl$_endpoint?id=$id";
    var uri = Uri.parse(url);
    var headers = createHeaders();

    try {
      var response = await http.delete(uri, headers: headers);
      var data = jsonDecode(response.body);
      return fromJson(data);
    } catch (e) {
        throw  Exception("Unknown error");
      
    }

    
  }

  bool isValidResponse(Response response) {
    if (response.statusCode < 299) {
      return true;
    } else if (response.statusCode == 401) {
      throw  Exception("Unauthorized");
    } else {
      throw  Exception("Upps, something went wrong");
    }
  }

  Map<String, String> createHeaders() {
    String username = Authorization.username ?? "";
    String password = Authorization.password ?? "";

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
        query += '$prefix$key=${value.toIso8601String()}';
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
}
