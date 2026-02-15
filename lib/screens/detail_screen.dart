import 'package:flutter/material.dart';
import '../models/product.dart';

class DetailScreen extends StatelessWidget {
  final Product product;
  final VoidCallback onAddToCart;

  const DetailScreen({
    super.key,
    required this.product,
    required this.onAddToCart,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Ürün Detayı')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(18),
            child: AspectRatio(
              aspectRatio: 1,
              child: Image.network(
                product.imageUrl,
                fit: BoxFit.cover,
                loadingBuilder: (c, w, progress) {
                  if (progress == null) return w;
                  return const Center(child: CircularProgressIndicator());
                },
                errorBuilder: (_, __, ___) => const Center(
                  child: Icon(Icons.broken_image_outlined, size: 48),
                ),
              ),
            ),
          ),
          const SizedBox(height: 14),
          Text(
            product.title,
            style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w800),
          ),
          const SizedBox(height: 8),
          Text(
            '${product.price.toStringAsFixed(0)} ₺',
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
          ),
          const SizedBox(height: 12),
          Text(
            product.description,
            style: const TextStyle(fontSize: 15, height: 1.4),
          ),
          const SizedBox(height: 18),
          FilledButton.icon(
            onPressed: () {
              onAddToCart();
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('${product.title} sepete eklendi')),
              );
            },
            icon: const Icon(Icons.shopping_cart_outlined),
            label: const Text('Sepete Ekle'),
          ),
        ],
      ),
    );
  }
}
