import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:book_beauty/models/service.dart';
import 'package:book_beauty/providers/base_provider.dart';

class ServiceProvider extends BaseProvider<Service> {
  ServiceProvider() : super("Service");

  @override
  Service fromJson(data) {
    return Service.fromJson(data);
  }
}
