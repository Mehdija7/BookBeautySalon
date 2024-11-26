import 'package:book_beauty/models/product.dart';
import 'package:book_beauty/providers/base_provider.dart';
import 'package:book_beauty/models/order_item.dart';

class OrderItemProvider extends BaseProvider<OrderItem> {
  OrderItemProvider() : super("OrderItem");

  @override
  OrderItem fromJson(data) {
    return OrderItem.fromJson(data);
  }

  static List<OrderItem> orderItems = [];

  static void addOrderItem(OrderItem product) {
    if (orderItems.any((e) => e.productId == product.productId)) {
      var index =
          orderItems.indexWhere((e) => e.productId == product.productId);
      var quantity = orderItems[index].quantity!;
      orderItems[index].quantity = quantity + 1;
      print('OrderItem added successfully: ${product.productId}');
    } else {
      product.quantity = 1;
      orderItems.add(product);
      print('OrderItem added successfully: ${product.productId}');
    }
  }

  static void deleteAllItems() {
    orderItems.removeRange(0, orderItems.length);
  }
}
