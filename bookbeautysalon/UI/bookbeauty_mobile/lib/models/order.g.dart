// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'order.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Order _$OrderFromJson(Map<String, dynamic> json) => Order(
      orderId: (json['orderId'] as num?)?.toInt(),
      totalPrice: (json['totalPrice'] as num?)?.toDouble(),
      dateTime: json['dateTime'] == null
          ? null
          : DateTime.parse(json['dateTime'] as String),
      customerId: (json['customerId'] as num?)?.toInt(),
      orderNumber: json['orderNumber'] as String?,
      status: json['status'] as String?,
      orderItems: (json['orderItems'] as List<dynamic>?)
          ?.map((e) => OrderItem.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$OrderToJson(Order instance) => <String, dynamic>{
      'orderId': instance.orderId,
      'totalPrice': instance.totalPrice,
      'dateTime': instance.dateTime?.toIso8601String(),
      'customerId': instance.customerId,
      'orderNumber': instance.orderNumber,
      'status': instance.status,
      'orderItems': instance.orderItems,
    };
