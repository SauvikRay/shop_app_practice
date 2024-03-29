import 'package:flutter/widgets.dart';

class CartItem {
  final String id;
  final String title;
  final int quantity;
  final double price;

  CartItem(
      {required this.id,
      required this.title,
      required this.quantity,
      required this.price});
}

class Cart with ChangeNotifier {
  Map<String, CartItem> _items = {};
  //Get item from the MAP _item
  Map<String, CartItem> get items {
    return {..._items};
  }

//Calculate the Total Item
  int get itemCount {
    return _items.length;
  }

  //Calculate the total amount
  double get totalAmount {
    double total = 0.0;
    _items.forEach((key, cartItem) {
      total += cartItem.price * cartItem.quantity;
    });
    return total;
  }

  void addItem(String productId, double price, String title) {
    if (_items.containsKey(productId)) {
      _items.update(
        productId,
        (value) => CartItem(
            id: value.id,
            title: value.title,
            quantity: value.quantity + 1,
            price: value.price),
      );
    } else {
      _items.putIfAbsent(
        productId,
        () => CartItem(
            id: DateTime.now().toString(),
            title: title,
            price: price,
            quantity: 1),
      );
    }
    notifyListeners();
  }

  void removeItem(String productId) {
    _items.remove(productId);
    notifyListeners();
  }

  void crearCard() {
    _items = {};
    notifyListeners();
  }

//remove Single order Item
  void removeSingleItem(String productId) {
    if (!_items.containsKey(productId)) {
      return;
    }
    if (_items[productId]!.quantity > 1) {
      _items.update(
        productId,
        (exsistingCartItem) => CartItem(
            id: exsistingCartItem.id,
            title: exsistingCartItem.title,
            quantity: exsistingCartItem.quantity - 1,
            price: exsistingCartItem.price),
      );
    } else {
      _items.remove(productId);
    }
    notifyListeners();
  }
}
