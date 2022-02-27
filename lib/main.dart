import 'package:flutter/material.dart';

import './screens/products_overview_screen.dart';
import './screens/product_detail_screen.dart';

void main() => runApp( const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({Key?key}):super(key: key);
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'MyShop',
        theme: ThemeData(
          primarySwatch: Colors.purple,
          primaryColor: Colors.amberAccent,

          fontFamily: 'Lato',
        ),
        home: ProductsOverviewScreen(),
        routes: {
          ProductDetailScreen.routeName: (ctx) => ProductDetailScreen(),
        }
    );
  }
}