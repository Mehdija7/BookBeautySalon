// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'hairdresser.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

HairDresser _$HairDresserFromJson(Map<String, dynamic> json) => HairDresser(
      hairdresserId: (json['hairdresserId'] as num?)?.toInt(),
      startDate: json['startDate'] == null
          ? null
          : DateTime.parse(json['startDate'] as String),
      endDate: json['endDate'] == null
          ? null
          : DateTime.parse(json['endDate'] as String),
    );

Map<String, dynamic> _$HairDresserToJson(HairDresser instance) =>
    <String, dynamic>{
      'hairdresserId': instance.hairdresserId,
      'startDate': instance.startDate?.toIso8601String(),
      'endDate': instance.endDate?.toIso8601String(),
    };
