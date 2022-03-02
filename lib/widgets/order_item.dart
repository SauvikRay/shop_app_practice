import 'dart:math';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../provider/orders.dart' show OrderItem;

class OrderItems extends StatefulWidget {
  const OrderItems( this.order);

  final OrderItem order;

  @override
  State<OrderItems> createState() => _OrderItemsState();
}

class _OrderItemsState extends State<OrderItems> {

  var _expanded = false;
  @override
  Widget build(BuildContext context) {
    
    return Card(
      margin: const EdgeInsets.all(10),
      child: Column(
        children:<Widget> [
          ListTile(
            title: Text('\$${widget.order.amount}'),
            subtitle: Text(DateFormat('dd /MM /yyy').format(widget.order.dateTime), ),
            trailing: IconButton(
              icon:  Icon(_expanded ? Icons.expand_less: Icons.expand_more),
              onPressed: (){
                    setState(() {
                      _expanded = !_expanded;
                    });
              },
              ),
          ),
          if(_expanded) 
              Container(
                 padding: const EdgeInsets.symmetric(horizontal: 15,vertical: 4),
                  height: min(widget.order.products.length*20.0+10,100 ),
                  child: ListView(
                  children: widget.order.products
                      .map(
                        (prod) =>  Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children:<Widget>[
                        Text(prod.title,style:const TextStyle(fontSize: 18,fontWeight: FontWeight.bold,
                        ),
                        ),
                        Text('${prod.quantity}x \$${prod.price}',style:const TextStyle(fontSize: 18,fontWeight: FontWeight.bold,color: Colors.grey,),),
                      ]
                    )
                    ).toList(),
                  
            ),
          ),

          
        ],
      ),
    );
  }
}