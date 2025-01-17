import 'package:book_beauty/models/product.dart';
import 'package:book_beauty/providers/base_provider.dart';
import 'package:book_beauty/models/order_item.dart';
import 'package:flutter/material.dart';

class OrderItemProvider extends BaseProvider<OrderItem> {
  OrderItemProvider() : super("OrderItem");

  @override
  OrderItem fromJson(data) {
    return OrderItem.fromJson(data);
  }

  List<OrderItem> _orderItems = [];
  double _totalSum = 0.0;

  List<OrderItem> get orderItems => _orderItems;
  double get totalSum => _totalSum;

  void addProduct(Product item) {
    if (_orderItems.any((e) => e.productId == item.productId)) {
      var index = _orderItems.indexWhere((e) => e.productId == item.productId);
      var quantity = _orderItems[index].quantity!;
      _orderItems[index].quantity = quantity + 1;
      print('OrderItem added successfully: ${item.name}');
    } else {
      OrderItem newitem = OrderItem();
      newitem.product = item;
      newitem.productId = item.productId;
      newitem.quantity = 1;
      _orderItems.add(newitem);
      print('OrderItem added successfully: ${item.name}');
    }
    calculateTotal();
    notifyListeners();
  }

  void deleteAllItems() {
    _orderItems.clear();
    calculateTotal();
    notifyListeners();
  }

  void calculateTotal() {
    double total = 0;
    for (var element in _orderItems) {
      total += getPriceForProduct(element.productId!);
    }
    _totalSum = total;
  }

  double getPriceForProduct(int productId) {
    double total = 0;
    for (var element in _orderItems) {
      if (productId == element.productId) {
        total = (element.product!.price! * element.quantity!);
      }
    }
    return total;
  }

  void increaseQuantity(int productId) {
    int index = _orderItems.indexWhere((item) => item.productId == productId);
    if (index != -1) {
      int? quantity = (_orderItems[index].quantity ?? 0) + 1;
      _orderItems[index].quantity = quantity;
      calculateTotal();
      notifyListeners();
    }
  }

  void decreaseQuantity(int productId) {
    int index = _orderItems.indexWhere((item) => item.productId == productId);
    if (index != -1) {
      int quantity = (_orderItems[index].quantity ?? 0) - 1;
      if (quantity <= 0) {
        removeProduct(productId);
      } else {
        _orderItems[index].quantity = quantity;
        calculateTotal();
        notifyListeners();
      }
    }
  }

  void removeProduct(int productId) {
    _orderItems.removeWhere((item) => item.productId == productId);
    calculateTotal();
    notifyListeners();
  }

  int getQuantity(int productId) {
    int index = _orderItems.indexWhere((item) => item.productId == productId);
    if (index != -1) {
      return _orderItems[index].quantity ?? 0;
    }
    return 0;
  }
}
