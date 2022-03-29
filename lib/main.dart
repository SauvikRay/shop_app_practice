import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app_practice/provider/auth.dart';
import 'package:shop_app_practice/provider/orders.dart';
import 'package:shop_app_practice/screens/cart_screen.dart';
import 'package:shop_app_practice/screens/edit_product_screen.dart';
import 'package:shop_app_practice/screens/orders_screen.dart';
import 'package:shop_app_practice/screens/user_products_screen.dart';
import './screens/product_detail_screen.dart';
import './provider/cart.dart';
import './provider/products_provide.dart';
import './screens/auth_screen.dart';
import 'screens/products_overview_screen.dart';

void main() => runApp(
      MultiProvider(
        providers: [
          ChangeNotifierProvider(
            create: (BuildContext context) => Auth(),
          ), 
         ChangeNotifierProxyProvider<Auth, ProductsProvider>(
           

        create: (_) =>ProductsProvider('',[]) ,
          update: ( context, auth, previousProducts) => ProductsProvider(auth.token!,previousProducts!.items == [] ? [] : previousProducts.items),
                                                                                                              //null
           
          ),
          ChangeNotifierProvider(
            create: (BuildContext context) => Cart(),
          ),
          ChangeNotifierProvider(
            create: (BuildContext context) => Orders(),
          ),
        ],
        child:  Consumer<Auth>(builder:(context, auth,_) =>
           MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'MyShop',
      theme: ThemeData(
        primarySwatch: Colors.purple,
        primaryColor: Colors.deepOrange,
        fontFamily: 'Lato',
      ),
      home:auth.isAuth ?  ProductsOverviewScreen() : const AuthScreen(), // ProductsOverviewScreen(),
      routes: {

        ProductsOverviewScreen.routeName: (contx) => const ProductsOverviewScreen(),
        ProductDetailScreen.routeName: (contx) => const ProductDetailScreen(),
        CartScreen.routeName: (contx) => const CartScreen(),
        OrdersScreen.routeName: (contx) => const OrdersScreen(),
        UserProductScreen.routeName: (context) => const UserProductScreen(),
        EditProdductScreen.routename: (context) => const EditProdductScreen(),
        AuthScreen.routename: (context) => const AuthScreen(),
      },
    ),
  
  
        )  ,
      ),
    );

