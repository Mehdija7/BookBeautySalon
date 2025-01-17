import 'package:bookbeauty_desktop/models/order_item.dart';
import 'package:bookbeauty_desktop/providers/base_provider.dart';

class OrderItemProvider extends BaseProvider<OrderItem> {
  OrderItemProvider() : super("OrderItem");

  @override
  OrderItem fromJson(data) {
    return OrderItem.fromJson(data);
  }
}
