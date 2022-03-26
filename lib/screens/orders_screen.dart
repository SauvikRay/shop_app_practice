import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../widgets/app_drawer.dart';
import '../widgets/order_item.dart';
import '../provider/orders.dart' show Orders;

class OrdersScreen extends StatefulWidget {
  const OrdersScreen({Key? key}) : super(key: key);
  static const routeName = '/order-screen';

  @override
  State<OrdersScreen> createState() => _OrdersScreenState();
}

class _OrdersScreenState extends State<OrdersScreen> {
  late Future _orderFuture;

  Future _obtainedOrdersFuture() {
    return Provider.of<Orders>(context, listen: false).fetchAndSetOrders();
  }

  @override
  void initState() {
    _orderFuture = _obtainedOrdersFuture();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Your Order'),
        ),
        drawer: const AppDrawer(),
        body: FutureBuilder(
          future: _orderFuture,
          builder: (BuildContext context, AsyncSnapshot snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: CircularProgressIndicator(
                  color: Color.fromARGB(255, 224, 153, 0),
                ),
              );
            } else {
              if (snapshot.error != null) {
                return const Center(
                  child: Text('An error has occured!'),
                );
              } else {
                return Consumer<Orders>(
                  builder: ((context, orderData, child) => ListView.builder(
                        itemCount: orderData.orders.length,
                        itemBuilder: (ctx, index) =>
                            OrderItems(order: orderData.orders[index]),
                      )),
                );
              }
            }
          },
        ),
      ),
    );
  }
}
