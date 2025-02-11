import 'package:bookbeauty_desktop/models/user.dart';
import 'package:json_annotation/json_annotation.dart';

part 'news.g.dart';

@JsonSerializable()
class News {
  final int? newsId;
  final String? title;
  final String? text;
  final DateTime? dateTime;
  final int? hairdresserId;
  final User? hairdresser;

  News({
    this.newsId,
    this.title,
    this.text,
    this.dateTime,
    this.hairdresserId,
    this.hairdresser,
  });

  factory News.fromJson(Map<String, dynamic> json) => _$NewsFromJson(json);

  Map<String, dynamic> toJson() => _$NewsToJson(this);
}
