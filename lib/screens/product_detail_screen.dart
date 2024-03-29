import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app_practice/provider/products_provide.dart';

class ProductDetailScreen extends StatelessWidget {
  const ProductDetailScreen({Key? key}) : super(key: key);
  // final String title;
  // final double price;

  // ProductDetailScreen(this.title, this.price);
  static const routeName = '/product-detail';

  @override
  Widget build(BuildContext context) {
    final productId =
        ModalRoute.of(context)!.settings.arguments as String; // is the id!

    //From the filer by Id of Product_provider Class

    final loadedProduct = Provider.of<ProductsProvider>(context, listen: false)
        .findById(productId);
    return Scaffold(
      appBar: AppBar(
        title: Text(loadedProduct.title),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(
              height: 300,
              width: double.infinity,
              child: Image.network(
                loadedProduct.imageUrl,
                fit: BoxFit.cover,
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            Text(
              '\$${loadedProduct.price}',
              style:
                  const TextStyle(fontSize: 20, color: Colors.deepOrangeAccent),
            ),
            const SizedBox(
              height: 10,
            ),
            Container(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                width: double.infinity,
                child: Text(
                  '\$${loadedProduct.description}',
                  textAlign: TextAlign.center,
                  softWrap: true,
                  style: const TextStyle(
                      fontSize: 16, color: Colors.black),
                ),),
          ],
        ),
      ),
    );
  }
}
