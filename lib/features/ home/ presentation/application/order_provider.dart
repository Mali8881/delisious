import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../../../data/models/order.dart';
import '../../../../data/models/cart_item.dart';

class OrderProvider extends ChangeNotifier {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  List<ShopOrder> _orders = [];

  List<ShopOrder> get orders => [..._orders];

  Future<void> loadOrders() async {
    final user = _auth.currentUser;
    if (user != null) {
      try {
        final querySnapshot = await _firestore
            .collection('orders')
            .where('userId', isEqualTo: user.uid)
            .orderBy('createdAt', descending: true)
            .get();

        _orders = querySnapshot.docs
            .map((doc) => ShopOrder.fromMap(doc.data()))
            .toList();

        notifyListeners();
      } catch (e) {
        debugPrint('Ошибка загрузки заказов: $e');
      }
    }
  }

  Future<ShopOrder?> createOrder({
    required List<CartItem> items,
    required double totalAmount,
    required String deliveryAddress,
    required String userId,
  }) async {
    try {
      final user = _auth.currentUser;
      if (user == null) return null;

      final orderId = DateTime.now().millisecondsSinceEpoch.toString();
      final newOrder = ShopOrder(
        id: orderId,
        userId: user.uid,
        items: items,
        totalAmount: totalAmount,
        createdAt: DateTime.now(),
        deliveryAddress: deliveryAddress,
      );

      // Сохраняем заказ в Firebase
      await _firestore.collection('orders').doc(orderId).set(newOrder.toMap());

      // Добавляем заказ в локальный список
      _orders.insert(0, newOrder);
      notifyListeners();

      return newOrder;
    } catch (e) {
      debugPrint('Ошибка создания заказа: $e');
      return null;
    }
  }

  Future<void> updatePaymentInfo(String orderId, String paymentId) async {
    try {
      await _firestore.collection('orders').doc(orderId).update({
        'paymentId': paymentId,
      });

      final orderIndex = _orders.indexWhere((order) => order.id == orderId);
      if (orderIndex != -1) {
        _orders[orderIndex].paymentId = paymentId;
        notifyListeners();
      }
    } catch (e) {
      debugPrint('Ошибка обновления информации об оплате: $e');
    }
  }

  Future<void> updateOrderStatus(String orderId, OrderStatus status) async {
    try {
      await _firestore.collection('orders').doc(orderId).update({
        'status': status.toString(),
      });

      final orderIndex = _orders.indexWhere((order) => order.id == orderId);
      if (orderIndex != -1) {
        _orders[orderIndex].status = status;
        notifyListeners();
      }
    } catch (e) {
      debugPrint('Ошибка обновления статуса заказа: $e');
    }
  }
}
