import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../screens/cart_screen.dart';
import '../widgets/app_drawer.dart';
import '../widgets/badge.dart';
import '../provider/cart.dart';
import '../widgets/products_grid.dart';

enum FilterOption {
  Favourites,
  All,
}

class ProductsOverviewScreen extends StatefulWidget {
  const ProductsOverviewScreen({Key? key}) : super(key: key);

  @override
  State<ProductsOverviewScreen> createState() => _ProductsOverviewScreenState();
}

class _ProductsOverviewScreenState extends State<ProductsOverviewScreen> {
  var _showOnlyFavorites = false;
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: const Text('MyShop'),
          actions: <Widget>[
            PopupMenuButton(
                icon: const Icon(Icons.more_vert),
                onSelected: (FilterOption selectedValue) {
                  //print(selectedValue);

                  setState(() {
                    if (selectedValue == FilterOption.Favourites) {
                      _showOnlyFavorites = true;
                    } else {
                      _showOnlyFavorites = false;
                    }
                  });
                },
                itemBuilder: (_) => [
                      const PopupMenuItem(
                        child: Text('Only Favorites'),
                        value: FilterOption.Favourites,
                      ),
                      const PopupMenuItem(
                        child: Text('Show All'),
                        value: FilterOption.All,
                      ),
                    ]),
            Consumer<Cart>( 
              builder:(_, cartData, child) 
                    {return Badge(
                            child: child!,
                            value: cartData.itemCount.toString(),
                            );
                    },
              child: IconButton(icon:const Icon( Icons.shopping_cart),onPressed: (){
                Navigator.pushNamed(context, CartScreen.routeName);
              },),) ,  //child: IconButton(icon:const Icon( Icons.shopping_cart),onPressed: (){},),)),),
          ],
        ),
        drawer:const AppDrawer(),
        body: ProductGrid(showOnlyFavorites: _showOnlyFavorites),
      ),
    );
  }
}
