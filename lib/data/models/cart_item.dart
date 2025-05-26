import 'package:cloud_firestore/cloud_firestore.dart';

class CartItem {
  final String id;
  final String productId;
  final String productName;
  final double price;
  int quantity;
  final String imageUrl;

  CartItem({
    required this.id,
    required this.productId,
    required this.productName,
    required this.price,
    this.quantity = 1,
    required this.imageUrl,
  });

  double get totalPrice => price * quantity;

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'productId': productId,
      'productName': productName,
      'price': price,
      'quantity': quantity,
      'imageUrl': imageUrl,
    };
  }

  factory CartItem.fromMap(Map<String, dynamic> map) {
    return CartItem(
      id: map['id'],
      productId: map['productId'],
      productName: map['productName'],
      price: map['price'].toDouble(),
      quantity: map['quantity'],
      imageUrl: map['imageUrl'],
    );
  }
} 