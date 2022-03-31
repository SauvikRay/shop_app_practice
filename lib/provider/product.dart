import 'dart:convert';

import 'package:flutter/widgets.dart';
import 'package:http/http.dart' as http;

class Product with ChangeNotifier {
  final String id;
  final String title;
  final String description;
  final double price;
  final String imageUrl;
  bool isFavourite;

  Product({
    required this.id,
    required this.title,
    required this.description,
    required this.price,
    required this.imageUrl,
    this.isFavourite = false,
  });

  void _setFavValue(bool newValue) {
    isFavourite = newValue;
  }

  Future<void> toogleFavouriteStatus(String token,String userId,) async {
    final oldStatus = isFavourite;
    isFavourite = !isFavourite;
    notifyListeners();
    try {
      final response = await http.put(
        Uri.parse('https://shopapp-e73fe-default-rtdb.asia-southeast1.firebasedatabase.app/userFevourites/$userId/$id.json?auth=$token'),
        body: jsonEncode(
          isFavourite,
        ),
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
