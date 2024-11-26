import 'package:json_annotation/json_annotation.dart';

part 'order.g.dart';

@JsonSerializable()
class Order {
  int? orderId;
  double? totalPrice;
  DateTime? dateTime;
  int? customerId;
  String? orderNumber;
  String? status;
  String? address;

  Order({
    this.orderId,
    this.totalPrice,
    this.dateTime,
    this.customerId,
    this.orderNumber,
    this.status,
    this.address,
  });

  factory Order.fromJson(Map<String, dynamic> json) => _$OrderFromJson(json);

  Map<String, dynamic> toJson() => _$OrderToJson(this);
}
