import 'package:flutter/material.dart';

// Widgets imports
import '../widgets/order_item.dart';
import '../widgets/app_drawer.dart';

// Third party packages imports
import 'package:provider/provider.dart';

// Providers imports
import '../providers/orders.dart';

class OrdersScreen extends StatefulWidget {
  static const routeName = '/orders';

  @override
  _OrdersScreenState createState() => _OrdersScreenState();
}

class _OrdersScreenState extends State<OrdersScreen> {
  var _isLoading = false;
  @override
  void initState() {
    Future.delayed(Duration.zero).then((_) async {
      setState(() {
        _isLoading = true;
      });
      await Provider.of<Orders>(context, listen: false).fetchAndSetorder();
      setState(() {
        _isLoading = false;
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final orderData = Provider.of<Orders>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text('Your Orders'),
      ),
      drawer: AppDrawer(),
      body: _isLoading
          ? Center(
              child: Column(
                children: [
                  Text(
                    'Fetching Orders',
                    style: TextStyle(fontSize: 28),
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  CircularProgressIndicator()
                ],
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
              ),
            )
          : ListView.builder(
              itemBuilder: (ctx, i) => OrderCard(orderData.orders[i]),
              itemCount: orderData.orders.length,
            ),
    );
  }
}
