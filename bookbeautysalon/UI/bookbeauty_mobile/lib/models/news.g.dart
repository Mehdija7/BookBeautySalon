// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'news.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

News _$NewsFromJson(Map<String, dynamic> json) => News(
      newsId: (json['newsId'] as num?)?.toInt(),
      title: json['title'] as String?,
      text: json['text'] as String?,
      dateTime: json['dateTime'] == null
          ? null
          : DateTime.parse(json['dateTime'] as String),
      hairdresserId: (json['hairdresserId'] as num?)?.toInt(),
      hairdresser: json['hairdresser'] == null
          ? null
          : User.fromJson(json['hairdresser'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$NewsToJson(News instance) => <String, dynamic>{
      'newsId': instance.newsId,
      'title': instance.title,
      'text': instance.text,
      'dateTime': instance.dateTime?.toIso8601String(),
      'hairdresserId': instance.hairdresserId,
      'hairdresser': instance.hairdresser,
    };
