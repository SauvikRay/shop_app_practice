import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../widgets/app_drawer.dart';
import '../widgets/order_item.dart';
import '../provider/orders.dart' show Orders;

class OrdersScreen extends StatelessWidget {
  const OrdersScreen({Key? key}) : super(key: key);
  static const routeName = '/order-screen';

  @override
  Widget build(BuildContext context) {
    final ordersData = Provider.of<Orders>(context);
    return SafeArea(
      child: Scaffold(
        appBar:AppBar(title: const Text('Your Order'),),
        drawer:const AppDrawer(),
        body:ListView.builder(
          itemCount: ordersData.orders.length,
          itemBuilder: (ctx,index)=> OrderItems(ordersData.orders[index]),
          ),
      ),
    );
  }
}