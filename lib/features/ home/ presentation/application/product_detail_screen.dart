import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../data/models/product_model.dart';
import '../application/cart_provider.dart';

class ProductDetailScreen extends StatelessWidget {
  final Product product;

  const ProductDetailScreen({Key? key, required this.product}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cart = Provider.of<CartProvider>(context, listen: false);

    return Scaffold(
      appBar: AppBar(
        title: Text(product.name),
        backgroundColor: Colors.blue.shade400,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Фото
            ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: Image.network(product.imageUrl, height: 250, width: double.infinity, fit: BoxFit.cover),
            ),
            const SizedBox(height: 20),

            // Название
            Text(product.name,
                style: theme.textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold)),
            const SizedBox(height: 10),

            // Описание
            Text(product.description,
                style: theme.textTheme.bodyLarge?.copyWith(color: Colors.grey[700])),
            const SizedBox(height: 20),

            // Цена
            Text('${product.price.toStringAsFixed(1)} ₽',
                style: theme.textTheme.headlineMedium?.copyWith(
                    color: Colors.blue, fontWeight: FontWeight.bold)),
            const SizedBox(height: 30),

            // Кнопка добавить в корзину
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
                onPressed: () {
                  cart.addToCart(product);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('${product.name} добавлен в корзину!')),
                  );
                },
                icon: const Icon(Icons.shopping_cart),
                label: const Text('Добавить в корзину'),
              ),
            )
          ],
        ),
      ),
    );
  }
}
