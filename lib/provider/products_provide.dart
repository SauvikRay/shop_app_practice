import 'dart:convert';
import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:shop_app_practice/provider/product.dart';
import 'package:http/http.dart' as http;

class ProductsProvider with ChangeNotifier {
  List<Product> _items = [
    // Product(
    //   id: 'p1',
    //   title: 'Red Shirt',
    //   description: 'A red shirt - it is pretty red!',
    //   price: 29.99,
    //   imageUrl:
    //       'https://cdn.pixabay.com/photo/2016/10/02/22/17/red-t-shirt-1710578_1280.jpg',
    // ),
    // Product(
    //   id: 'p2',
    //   title: 'Trousers',
    //   description: 'A nice pair of trousers.',
    //   price: 59.99,
    //   imageUrl:
    //       'https://upload.wikimedia.org/wikipedia/commons/thumb/e/e8/Trousers%2C_dress_%28AM_1960.022-8%29.jpg/512px-Trousers%2C_dress_%28AM_1960.022-8%29.jpg',
    // ),
    // Product(
    //   id: 'p3',
    //   title: 'Yellow Scarf',
    //   description: 'Warm and cozy - exactly what you need for the winter.',
    //   price: 19.99,
    //   imageUrl:
    //       'https://live.staticflickr.com/4043/4438260868_cc79b3369d_z.jpg',
    // ),
    // Product(
    //   id: 'p4',
    //   title: 'A Pan',
    //   description: 'Prepare any meal you want.',
    //   price: 49.99,
    //   imageUrl:
    //       'https://upload.wikimedia.org/wikipedia/commons/thumb/1/14/Cast-Iron-Pan.jpg/1024px-Cast-Iron-Pan.jpg',
    // ),
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

//sending data to the realtime Storage
  Future<void> addProduct(Product product) async {
    try {
      final response = await http.post(
        //Working Code
        Uri.parse(
            'https://shopapp-e73fe-default-rtdb.asia-southeast1.firebasedatabase.app/products.json'),
        body: jsonEncode(<String, dynamic>{
          'title': product.title,
          'description': product.description,
          'price': product.price,
          'imageUrl': product.imageUrl,
          'isFavorite': product.isFavorite,
        }),
      );
      final newProduct = Product(
          id: json.decode(response.body)['name'], //DateTime.now().toString(),
          title: product.title,
          description: product.description,
          price: product.price,
          imageUrl: product.imageUrl);
      _items.add(newProduct);
      // _items.insert(0, newProduct); // add at the start ot the list

      notifyListeners();
    } catch (error) {
      rethrow;
    }

    //After surver is correctly respond
    // print(json.decode(response.body));
  }

  //Fetching data from the server
  Future<void> dataFromTheServer() async {
    try {
      final response = await http.get(
        Uri.parse(
            'https://shopapp-e73fe-default-rtdb.asia-southeast1.firebasedatabase.app/products.json'),
      );
      final extractData = jsonDecode(response.body) as Map<String, dynamic>;
      final List<Product> loadedProducts = [];

      extractData.forEach((productId, productData) {
        loadedProducts.add(
          Product(
            id: productId,
            title: productData!['title'],
            description: productData['description'],
            price: productData['price'],
            isFavorite: productData['isFavorite'],
            imageUrl: productData['imageUrl'],
          ),
        );
      });
      //After extracted Data/loading the product
      _items = loadedProducts;
      notifyListeners();
      // print(extractData);
    } catch (e) {
      print(e);
      throw e;
    }
  }

  //Update Product
  Future<void> updateProduct(String id, Product newProduct) async {
    final productIndex = _items.indexWhere((product) => product.id == id);

    if (productIndex >= 0) {
      await http.patch(
        Uri.parse(
            'https://shopapp-e73fe-default-rtdb.asia-southeast1.firebasedatabase.app/products.json'),
        body: jsonEncode(
          <String, dynamic>{
            'title': newProduct.title,
            'description': newProduct.description,
            'price': newProduct.price,
            'imageUrl': newProduct.imageUrl,
          },
        ),
      );
      _items[productIndex] = newProduct;
      notifyListeners();
    } else {
      print('.......');
    }
  }

  //Delete Product

  void deleteProduct(String id) {
    _items.removeWhere((product) => product.id == id);

    notifyListeners();
  }
}
