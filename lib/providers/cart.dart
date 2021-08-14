import 'package:flutter/foundation.dart';

class CartItem {
  final String id;
  final String title;
  final int qty;
  final double price;
  final String imageUrl;

  CartItem({
    @required this.id,
    @required this.title,
    @required this.qty,
    @required this.price,
    @required this.imageUrl,
  });
}

class Cart with ChangeNotifier {
  Map<String, CartItem> _items = {};
  Map<String, CartItem> get items {
    return {..._items};
  }

  int get itemCount {
    return _items.length;
  }

  double get totalAmount {
    var total = 0.0;
    _items.forEach((key, value) {
      total += value.price * value.qty;
    });

    return total;
  }

  int FindProduct(String key) {
    return _items[key].qty;
  }

  void addItem(String productId, double price, String title, String imageUrl) {
    if (_items.containsKey(productId)) {
      _items.update(
          productId,
          (value) => CartItem(
              id: value.id,
              title: value.title,
              qty: value.qty + 1,
              price: value.price,
              imageUrl: value.imageUrl));
    } else {
      _items.putIfAbsent(
          productId,
          () => CartItem(
              id: productId,
              title: title,
              price: price,
              qty: 1,
              imageUrl: imageUrl));
    }
    notifyListeners();
  }

  void removeItem(String id) {
    _items.remove(id);
    notifyListeners();
  }

  void removeSingleItem(String productId) {
    if (!_items.containsKey(productId)) {
      return;
    }
    if (_items[productId].qty > 1) {
      _items.update(
        productId,
        (value) => CartItem(
          id: value.id,
          title: value.title,
          qty: value.qty - 1,
          price: value.price,
          imageUrl: value.imageUrl,
        ),
      );
    } else {
      _items.remove(productId);
    }
    notifyListeners();
  }

  void clear() {
    _items = {};
    notifyListeners();
  }
}
