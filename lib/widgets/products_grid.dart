import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app_practice/provider/products_provide.dart';
import 'product_item.dart';

class ProductGrid extends StatelessWidget {
  const ProductGrid({Key? key,required this.showOnlyFavorites}) : super(key: key);

  final bool showOnlyFavorites;

  @override
  Widget build(BuildContext context) {
    final productsData = Provider.of<ProductsProvider>(context);
    final productListProvider = showOnlyFavorites ? productsData.favoritesProduct : productsData.items;

    return GridView.builder(
      padding: const EdgeInsets.all(10.0),
      itemCount: productListProvider.length,
      itemBuilder: (context, index) => ChangeNotifierProvider.value(
        //create: (BuildContext context) => productListProvider[index],
        value:productListProvider[index],
        // create: (_) => productListProvider[index],
        child: const ProductItem(),
      ),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 3 / 2,
        crossAxisSpacing: 10,
        mainAxisSpacing: 10,
      ),
    );
  }
}
