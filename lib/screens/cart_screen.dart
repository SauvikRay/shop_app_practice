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

  final cart= Provider.of<Cart>(context,listen: false);

    return SafeArea(
      child: Scaffold(
        appBar: AppBar(title:const Text('Your Cart')),
        body: Column(
          children:<Widget> [
            //Card for Total
            Card(
              margin:const EdgeInsets.all(15.0),
              child: Padding(
                padding: const EdgeInsets.all(8),
                child:Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget> [
              const Text('Total', style: TextStyle(fontSize:20,),),
              const Spacer(),
               Chip(
                 label: Text('\$${cart.totalAmount.toStringAsFixed(2)}',style:const TextStyle(color:Colors.white,),),
                 backgroundColor: Colors.deepPurple,
               ),
               // CartItem Count ==0 then remove the order now button
               (cart.itemCount == 0)?
                  Container() : TextButton(
                 child:const Text('ORDER NOW',style: TextStyle(color:Colors.indigoAccent,fontWeight: FontWeight.bold),),
                 onPressed: (){
                   Provider.of<Orders>(context,listen: false).addOrder(cart.items.values.toList(), cart.totalAmount);
                   cart.crearCard();
                 }, 
                 )  
              ] ,),
            ),
            ),
          //Card For Order Items
          Expanded(child: ListView.builder(
            itemCount: cart.items.length,
            itemBuilder: (ctx,index){
              return CartItem(
                //Convert to a MAP because the items is a MAP
               id: cart.items.values.toList()[index].id,
               productId: cart.items.keys.toList()[index],
               price: cart.items.values.toList()[index].price,
               quantity: cart.items.values.toList()[index].quantity,
               title: cart.items.values.toList()[index].title,
              );
                
            },
            ),),
          ],
        ),
      ),
    );
  }
}