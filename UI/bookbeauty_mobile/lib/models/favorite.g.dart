// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'favorite.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Favorite _$FavoriteFromJson(Map<String, dynamic> json) => Favorite(
      userId: (json['userId'] as num?)?.toInt(),
      productId: (json['productId'] as num?)?.toInt(),
      addingDate: json['addingDate'] == null
          ? null
          : DateTime.parse(json['addingDate'] as String),
      product: json['product'] == null
          ? null
          : Product.fromJson(json['product'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$FavoriteToJson(Favorite instance) => <String, dynamic>{
      'userId': instance.userId,
      'productId': instance.productId,
      'addingDate': instance.addingDate?.toIso8601String(),
      'product': instance.product,
    };
