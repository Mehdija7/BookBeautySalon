import 'package:bookbeauty_desktop/models/gender.dart';
import 'package:bookbeauty_desktop/providers/base_provider.dart';
import '../providers/auth_provider.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:core';

class GenderProvider extends BaseProvider<Gender> {
  GenderProvider() : super("Gender");

  @override
  Gender fromJson(data) {
    return Gender.fromJson(data);
  }
}
