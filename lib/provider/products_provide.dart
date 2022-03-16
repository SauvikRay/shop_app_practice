import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:shop_app_practice/provider/product.dart';
import 'package:http/http.dart' as http;

class ProductsProvider with ChangeNotifier {
  final List<Product> _items = [
    Product(
      id: 'p1',
      title: 'Red Shirt',
      description: 'A red shirt - it is pretty red!',
      price: 29.99,
      imageUrl:
          'https://cdn.pixabay.com/photo/2016/10/02/22/17/red-t-shirt-1710578_1280.jpg',
    ),
    Product(
      id: 'p2',
      title: 'Trousers',
      description: 'A nice pair of trousers.',
      price: 59.99,
      imageUrl:
          'https://upload.wikimedia.org/wikipedia/commons/thumb/e/e8/Trousers%2C_dress_%28AM_1960.022-8%29.jpg/512px-Trousers%2C_dress_%28AM_1960.022-8%29.jpg',
    ),
    Product(
      id: 'p3',
      title: 'Yellow Scarf',
      description: 'Warm and cozy - exactly what you need for the winter.',
      price: 19.99,
      imageUrl:
          'https://live.staticflickr.com/4043/4438260868_cc79b3369d_z.jpg',
    ),
    Product(
      id: 'p4',
      title: 'A Pan',
      description: 'Prepare any meal you want.',
      price: 49.99,
      imageUrl:
          'https://upload.wikimedia.org/wikipedia/commons/thumb/1/14/Cast-Iron-Pan.jpg/1024px-Cast-Iron-Pan.jpg',
    ),
  ];

  // var _showFavoritesOnly = false;

  List<Product> get items {
    // if(_showFavoritesOnly){
    //   return _items.where((element) => element.isFavorite).toList();
    // }
    return [..._items];
  }

//Filtering the Favorites Item
  List<Product> get favoritesProduct {
    return _items.where((element) => element.isFavorite).toList();
  }

//Filtering the Favorites Item
  // void showFavoritesOnly(){
  //   _showFavoritesOnly = true;
  //   notifyListeners();
  // }
  //Filtering the All item
  // void showAll(){
  //   _showFavoritesOnly = false;
  //   notifyListeners();
  // }

//Filtering data by ID
  Product findById(String id) {
    return _items.firstWhere((product) => product.id == id);
  }

  //Filtering data by title

  Product findByTitle(String title) {
    return _items.firstWhere((product) => product.title == title);
  }

  void addProduct(Product product) {
      // final url = Uri.https('https://shopapp-e73fe-default-rtdb.asia-southeast1.firebasedatabase.app/', '/products.json');
      // http.post(
      //             url, 
      //             body: jsonEncode({
      //               'titile' : product.title,
      //               'description': product.description,
      //               'price': product.price,
      //                'imageUrl': product.imageUrl,
      //                'isFavorite': product.isFavorite,
      //             }),
      //          );

      Future<http.Response>createProduct(String title,String description,double price,String imageUrl, bool isFavorite){
        return http.post(
          Uri.parse('https://shopapp-e73fe-default-rtdb.asia-southeast1.firebasedatabase.app/products.json'),
          body: jsonEncode({
                    'titile' : product.title,
                    'description': product.description,
                    'price': product.price,
                     'imageUrl': product.imageUrl,
                     'isFavorite': product.isFavorite,
          }),

        );
      }
  
    final newProduct = Product(
        id: DateTime.now().toString(),
        title: product.title,
        description: product.description,
        price: product.price,
        imageUrl: product.imageUrl);
    _items.add(newProduct);
    // _items.insert(0, newProduct); // add at the start ot the list

    notifyListeners();
  }
  
  //Update Product
  void updateProduct(String id, Product newProduct){
    final productIndex= _items.indexWhere((product) => product.id == id);

    if(productIndex >= 0){
              _items[productIndex]= newProduct;
              notifyListeners();
    } else {
      // print('.......');
    }
    
  }

  //Delete Product

  void deleteProduct(String id){
    _items.removeWhere((product) => product.id == id);

    notifyListeners();
  }


}
