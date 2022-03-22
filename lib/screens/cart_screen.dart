import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../provider/orders.dart';
//Only Import Cart class
import '../provider/cart.dart' show Cart;
import '../widgets/cart_item.dart';

class CartScreen extends StatelessWidget {
  const CartScreen({Key? key}) : super(key: key);

  static const routeName = '/cart-screen';

  @override
  Widget build(BuildContext context) {
    final cart = Provider.of<Cart>(context, listen: false);

    return SafeArea(
      child: Scaffold(
        appBar: AppBar(title: const Text('Your Cart')),
        body: Column(
          children: <Widget>[
            //Card for Total
            Card(
              margin: const EdgeInsets.all(15.0),
              child: Padding(
                padding: const EdgeInsets.all(8),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    const Text(
                      'Total',
                      style: TextStyle(
                        fontSize: 20,
                      ),
                    ),
                    const Spacer(),
                    Chip(
                      label: Text(
                        '\$${cart.totalAmount.toStringAsFixed(2)}',
                        style: const TextStyle(
                          color: Colors.white,
                        ),
                      ),
                      backgroundColor: Colors.deepPurple,
                    ),
                    OrderButton(cart: cart),
                    
                  ],
                ),
              ),
            ),
            //Card For Order Items
            Expanded(
              child: ListView.builder(
                itemCount: cart.items.length,
                itemBuilder: (ctx, index) {
                  return CartItem(
                    //Convert to a MAP because the items is a MAP
                    id: cart.items.values.toList()[index].id,
                    productId: cart.items.keys.toList()[index],
                    price: cart.items.values.toList()[index].price,
                    quantity: cart.items.values.toList()[index].quantity,
                    title: cart.items.values.toList()[index].title,
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class OrderButton extends StatefulWidget {
  final Cart cart;
  const OrderButton({
    Key? key,
    required this.cart,
  }) : super(key: key);

  @override
  State<OrderButton> createState() => _OrderButtonState();
}

class _OrderButtonState extends State<OrderButton> {

  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    return TextButton(
      child: _isLoading ? const CircularProgressIndicator():  Text(
        'ORDER NOW',
        style:
            TextStyle(color: (_isLoading ||widget.cart.totalAmount <= 0)? Colors.indigoAccent.withOpacity(0.3): Colors.indigoAccent , fontWeight: FontWeight.bold),
      ),
      // CartItem Count ==0 then remove the order now button.
      onPressed:( widget.cart.totalAmount <= 0 || _isLoading)
          ? null
          : () async {
            setState(() {
              _isLoading = true;
            });
             await Provider.of<Orders>(context, listen: false)
                  .addOrder(widget.cart.items.values.toList(), widget.cart.totalAmount);
              widget.cart.crearCard();
              setState(() {
              _isLoading = false;
            });
            },
    );
  }
}
