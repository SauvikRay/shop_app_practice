import 'dart:convert';

import 'package:flutter/widgets.dart';
import 'package:http/http.dart' as http;

class Product with ChangeNotifier {
  final String id;
  final String title;
  final String description;
  final double price;
  final String imageUrl;
  bool isFavorite;

  Product({
    required this.id,
    required this.title,
    required this.description,
    required this.price,
    required this.imageUrl,
    this.isFavorite = false,
  });

  void _setFavValue(bool newValue) {
    isFavorite = newValue;
  }

  Future<void> toogleFavouriteStatus(String token,String userId,) async {
    final oldStatus = isFavorite;
    isFavorite = !isFavorite;
    notifyListeners();
    try {
      final response = await http.put(
        Uri.parse(
            'https://shopapp-e73fe-default-rtdb.asia-southeast1.firebasedatabase.app/userFevourites/$userId/$id.json?auth=$token'),
        body: jsonEncode({
          'isFavorite': isFavorite,
        }),
      );
      if (response.statusCode >= 400) {
        _setFavValue(oldStatus);
      }
      // notifyListeners();
    } catch (e) {
      _setFavValue(oldStatus);
    }
  }

 

}
