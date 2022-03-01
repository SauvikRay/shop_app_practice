import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
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
        },);
  }
}
