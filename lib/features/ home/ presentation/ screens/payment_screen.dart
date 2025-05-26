import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../data/models/order.dart';
import '../application/order_provider.dart';

class PaymentScreen extends StatefulWidget {
  final ShopOrder order;

  const PaymentScreen({
    Key? key,
    required this.order,
  }) : super(key: key);

  @override
  State<PaymentScreen> createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<PaymentScreen> {
  final _cardNumberController = TextEditingController();
  final _expiryController = TextEditingController();
  final _cvvController = TextEditingController();
  bool _isProcessing = false;

  @override
  void dispose() {
    _cardNumberController.dispose();
    _expiryController.dispose();
    _cvvController.dispose();
    super.dispose();
  }

  Future<void> _processPayment() async {
    if (!_validateForm()) return;

    setState(() => _isProcessing = true);

    try {
      // В реальном приложении здесь была бы интеграция с платежным шлюзом
      await Future.delayed(const Duration(seconds: 2)); // Имитация обработки

      // Генерируем фейковый ID платежа
      final paymentId = 'PAY-${DateTime.now().millisecondsSinceEpoch}';
      
      // Обновляем статус заказа
      await context.read<OrderProvider>().updateOrderStatus(
            widget.order.id,
            OrderStatus.processing,
          );
      
      // Сохраняем информацию об оплате
      await context.read<OrderProvider>().updatePaymentInfo(
            widget.order.id,
            paymentId,
          );

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Оплата прошла успешно!')),
        );
        Navigator.of(context).popUntil((route) => route.isFirst);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Ошибка при обработке оплаты')),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isProcessing = false);
      }
    }
  }

  bool _validateForm() {
    if (_cardNumberController.text.length != 16) {
      _showError('Введите корректный номер карты');
      return false;
    }

    if (_expiryController.text.length != 5) {
      _showError('Введите корректный срок действия карты (MM/YY)');
      return false;
    }

    if (_cvvController.text.length != 3) {
      _showError('Введите корректный CVV код');
      return false;
    }

    return true;
  }

  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Оплата заказа'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Сумма к оплате: ${widget.order.totalAmount.toStringAsFixed(2)} сом',
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text('Номер заказа: ${widget.order.id}'),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),
            const Text(
              'Данные карты',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _cardNumberController,
              decoration: const InputDecoration(
                labelText: 'Номер карты',
                hintText: '1234 5678 9012 3456',
              ),
              keyboardType: TextInputType.number,
              maxLength: 16,
            ),
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _expiryController,
                    decoration: const InputDecoration(
                      labelText: 'Срок действия',
                      hintText: 'MM/YY',
                    ),
                    keyboardType: TextInputType.datetime,
                    maxLength: 5,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: TextField(
                    controller: _cvvController,
                    decoration: const InputDecoration(
                      labelText: 'CVV',
                      hintText: '123',
                    ),
                    keyboardType: TextInputType.number,
                    maxLength: 3,
                    obscureText: true,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _isProcessing ? null : _processPayment,
                child: _isProcessing
                    ? const SizedBox(
                        height: 20,
                        width: 20,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                        ),
                      )
                    : const Text('Оплатить'),
              ),
            ),
          ],
        ),
      ),
    );
  }
} 