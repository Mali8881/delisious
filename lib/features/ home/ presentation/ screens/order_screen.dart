import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../data/models/cart_item.dart';
import '../application/order_provider.dart';
import '../../../../data/models/order.dart';

class OrderScreen extends StatefulWidget {
  const OrderScreen({Key? key}) : super(key: key);

  @override
  State<OrderScreen> createState() => _OrderScreenState();
}

class _OrderScreenState extends State<OrderScreen> {
  get orders => null;

  @override
  void initState() {
    super.initState();
    // Загружаем заказы при открытии экрана
    Future.microtask(() {
      context.read<OrderProvider>().loadOrders();
    });
  }

  String _getStatusText(OrderStatus status) {
    switch (status) {
      case OrderStatus.pending:
        return 'Ожидает оплаты';
      case OrderStatus.processing:
        return 'В обработке';
      case OrderStatus.completed:
        return 'Выполнен';
      case OrderStatus.cancelled:
        return 'Отменён';
      default:
        return 'Неизвестно';
    }
  }

  Color _getStatusColor(OrderStatus status) {
    switch (status) {
      case OrderStatus.pending:
        return Colors.orange;
      case OrderStatus.processing:
        return Colors.blue;
      case OrderStatus.completed:
        return Colors.green;
      case OrderStatus.cancelled:
        return Colors.red;
      default:
        return Colors.grey;
    }
  }
  Future<ShopOrder> createOrder({
    required List<CartItem> items,
    required double totalAmount,
    required String deliveryAddress,
    required String userId,
  }) async {
    final orderId = DateTime.now().millisecondsSinceEpoch.toString();

    // Предположим, что у CartItem есть productName
    final newOrder = ShopOrder(
      id: orderId,
      userId: userId,
      items: items,
      totalAmount: totalAmount,
      createdAt: DateTime.now(),
      deliveryAddress: deliveryAddress,
    );

    orders.insert(0, newOrder);
    notifyListeners();

    return newOrder;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Мои заказы'),
      ),
      body: Consumer<OrderProvider>(
        builder: (context, orderProvider, child) {
          final orders = orderProvider.orders;

          if (orders.isEmpty) {
            return const Center(
              child: Text('У вас пока нет заказов'),
            );
          }

          return ListView.builder(
            itemCount: orders.length,
            itemBuilder: (context, index) {
              final order = orders[index];
              return Card(
                margin: const EdgeInsets.all(8),
                child: ExpansionTile(
                  title: Text('Заказ от ${order.createdAt.toString().substring(0, 16)}'),
                  subtitle: Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: _getStatusColor(order.status).withOpacity(0.1),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: _getStatusColor(order.status),
                          ),
                        ),
                        child: Text(
                          _getStatusText(order.status),
                          style: TextStyle(
                            color: _getStatusColor(order.status),
                            fontSize: 12,
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Text('${order.totalAmount.toStringAsFixed(2)} сом'),
                    ],
                  ),
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Состав заказа:',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(height: 8),
                          ...order.items.map((item) => Padding(
                                padding: const EdgeInsets.only(bottom: 4),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(item.productName),
                                    Text(
                                        '${item.quantity} x ${item.price.toStringAsFixed(2)} сом'),
                                  ],
                                ),
                              )),
                          const Divider(),
                          Text(
                            'Адрес доставки: ${order.deliveryAddress}',
                            style: const TextStyle(fontSize: 14),
                          ),
                          if (order.paymentId != null) ...[
                            const SizedBox(height: 8),
                            Text(
                              'Номер оплаты: ${order.paymentId}',
                              style: const TextStyle(fontSize: 14),
                            ),
                          ],
                        ],
                      ),
                    ),
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }

  void notifyListeners() {}
}
