import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import '../provider/cart.dart' show CartItem;
import 'package:http/http.dart' as http;

class OrderItem {
  final String id;
  final double amount;
  final List<CartItem> products;
  final DateTime dateTime;

  OrderItem(
      {Key? key,
      required this.id,
      required this.amount,
      required this.products,
      required this.dateTime});
}

class Orders with ChangeNotifier {
  List<OrderItem> _orders = [];

  List<OrderItem> get orders {
    return [..._orders];
  }

  Future<void> addOrder(List<CartItem> cartProducts, double total) async {
    final timeStamp = DateTime.now();
    final response = await http.post(
      //Working Code
      Uri.parse(
          'https://shopapp-e73fe-default-rtdb.asia-southeast1.firebasedatabase.app/orders.json'),
      body: jsonEncode({
        'amount': total,
        'dateTime': timeStamp.toIso8601String(),
        'products': cartProducts
            .map((cartProduct) => {
                  'id': cartProduct.id,
                  'title': cartProduct.title,
                  'quantity': cartProduct.quantity,
                  'price': cartProduct.price
                })
            .toList(),
      }),
    );
    _orders.insert(
      0,
      OrderItem(
        id: jsonDecode(response.body)['name'], //DateTime.now().toString(),
        amount: total,
        products: cartProducts,
        dateTime: timeStamp,
      ),
    );

    notifyListeners();
  }

  Future<void> fetchAndSetOrders() async {
    final response = await http.get(
      Uri.parse(
          'https://shopapp-e73fe-default-rtdb.asia-southeast1.firebasedatabase.app/orders.json'),
    );
    final List<OrderItem> loadedOrders = [];
    final extractedOrder = jsonDecode(response.body) as Map<String, dynamic>?;
    if (extractedOrder == null) {
      return;
    }
    extractedOrder.forEach((orderId, orderData) {
      loadedOrders.add(
        OrderItem(
          id: orderId,
          amount: orderData['amount'],
          dateTime: DateTime.parse(orderData['dateTime']),
          products: (orderData['products'] as List<dynamic>)
              .map(
                (item) => CartItem(
                    id: item['id'],
                    title: item['title'],
                    quantity: item['quantity'],
                    price: item['price']),
              )
              .toList(),
        ),
      );
    });
    _orders = loadedOrders.reversed.toList();
    notifyListeners();
    // print(jsonDecode(response.body));
  }
}
