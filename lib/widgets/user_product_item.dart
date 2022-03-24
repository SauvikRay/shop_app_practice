import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app_practice/provider/products_provide.dart';
import 'package:shop_app_practice/screens/edit_product_screen.dart';

class UserProductItem extends StatelessWidget {
  final String id;
  final String title;
  final String imageUrl;

  const UserProductItem(
      {Key? key, required this.id, required this.title, required this.imageUrl})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    Future<void> _showDialog() async {
      return showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: const Text('This Item will be Deleted'),
              content: SingleChildScrollView(
                child: ListBody(
                  children: const <Widget>[
                    Text('If you want to remove this item press"YES"'),
                    Text('If you want to keep this item press"NO"'),
                  ],
                ),
              ),
              actions: <Widget>[
                TextButton(
                  child: const Text('YES'),
                  onPressed: () async {
                    try {
                      await Provider.of<ProductsProvider>(context,
                              listen: false)
                          .deleteProduct(id);
                    } catch (e) {
                      const snackBar = SnackBar(
                        content: Text('Deleting failed'),
                      );
                      ScaffoldMessenger.of(context).showSnackBar(snackBar);
                      rethrow;
                    }
                    Navigator.of(context).pop();
                  },
                ),
                TextButton(
                  child: const Text('NO'),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
              ],
            );
          });
    }

    return ListTile(
      title: Text(title),
      leading: CircleAvatar(
        backgroundImage: NetworkImage(imageUrl),
      ),
      trailing: SizedBox(
        width: 100,
        child: Row(
          children: [
            IconButton(
              onPressed: () {
                Navigator.of(context)
                    .pushNamed(EditProdductScreen.routename, arguments: id);
              },
              icon: const Icon(
                Icons.edit,
                color: Colors.pinkAccent,
              ),
            ),
            IconButton(
              onPressed: () {
                _showDialog();
              },
              icon: const Icon(
                Icons.delete,
                color: Colors.red,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
