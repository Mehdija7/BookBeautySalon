import 'package:json_annotation/json_annotation.dart';

part 'news.g.dart';

@JsonSerializable()
class News {
  int? newsId;
  String? title;
  String? text;
  DateTime? dateTime;

  News({this.newsId, this.title, this.text, this.dateTime});

  factory News.fromJson(Map<String, dynamic> json) => _$NewsFromJson(json);

  Map<String, dynamic> toJson() => _$NewsToJson(this);
}
