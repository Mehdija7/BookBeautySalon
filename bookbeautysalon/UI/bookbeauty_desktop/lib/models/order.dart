import 'package:bookbeauty_desktop/models/order_item.dart';
import 'package:bookbeauty_desktop/models/user.dart';
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
  User? customer;
  List<OrderItem>? orderItems;
  Order(
      {this.orderId,
      this.totalPrice,
      this.dateTime,
      this.customerId,
      this.orderNumber,
      this.status,
      this.customer,
      this.orderItems});

  factory Order.fromJson(Map<String, dynamic> json) => _$OrderFromJson(json);

  Map<String, dynamic> toJson() => _$OrderToJson(this);
}
