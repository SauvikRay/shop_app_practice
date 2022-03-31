import 'dart:convert';
import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:shop_app_practice/models/http_exceptions.dart';
import 'package:shop_app_practice/provider/product.dart';
import 'package:http/http.dart' as http;

class ProductsProvider with ChangeNotifier {
  String? authToken;
  String? userId;

  ProductsProvider(
    this.authToken,
    this.userId,
    this._items,
  );

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
    //   return _items.where((element) => element.isFavourite).toList();
    // }
    return [..._items];
  }

//Filtering the Favorites Item
  List<Product> get favoritesProduct {
    return _items.where((element) => element.isFavourite).toList();
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
            'https://shopapp-e73fe-default-rtdb.asia-southeast1.firebasedatabase.app/products.json?auth=$authToken'),
        body: jsonEncode(<String, dynamic>{
          'title': product.title,
          'description': product.description,
          'price': product.price,
          'imageUrl': product.imageUrl,
          'creatorId': userId, //sending the creator ID when an Item is added.
          // 'isFavourite': product.isFavourite,
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
    } catch (e) {
      rethrow;
    }

    //After surver is correctly respond
    // print(json.decode(response.body));
  }

  //Fetching data from the server
  Future<void> dataFromTheServer([bool filterByUser = false]) async {
    final filterString = filterByUser
        ? 'orderBy="creatorId"&equalTo="$userId"'
        : ''; // From the firebase rules
    var url =
        'https://shopapp-e73fe-default-rtdb.asia-southeast1.firebasedatabase.app/products.json?auth=$authToken&$filterString';
    try {
      final response = await http.get(
        Uri.parse(url),
      );

      final extractData = jsonDecode(response.body) as Map<String, dynamic>?;
      if (extractData == null) {
        return;
      }

      url =
          'https://shopapp-e73fe-default-rtdb.asia-southeast1.firebasedatabase.app/userFevourites/$userId.json?auth=$authToken';
      final favoriteResponse = await http.get(Uri.parse(url));
      final favoriteData = jsonDecode(favoriteResponse.body);

      //print(favoriteData);

      final List<Product> loadedProducts = [];
      extractData.forEach((productId, productData) {
        loadedProducts.add(
          Product(
            id: productId,
            title: productData['title'],
            description: productData['description'],
            price: productData['price'], //double.parse( productData['price']),
            imageUrl: productData['imageUrl'],
            isFavourite: (favoriteData == null
                ? false
                : favoriteData[productId] ??
                    false), //Error Line.. need to solvable
          ),
        );
      });
      //After extracted Data/loading the product
      _items = loadedProducts;
      notifyListeners();
      // print(extractData);
    } catch (e) {
      //  log(e.toString());
      rethrow;
    }
  }

  //Update Product
  Future<void> updateProduct(String id, Product newProduct) async {
    final productIndex = _items.indexWhere((product) => product.id == id);

    if (productIndex >= 0) {
      await http.patch(
        Uri.parse(
            'https://shopapp-e73fe-default-rtdb.asia-southeast1.firebasedatabase.app/products/$id.json?auth=$authToken'),
        body: jsonEncode(
          <String, dynamic>{
            'title': newProduct.title,
            'description': newProduct.description,
            'imageUrl': newProduct.imageUrl,
            'price': newProduct.price,
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

  Future<void> deleteProduct(String id) async {
    //Find the index of the product
    final existingProductIndex =
        _items.indexWhere((product) => product.id == id);
    Product? existingProduct = _items[existingProductIndex];
    _items.removeAt(existingProductIndex);
    //If its faild to delete product we need to re inserted in the list
    notifyListeners();
    // _items.removeWhere((product) => product.id == id);
    final response = await http.delete(
      Uri.parse(
          'https://shopapp-e73fe-default-rtdb.asia-southeast1.firebasedatabase.app/products/$id.json?auth=$authToken'),
    );
    if (response.statusCode >= 400) {
      _items.insert(existingProductIndex, existingProduct);
      notifyListeners();
      throw HttpException('Could not delete product');
    }
    existingProduct = null;
  }
}


//https://github.com/lastra-dev/flutter-shop-app/blob/master/lib/providers/products.dart