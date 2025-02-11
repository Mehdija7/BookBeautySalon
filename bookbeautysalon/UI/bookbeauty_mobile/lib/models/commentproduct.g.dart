// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'commentproduct.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CommentProduct _$CommentProductFromJson(Map<String, dynamic> json) =>
    CommentProduct(
      commentProductId: (json['commentProductId'] as num?)?.toInt(),
      commentDate: json['commentDate'] == null
          ? null
          : DateTime.parse(json['commentDate'] as String),
      commentText: json['commentText'] as String?,
      userId: (json['userId'] as num?)?.toInt(),
      productId: (json['productId'] as num?)?.toInt(),
      product: json['product'] == null
          ? null
          : Product.fromJson(json['product'] as Map<String, dynamic>),
      user: json['user'] == null
          ? null
          : User.fromJson(json['user'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$CommentProductToJson(CommentProduct instance) =>
    <String, dynamic>{
      'commentProductId': instance.commentProductId,
      'commentDate': instance.commentDate?.toIso8601String(),
      'commentText': instance.commentText,
      'userId': instance.userId,
      'productId': instance.productId,
      'product': instance.product,
      'user': instance.user,
    };
