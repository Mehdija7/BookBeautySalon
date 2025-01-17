// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'product.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Product _$ProductFromJson(Map<String, dynamic> json) => Product(
      productId: (json['productId'] as num?)?.toInt(),
      name: json['name'] as String?,
      price: (json['price'] as num?)?.toDouble(),
      description: json['description'] as String?,
      categoryId: (json['categoryId'] as num?)?.toInt(),
      stateMachine: json['stateMachine'] as String?,
      image: json['image'] as String?,
    );

Map<String, dynamic> _$ProductToJson(Product instance) => <String, dynamic>{
      'productId': instance.productId,
      'name': instance.name,
      'price': instance.price,
      'description': instance.description,
      'categoryId': instance.categoryId,
      'stateMachine': instance.stateMachine,
      'image': instance.image,
    };
