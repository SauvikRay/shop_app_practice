import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app_practice/provider/products_provide.dart';
import '../screens/cart_screen.dart';
import '../widgets/app_drawer.dart';
import '../widgets/badge.dart';
import '../provider/cart.dart';
import '../widgets/products_grid.dart';

enum FilterOption {
  favourites,
  all,
}

class ProductsOverviewScreen extends StatefulWidget {
  const ProductsOverviewScreen({Key? key}) : super(key: key);

  static const routeName = '/products-overview';

  @override
  State<ProductsOverviewScreen> createState() => _ProductsOverviewScreenState();
}

class _ProductsOverviewScreenState extends State<ProductsOverviewScreen> {
  bool _showOnlyFavorites = false;
  var _isInit =true;
  var  _isLoadding = false;

    @override
  void initState() {
    // Future.delayed(Duration.zero).then((_) => {
    // Provider.of<ProductsProvider>(context,listen: false).dataFromTheServer(),

    // });
    super.initState();
  }

  @override
  void didChangeDependencies() {
    
      if(_isInit){
        setState(() {
          
        _isLoadding = true;
        });
        Provider.of<ProductsProvider>(context,listen: false).dataFromTheServer().then((_){
          setState(() {
          _isLoadding =false;
            
          });
        });
      }
      _isInit = false;
    super.didChangeDependencies();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('MyShop'),
        actions: <Widget>[
          PopupMenuButton(
              icon: const Icon(Icons.more_vert),
              onSelected: (FilterOption selectedValue) {
                //print(selectedValue);

                setState(() {
                  if (selectedValue == FilterOption.favourites) {
                    _showOnlyFavorites = true;
                  } else {
                    _showOnlyFavorites = false;
                  }
                });
              },
              itemBuilder: (_) => [
                    const PopupMenuItem(
                      child: Text('Only Favorites'),
                      value: FilterOption.favourites,
                    ),
                    const PopupMenuItem(
                      child: Text('Show All'),
                      value: FilterOption.all,
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
      body: _isLoadding? const Center(child: CircularProgressIndicator(color: Colors.pink,),) : ProductGrid(showOnlyFavorites: _showOnlyFavorites),
    );
  }
}
