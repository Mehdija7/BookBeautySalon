// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'recommend_result.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

RecommendResult _$RecommendResultFromJson(Map<String, dynamic> json) =>
    RecommendResult(
      recommendResultId: (json['recommendResultId'] as num?)?.toInt(),
      firstproductId: (json['firstproductId'] as num?)?.toInt(),
      secondproductId: (json['secondproductId'] as num?)?.toInt(),
      thirdproductId: (json['thirdproductId'] as num?)?.toInt(),
    );

Map<String, dynamic> _$RecommendResultToJson(RecommendResult instance) =>
    <String, dynamic>{
      'recommendResultId': instance.recommendResultId,
      'firstproductId': instance.firstproductId,
      'secondproductId': instance.secondproductId,
      'thirdproductId': instance.thirdproductId,
    };