import 'package:flutter/material.dart';
import '../models/cart_model.dart';

class CartScreen extends StatelessWidget {
  const CartScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // ListenableBuilder: cart change hole ei screen auto update hoy
    return ListenableBuilder(
      listenable: cart,
      builder: (context, _) {
        return Scaffold(
          appBar: AppBar(
            title: Text('My Cart (${cart.totalQuantity})'),
            actions: [
              if (!cart.isEmpty)
                IconButton(
                  tooltip: 'Clear cart',
                  icon: const Icon(Icons.delete_sweep),
                  onPressed: () => _confirmClear(context),
                ),
            ],
          ),
          body: cart.isEmpty
              ? const Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.shopping_cart_outlined, size: 72),
                      SizedBox(height: 8),
                      Text('Your cart is empty'),
                    ],
                  ),
                )
              : Column(
                  children: [
                    Expanded(
                      child: ListView.separated(
                        padding: const EdgeInsets.all(12),
                        itemCount: cart.items.length,
                        separatorBuilder: (_, __) => const SizedBox(height: 8),
                        itemBuilder: (context, index) {
                          final item = cart.items[index];
                          return _CartTile(item: item);
                        },
                      ),
                    ),
                    _TotalBar(total: cart.totalPrice),
                  ],
                ),
        );
      },
    );
  }

  void _confirmClear(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Clear cart?'),
        content: const Text('All items will be removed.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () {
              cart.clear();
              Navigator.pop(ctx);
            },
            child: const Text('Clear'),
          ),
        ],
      ),
    );
  }
}

class _CartTile extends StatelessWidget {
  final CartItem item;
  const _CartTile({required this.item});

  @override
  Widget build(BuildContext context) {
    final p = item.product;
    // Dismissible: swipe kore delete kora jay
    return Dismissible(
      key: ValueKey(p.id),
      direction: DismissDirection.endToStart,
      background: Container(
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 20),
        color: Colors.red,
        child: const Icon(Icons.delete, color: Colors.white),
      ),
      onDismissed: (_) => cart.remove(p.id), // DELETE
      child: Card(
        margin: EdgeInsets.zero,
        child: Padding(
          padding: const EdgeInsets.all(8),
          child: Row(
            children: [
              SizedBox(
                width: 64,
                height: 64,
                child: Image.network(
                  p.image,
                  fit: BoxFit.contain,
                  errorBuilder: (_, __, ___) => const Icon(Icons.broken_image),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      p.title,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(fontWeight: FontWeight.w600),
                    ),
                    const SizedBox(height: 4),
                    Text('\$${p.price.toStringAsFixed(2)} each'),
                    Text(
                      'Subtotal: \$${item.total.toStringAsFixed(2)}',
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ),
              Column(
                children: [
                  Row(
                    children: [
                      // UPDATE quantity
                      IconButton(
                        visualDensity: VisualDensity.compact,
                        icon: const Icon(Icons.remove_circle_outline),
                        onPressed: () =>
                            cart.updateQuantity(p.id, item.quantity - 1),
                      ),
                      Text('${item.quantity}'),
                      IconButton(
                        visualDensity: VisualDensity.compact,
                        icon: const Icon(Icons.add_circle_outline),
                        onPressed: () =>
                            cart.updateQuantity(p.id, item.quantity + 1),
                      ),
                    ],
                  ),
                  // DELETE button
                  IconButton(
                    visualDensity: VisualDensity.compact,
                    icon: const Icon(Icons.delete_outline, color: Colors.red),
                    onPressed: () => cart.remove(p.id),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _TotalBar extends StatelessWidget {
  final double total;
  const _TotalBar({required this.total});

  @override
  Widget build(BuildContext context) {
    return Material(
      elevation: 8,
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Text(
                'Total: \$${total.toStringAsFixed(2)}',
                style: Theme.of(context).textTheme.titleLarge,
              ),
              const Spacer(),
              FilledButton(
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (ctx) => AlertDialog(
                      title: const Text('Order placed!'),
                      content: Text(
                        'Thank you. Total: \$${total.toStringAsFixed(2)}',
                      ),
                      actions: [
                        TextButton(
                          onPressed: () {
                            cart.clear();
                            Navigator.pop(ctx);
                            Navigator.pop(context);
                          },
                          child: const Text('OK'),
                        ),
                      ],
                    ),
                  );
                },
                child: const Text('Checkout'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
