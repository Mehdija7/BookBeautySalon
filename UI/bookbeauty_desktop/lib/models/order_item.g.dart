// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'order_item.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

OrderItem _$OrderItemFromJson(Map<String, dynamic> json) => OrderItem(
      orderItemId: (json['orderItemId'] as num?)?.toInt(),
      quantity: (json['quantity'] as num?)?.toInt(),
      productId: (json['productId'] as num?)?.toInt(),
      orderId: (json['orderId'] as num?)?.toInt(),
    );

Map<String, dynamic> _$OrderItemToJson(OrderItem instance) => <String, dynamic>{
      'orderItemId': instance.orderItemId,
      'quantity': instance.quantity,
      'productId': instance.productId,
      'orderId': instance.orderId,
    };
