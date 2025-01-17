// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'review.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Review _$ReviewFromJson(Map<String, dynamic> json) => Review(
      reviewId: (json['reviewId'] as num?)?.toInt(),
      mark: (json['mark'] as num?)?.toInt(),
      productId: (json['productId'] as num?)?.toInt(),
      userId: (json['userId'] as num?)?.toInt(),
      date:
          json['date'] == null ? null : DateTime.parse(json['date'] as String),
    );

Map<String, dynamic> _$ReviewToJson(Review instance) => <String, dynamic>{
      'reviewId': instance.reviewId,
      'mark': instance.mark,
      'productId': instance.productId,
      'userId': instance.userId,
      'date': instance.date?.toIso8601String(),
    };
