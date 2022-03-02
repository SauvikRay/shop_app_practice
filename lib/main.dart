import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app_practice/provider/orders.dart';
import 'package:shop_app_practice/screens/cart_screen.dart';
import 'package:shop_app_practice/screens/orders_screen.dart';
import './screens/products_overview_screen.dart';
import './screens/product_detail_screen.dart';
import './provider/cart.dart';
import './provider/products_provide.dart';

void main() => runApp(MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (BuildContext context) => ProductsProvider(),
        ),
        ChangeNotifierProvider(
          create: (BuildContext context) => Cart(),
        ),
        ChangeNotifierProvider(
          create: (BuildContext context) => Orders(),
        ),
      ],
        child: const MyApp(),
      ),
    );

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'MyShop',
        theme: ThemeData(
          primarySwatch: Colors.purple,
          primaryColor: Colors.deepOrange,
          fontFamily: 'Lato',
        ),
        home:const ProductsOverviewScreen(),
        routes: {
          ProductDetailScreen.routeName: (contx) => const ProductDetailScreen(),
          CartScreen.routeName : (contx)=> const CartScreen(),
          OrdersScreen.routeName: (contx) => const OrdersScreen(),
        },);
  }
}
