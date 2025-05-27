import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../application/cart_provider.dart';
import '../application/order_provider.dart';
import '../../../../data/models/cart_item.dart';

class CartScreen extends StatefulWidget {
  const CartScreen({Key? key}) : super(key: key);

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  final _addressController = TextEditingController();
  bool _isProcessing = false;

  @override
  void initState() {
    super.initState();
    // Загружаем корзину при открытии экрана
    Future.microtask(() {
      context.read<CartProvider>().loadCart();
    });
  }

  @override
  void dispose() {
    _addressController.dispose();
    super.dispose();
  }

  Future<void> _processOrder() async {
    if (_addressController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Пожалуйста, введите адрес доставки')),
      );
      return;
    }

    setState(() => _isProcessing = true);

    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user == null) {
        throw Exception('Необходимо войти в аккаунт');
      }

      final cartProvider = context.read<CartProvider>();
      final orderProvider = context.read<OrderProvider>();

      final order = await orderProvider.createOrder(
        items: cartProvider.items,
        totalAmount: cartProvider.totalAmount,
        deliveryAddress: _addressController.text.trim(),
        userId: user.uid,
      );

      if (order != null) {
        await cartProvider.clearCart();
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Заказ успешно создан!')),
          );
          Navigator.pushNamed(context, '/payment', arguments: order);
        }
      } else {
        throw Exception('Не удалось создать заказ');
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Ошибка: ${e.toString()}')),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isProcessing = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Корзина'),
        actions: [
          IconButton(
            icon: const Icon(Icons.delete_outline),
            onPressed: () {
              context.read<CartProvider>().clearCart();
            },
          ),
        ],
      ),
      body: Consumer<CartProvider>(
        builder: (context, cart, child) {
          if (cart.items.isEmpty) {
            return const Center(
              child: Text('Корзина пуста'),
            );
          }

          return Column(
            children: [
              Expanded(
                child: ListView.builder(
                  itemCount: cart.items.length,
                  itemBuilder: (context, index) {
                    final item = cart.items[index];
                    return CartItemWidget(item: item);
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    TextField(
                      controller: _addressController,
                      decoration: const InputDecoration(
                        labelText: 'Адрес доставки',
                        border: OutlineInputBorder(),
                      ),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'Итого: ${cart.totalAmount.toStringAsFixed(2)} сом',
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 16),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: _isProcessing ? null : _processOrder,
                        child: _isProcessing
                            ? const SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                          ),
                        )
                            : const Text('Оформить заказ'),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

class CartItemWidget extends StatelessWidget {
  final CartItem item;

  const CartItemWidget({
    Key? key,
    required this.item,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: ListTile(
        leading: item.imageUrl.isNotEmpty
            ? Image.network(
          item.imageUrl,
          width: 50,
          height: 50,
          fit: BoxFit.cover,
          errorBuilder: (context, error, stackTrace) {
            return const Icon(Icons.error);
          },
        )
            : const Icon(Icons.image),
        title: Text(item.productName),
        subtitle: Text('${item.price.toStringAsFixed(2)} сом'),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              icon: const Icon(Icons.remove),
              onPressed: () {
                context.read<CartProvider>().updateQuantity(
                  item.productId,
                  item.quantity - 1,
                );
              },
            ),
            Text('${item.quantity}'),
            IconButton(
              icon: const Icon(Icons.add),
              onPressed: () {
                context.read<CartProvider>().updateQuantity(
                  item.productId,
                  item.quantity + 1,
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
