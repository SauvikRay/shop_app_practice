import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app_practice/provider/auth.dart';
import 'package:shop_app_practice/provider/orders.dart';
import 'package:shop_app_practice/screens/cart_screen.dart';
import 'package:shop_app_practice/screens/edit_product_screen.dart';
import 'package:shop_app_practice/screens/orders_screen.dart';
import 'package:shop_app_practice/screens/splash_screen.dart';
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
            create: (_) => ProductsProvider('', '', []),
            update: (context, auth, previousProducts) => ProductsProvider(
                auth.token,
                auth.userId,
                previousProducts!.items == [] ? [] : previousProducts.items),
            //null
          ),
          ChangeNotifierProvider(
            create: (BuildContext context) => Cart(),
          ),
          ChangeNotifierProxyProvider<Auth, Orders>(
            create: (_) => Orders('', '', []),
            update: (context, auth, previousOrder) => Orders(
                auth.token!,
                auth.userId!,
                previousOrder!.orders == [] ? [] : previousOrder.orders),
          ),
        ],
        child: Consumer<Auth>(
          builder: (context, auth, _) =>
              // MyApp(auth.isAuth, auth.tryAutoLogin()),
          // Consumer<Auth>(
          //   builder: (context, auth, _) => MyApp(),
             MaterialApp(
              debugShowCheckedModeBanner: false,
              title: 'MyShop',
              theme: ThemeData(
                primarySwatch: Colors.purple,
                primaryColor: Colors.deepOrange,
                fontFamily: 'Lato',
              ),
              home: auth.isAuth
                  ?const ProductsOverviewScreen()
                  : FutureBuilder(
              future: auth.tryAutoLogin(),
              builder: (context, authSnapshot) =>
                  authSnapshot.connectionState == ConnectionState.waiting
                      ? const SplashScreen() :const AuthScreen()), // ProductsOverviewScreen(),
              routes: {
                ProductsOverviewScreen.routeName: (contx) =>
                    const ProductsOverviewScreen(),
                ProductDetailScreen.routeName: (contx) =>
                    const ProductDetailScreen(),
                CartScreen.routeName: (contx) => const CartScreen(),
                OrdersScreen.routeName: (contx) => const OrdersScreen(),
                UserProductScreen.routeName: (context) =>
                    const UserProductScreen(),
                EditProdductScreen.routename: (context) =>
                    const EditProdductScreen(),
                AuthScreen.routename: (context) => const AuthScreen(),
              },
            ),

          ),
        // ),
      ),
    );

// class MyApp extends StatelessWidget {
//  const MyApp(this.myAuth, this.autoLogin, {Key? key}) : super(key: key);
//   final bool myAuth;
//   final Future<bool> autoLogin;

//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       debugShowCheckedModeBanner: false,
//       title: 'MyShop',
//       theme: ThemeData(
//         primarySwatch: Colors.purple,
//         primaryColor: Colors.deepOrange,
//         fontFamily: 'Lato',
//       ),
//       home: myAuth
//           ? const ProductsOverviewScreen()
//           : FutureBuilder(
//               future: autoLogin,
//               builder: (context, authSnapshot) =>
//                   authSnapshot.connectionState == ConnectionState.waiting
//                       ? const SplashScreen()
//                       : const AuthScreen(),
//             ),
//       routes: {
//         ProductsOverviewScreen.routeName: (contx) =>
//             const ProductsOverviewScreen(),
//         ProductDetailScreen.routeName: (contx) => const ProductDetailScreen(),
//         CartScreen.routeName: (contx) => const CartScreen(),
//         OrdersScreen.routeName: (contx) => const OrdersScreen(),
//         UserProductScreen.routeName: (context) => const UserProductScreen(),
//         EditProdductScreen.routename: (context) => const EditProdductScreen(),
//         AuthScreen.routename: (context) => const AuthScreen(),
//       },
//     );
//   }
// }
