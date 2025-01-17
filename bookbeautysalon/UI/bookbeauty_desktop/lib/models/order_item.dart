import 'package:json_annotation/json_annotation.dart';

part 'order_item.g.dart';

@JsonSerializable()
class OrderItem {
  int? orderItemId;
  int? quantity;
  int? productId;
  int? orderId;

  OrderItem({this.orderItemId, this.quantity, this.productId, this.orderId});

  factory OrderItem.fromJson(Map<String, dynamic> json) =>
      _$OrderItemFromJson(json);

  Map<String, dynamic> toJson() => _$OrderItemToJson(this);
}
