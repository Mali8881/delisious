import 'package:cloud_firestore/cloud_firestore.dart';
import 'cart_item.dart';

enum OrderStatus {
  pending,
  processing,
  completed,
  cancelled
}

class ShopOrder {
  final String id;
  final String userId;
  final List<CartItem> items;
  final double totalAmount;
  final DateTime createdAt;
  final String deliveryAddress;
  OrderStatus status;
  String? paymentId;

  ShopOrder({
    required this.id,
    required this.userId,
    required this.items,
    required this.totalAmount,
    required this.createdAt,
    required this.deliveryAddress,
    this.status = OrderStatus.pending,
    this.paymentId,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'userId': userId,
      'items': items.map((item) => item.toMap()).toList(),
      'totalAmount': totalAmount,
      'createdAt': Timestamp.fromDate(createdAt),
      'deliveryAddress': deliveryAddress,
      'status': status.toString(),
      'paymentId': paymentId,
    };
  }

  factory ShopOrder.fromMap(Map<String, dynamic> map) {
    return ShopOrder(
      id: map['id'],
      userId: map['userId'],
      items: (map['items'] as List)
          .map((item) => CartItem.fromMap(item))
          .toList(),
      totalAmount: map['totalAmount'].toDouble(),
      createdAt: (map['createdAt'] as Timestamp).toDate(),
      deliveryAddress: map['deliveryAddress'],
      status: OrderStatus.values.firstWhere(
        (e) => e.toString() == map['status'],
        orElse: () => OrderStatus.pending,
      ),
      paymentId: map['paymentId'],
    );
  }
} 