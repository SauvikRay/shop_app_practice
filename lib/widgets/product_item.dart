import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app_practice/provider/cart.dart';
import 'package:shop_app_practice/provider/product.dart';

import '../screens/product_detail_screen.dart';

class ProductItem extends StatelessWidget {
  const ProductItem({Key? key}) : super(key: key);

  // final String id;
  // final String title;
  // final String imageUrl;

  @override
  Widget build(BuildContext context) {
    final productModel = Provider.of<Product>(context, listen: false);
    final cart = Provider.of<Cart>(context, listen: false);
    return ClipRRect(
      borderRadius: BorderRadius.circular(10),
      child: GridTile(
        child: GestureDetector(
          onTap: () {
            Navigator.of(context).pushNamed(
              ProductDetailScreen.routeName,
              arguments: productModel.id,
            );
          },
          child: Image.network(
            productModel.imageUrl,
            fit: BoxFit.cover,
          ),
        ),
        footer: GridTileBar(
          backgroundColor: Colors.black87,
          leading: Consumer<Product>(
            builder: (cxt, productModel, _) {
              return IconButton(
                icon: Icon(productModel.isFavorite
                    ? Icons.favorite
                    : Icons.favorite_border),
                color: Colors.pink,
                onPressed: () {
                  productModel.toogleFavouriteStatus();
                },
              );
            },
          ),
          title: Text(
            productModel.title,
            textAlign: TextAlign.center,
          ),
          trailing: IconButton(
            icon: const Icon(
              Icons.shopping_cart,
            ),
            onPressed: () {
              cart.addItem(
                  productModel.id, productModel.price, productModel.title);
            },
            color: Theme.of(context).primaryColor,
          ),
        ),
      ),
    );
  }
}
