import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:shopm/data/models/product_model.dart';
 import '../../../../data/models/cart_item.dart';

class CartProvider extends ChangeNotifier {
  final List<CartItem> _items = [];
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  List<CartItem> get items => [..._items];
  
  double get totalAmount {
    return _items.fold(0, (sum, item) => sum + item.totalPrice);
  }

  int get itemCount => _items.length;

  Future<void> loadCart() async {
    final user = _auth.currentUser;
    if (user != null) {
      try {
        final cartDoc = await _firestore
            .collection('carts')
            .doc(user.uid)
            .get();

        if (cartDoc.exists) {
          final cartData = cartDoc.data() as Map<String, dynamic>;
          final items = (cartData['items'] as List)
              .map((item) => CartItem.fromMap(item))
              .toList();
          _items.clear();
          _items.addAll(items);
          notifyListeners();
        }
      } catch (e) {
        debugPrint('Ошибка загрузки корзины: $e');
      }
    }
  }

  Future<void> addItem(CartItem item) async {
    final existingItemIndex = _items.indexWhere((i) => i.productId == item.productId);
    
    if (existingItemIndex >= 0) {
      _items[existingItemIndex].quantity += 1;
    } else {
      _items.add(item);
    }
    
    await _saveCart();
    notifyListeners();
  }

  Future<void> removeItem(String productId) async {
    _items.removeWhere((item) => item.productId == productId);
    await _saveCart();
    notifyListeners();
  }

  Future<void> updateQuantity(String productId, int quantity) async {
    final index = _items.indexWhere((item) => item.productId == productId);
    if (index >= 0) {
      if (quantity > 0) {
        _items[index].quantity = quantity;
      } else {
        _items.removeAt(index);
      }
      await _saveCart();
      notifyListeners();
    }
  }

  Future<void> clearCart() async {
    _items.clear();
    await _saveCart();
    notifyListeners();
  }

  Future<void> _saveCart() async {
    final user = _auth.currentUser;
    if (user != null) {
      try {
        await _firestore.collection('carts').doc(user.uid).set({
          'userId': user.uid,
          'items': _items.map((item) => item.toMap()).toList(),
          'updatedAt': FieldValue.serverTimestamp(),
        });
      } catch (e) {
        debugPrint('Ошибка сохранения корзины: $e');
      }
    }
  }

  void addToCart(Product product) {}
}
