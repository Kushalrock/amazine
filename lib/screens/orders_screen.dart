import 'package:flutter/material.dart';

// Widgets imports
import '../widgets/order_item.dart';
import '../widgets/app_drawer.dart';

// Third party packages imports
import 'package:provider/provider.dart';

// Providers imports
import '../providers/orders.dart';

class OrdersScreen extends StatelessWidget {
  static const routeName = '/orders';

  @override
  Widget build(BuildContext context) {
    final orderData = Provider.of<Orders>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text('Your Orders'),
      ),
      drawer: AppDrawer(),
      body: ListView.builder(
        itemBuilder: (ctx, i) => OrderCard(orderData.orders[i]),
        itemCount: orderData.orders.length,
      ),
    );
  }
}
