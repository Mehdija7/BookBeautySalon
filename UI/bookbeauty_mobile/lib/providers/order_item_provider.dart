import 'package:book_beauty/providers/base_provider.dart';
import 'package:book_beauty/models/order_item.dart';

class OrderItemProvider extends BaseProvider<OrderItem> {
  OrderItemProvider() : super("OrderItem");

  @override
  OrderItem fromJson(data) {
    return OrderItem.fromJson(data);
  }
}
