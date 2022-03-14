import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app_practice/screens/edit_product_screen.dart';
import 'package:shop_app_practice/widgets/app_drawer.dart';

import '../provider/products_provide.dart';
import '../widgets/user_product_item.dart';

class UserProductScreen extends StatelessWidget {
  const UserProductScreen({Key? key}) : super(key: key);
  static const routeName = '/user-products';

  @override
  Widget build(BuildContext context) {
    final productData = Provider.of<ProductsProvider>(context);
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Your Products'),
          actions: [
            IconButton(
              onPressed: () {
                Navigator.of(context).pushNamed(EditProdductScreen.routename);
              },
              icon: const Icon(Icons.add),
            ),
          ],
        ),
        drawer: const AppDrawer(),
        body: Padding(
          padding: const EdgeInsets.all(8),
          child: ListView.separated(
            itemCount: productData.items.length,
            itemBuilder: (_, index) => UserProductItem(
              id: productData.items[index].id!,
              title: productData.items[index].title,
              imageUrl: productData.items[index].imageUrl,
            ),
            separatorBuilder: (BuildContext context, int index) {
              return const Divider();
            },
          ),
        ),
      ),
    );
  }
}
