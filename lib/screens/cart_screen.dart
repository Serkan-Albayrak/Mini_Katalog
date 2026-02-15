import 'package:flutter/material.dart';
import '../models/product.dart';

class CartScreen extends StatefulWidget {
  final List<Product> items;

  const CartScreen({super.key, required this.items});

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  late final Map<int, _CartLine> _lines;

  @override
  void initState() {
    super.initState();
    _lines = {};
    for (final p in widget.items) {
      _lines.update(
        p.id,
        (line) => line.copyWith(qty: line.qty + 1),
        ifAbsent: () => _CartLine(product: p, qty: 1),
      );
    }
  }

  double get total =>
      _lines.values.fold(0, (sum, line) => sum + line.product.price * line.qty);

  void _inc(int id) {
    setState(() {
      _lines[id] = _lines[id]!.copyWith(qty: _lines[id]!.qty + 1);
      _syncBackToSourceList();
    });
  }

  void _dec(int id) {
    setState(() {
      final line = _lines[id]!;
      if (line.qty <= 1) {
        _lines.remove(id);
      } else {
        _lines[id] = line.copyWith(qty: line.qty - 1);
      }
      _syncBackToSourceList();
    });
  }

  void _remove(int id) {
    setState(() {
      _lines.remove(id);
      _syncBackToSourceList();
    });
  }

  void _syncBackToSourceList() {
    widget.items
      ..clear()
      ..addAll(
        _lines.values.expand((line) => List.filled(line.qty, line.product)),
      );
  }

  @override
  Widget build(BuildContext context) {
    final linesList = _lines.values.toList();

    return Scaffold(
      appBar: AppBar(title: const Text('Sepet')),
      body: linesList.isEmpty
          ? const Center(child: Text('Sepet boş'))
          : ListView.separated(
              padding: const EdgeInsets.all(12),
              itemCount: linesList.length,
              separatorBuilder: (_, __) => const SizedBox(height: 10),
              itemBuilder: (context, i) {
                final line = linesList[i];
                final p = line.product;

                return Card(
                  child: ListTile(
                    leading: ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: Image.network(
                        p.imageUrl,
                        width: 56,
                        height: 56,
                        fit: BoxFit.cover,
                        errorBuilder: (_, __, ___) => const SizedBox(
                          width: 56,
                          height: 56,
                          child: Icon(Icons.broken_image_outlined),
                        ),
                      ),
                    ),
                    title: Text(p.title),
                    subtitle: Text(
                      '${p.price.toStringAsFixed(0)} ₺  •  Adet: ${line.qty}',
                    ),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          tooltip: 'Azalt',
                          onPressed: () => _dec(p.id),
                          icon: const Icon(Icons.remove_circle_outline),
                        ),
                        IconButton(
                          tooltip: 'Artır',
                          onPressed: () => _inc(p.id),
                          icon: const Icon(Icons.add_circle_outline),
                        ),
                        IconButton(
                          tooltip: 'Çıkar',
                          onPressed: () => _remove(p.id),
                          icon: const Icon(Icons.delete_outline),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(12),
        child: FilledButton(
          onPressed: linesList.isEmpty ? null : () {},
          child: Text('Toplam: ${total.toStringAsFixed(0)} ₺'),
        ),
      ),
    );
  }
}

class _CartLine {
  final Product product;
  final int qty;

  const _CartLine({required this.product, required this.qty});

  _CartLine copyWith({Product? product, int? qty}) =>
      _CartLine(product: product ?? this.product, qty: qty ?? this.qty);
}
