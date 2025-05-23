import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

Uint8List _getImageBinary(dynamicList) {
  List<int> intList = dynamicList.cast<int>().toList();
  Uint8List data = Uint8List.fromList(intList);
  return data;
}

class Authorization {
  static String? username;
  static String? password;
}

class Info {
  static String? name;
  static String? surname;
  static String? image;
  static int? id;
}

Image imageFromBase64String(String base64Image) {
  return Image.memory(base64Decode(base64Image));
}

String formatNumber(dynamic) {
  var f = NumberFormat('###,00');

  if (dynamic == null) {
    return "";
  }

  return f.format(dynamic);
}
