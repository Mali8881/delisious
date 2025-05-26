import 'package:flutter/material.dart';
import '../../../../data/models/order.dart';
import '../../../../data/models/cart_item.dart';

class OrderProvider extends ChangeNotifier {
  List<ShopOrder> _orders = [];

  List<ShopOrder> get orders => [..._orders];

  Future<void> loadOrders() async {
    if (_orders.isEmpty) {
      _orders = [
        ShopOrder(
          id: 'test1',
          userId: 'local_user',
          items: [
            CartItem(productId: 'p1', quantity: 2, price: 100.0, id: '', productName: '', imageUrl: ''),
            CartItem(productId: 'p2', quantity: 1, price: 250.0, productName: '', id: '', imageUrl: ''),
          ],
          totalAmount: 450.0,
          createdAt: DateTime.now().subtract(const Duration(days: 1)),
          deliveryAddress: 'г. Бишкек, ул. Ленина, 123',
        ),
      ];
      notifyListeners();
    }
  }

  Future<ShopOrder> createOrder({
    required List<CartItem> items,
    required double totalAmount,
    required String deliveryAddress,
    required String userId,
  }) async {
    final orderId = DateTime.now().millisecondsSinceEpoch.toString();
    final newOrder = ShopOrder(
      id: orderId,
      userId: userId,
      items: items,
      totalAmount: totalAmount,
      createdAt: DateTime.now(),
      deliveryAddress: deliveryAddress,
    );

    _orders.insert(0, newOrder);
    notifyListeners();

    return newOrder;
  }

  updatePaymentInfo(String id, String paymentId) {}

  updateOrderStatus(String id, OrderStatus processing) {}
}
