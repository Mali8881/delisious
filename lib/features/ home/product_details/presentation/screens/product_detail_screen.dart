import 'package:flutter/material.dart';

import '../../../../../data/models/product_model.dart';


class ProductDetailScreen extends StatefulWidget {
  final Product product;

  const ProductDetailScreen({Key? key, required this.product}) : super(key: key);

  @override
  State<ProductDetailScreen> createState() => _ProductDetailScreenState();
}

class _ProductDetailScreenState extends State<ProductDetailScreen> {
  final TextEditingController _addressController = TextEditingController();

  void _showOrderConfirmationDialog() {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        backgroundColor: Colors.purple.shade50,
        title: const Text("Заказ оформлен!"),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Вы заказали: ${widget.product.name}"),
            Text("Цена: ${widget.product.price.toStringAsFixed(1)} сом"),
            Text("Адрес: ${_addressController.text.trim()}"),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text("ОК"),
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final product = widget.product;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue.shade100,
        title: const Text("Позиция в меню"),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // Фото
            ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: Image.network(
                product.imageUrl,
                height: 180,
                width: double.infinity,
                fit: BoxFit.cover,
              ),
            ),
            const SizedBox(height: 20),

            // Название и цена
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  product.name,
                  style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                Row(
                  children: [
                    const Icon(Icons.monetization_on_outlined),
                    Text('${product.price.toStringAsFixed(1)} сом',
                        style: const TextStyle(fontWeight: FontWeight.bold)),
                  ],
                ),
              ],
            ),

            const SizedBox(height: 10),
            Text(product.description),

            const SizedBox(height: 20),
            const Align(
              alignment: Alignment.centerLeft,
              child: Text("Адрес доставки:", style: TextStyle(fontWeight: FontWeight.bold)),
            ),
            const SizedBox(height: 6),
            TextField(
              controller: _addressController,
              decoration: InputDecoration(
                hintText: "Введите адрес",
                prefixIcon: const Icon(Icons.home),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
              ),
            ),
            const SizedBox(height: 20),

            // Кнопка заказа
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                onPressed: () {
                  if (_addressController.text.trim().isNotEmpty) {
                    _showOrderConfirmationDialog();
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text("Пожалуйста, введите адрес")),
                    );
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.amber,
                  foregroundColor: Colors.black,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
                child: const Text("Сделать заказ"),
              ),
            )
          ],
        ),
      ),
    );
  }
}
