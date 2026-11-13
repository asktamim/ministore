import 'package:flutter/foundation.dart';
import 'product.dart';

// Cart er ekta item = product + quantity
class CartItem {
  final Product product;
  int quantity;

  CartItem({required this.product, this.quantity = 1});

  double get total => product.price * quantity;
}

// Cart app er bhitore (memory te) thake. Kono database lagbe na.
// ChangeNotifier: data change hole UI ke janiye dey (notifyListeners).
class CartModel extends ChangeNotifier {
  final Map<int, CartItem> _items = {};

  List<CartItem> get items => _items.values.toList();

  int get totalQuantity =>
      _items.values.fold(0, (sum, item) => sum + item.quantity);

  double get totalPrice =>
      _items.values.fold(0.0, (sum, item) => sum + item.total);

  bool get isEmpty => _items.isEmpty;

  // ADD: product add korbe, age thakle quantity barbe
  void add(Product product, {int quantity = 1}) {
    if (_items.containsKey(product.id)) {
      _items[product.id]!.quantity += quantity;
    } else {
      _items[product.id] = CartItem(product: product, quantity: quantity);
    }
    notifyListeners();
  }

  // UPDATE: quantity barano/komano (0 hole delete)
  void updateQuantity(int productId, int quantity) {
    if (quantity <= 0) {
      remove(productId);
      return;
    }
    _items[productId]?.quantity = quantity;
    notifyListeners();
  }

  // DELETE: ekta item muche fela
  void remove(int productId) {
    _items.remove(productId);
    notifyListeners();
  }

  // Cart khali kora
  void clear() {
    _items.clear();
    notifyListeners();
  }
}

// Puro app e ekta-i cart, tai global instance
final CartModel cart = CartModel();
