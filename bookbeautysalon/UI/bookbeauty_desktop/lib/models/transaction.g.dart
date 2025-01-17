// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'transaction.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Transaction _$TransactionFromJson(Map<String, dynamic> json) => Transaction(
      transactionId: (json['transactionId'] as num?)?.toInt(),
      name: json['name'] as String?,
      orderId: (json['orderId'] as num?)?.toInt(),
      price: (json['price'] as num?)?.toDouble(),
      status: json['status'] as String?,
    );

Map<String, dynamic> _$TransactionToJson(Transaction instance) =>
    <String, dynamic>{
      'transactionId': instance.transactionId,
      'name': instance.name,
      'orderId': instance.orderId,
      'price': instance.price,
      'status': instance.status,
    };
