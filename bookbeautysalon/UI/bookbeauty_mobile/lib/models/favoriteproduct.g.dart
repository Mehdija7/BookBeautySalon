// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'favoriteproduct.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

FavoriteProduct _$FavoriteProductFromJson(Map<String, dynamic> json) =>
    FavoriteProduct(
      favoriteProductsId: (json['favoriteProductsId'] as num?)?.toInt(),
      userId: (json['userId'] as num?)?.toInt(),
      productId: (json['productId'] as num?)?.toInt(),
      addingDate: json['addingDate'] == null
          ? null
          : DateTime.parse(json['addingDate'] as String),
      product: json['product'] == null
          ? null
          : Product.fromJson(json['product'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$FavoriteProductToJson(FavoriteProduct instance) =>
    <String, dynamic>{
      'favoriteProductsId': instance.favoriteProductsId,
      'userId': instance.userId,
      'productId': instance.productId,
      'addingDate': instance.addingDate?.toIso8601String(),
      'product': instance.product,
    };
