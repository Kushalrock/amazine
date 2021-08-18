import 'package:flutter/material.dart';

// Third Party Packages
import 'package:provider/provider.dart';

// Widgets Imports
import '../widgets/app_drawer.dart';
import '../widgets/my_product_order_item.dart';

// Provider Imports
import '../providers/my_product_orders.dart';

class MyProductOrdersScreen extends StatelessWidget {
  static String routeName = '/my-products-orders';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('My Products Orders'),
      ),
      body: FutureBuilder(
        builder: (ctx, snapshot) => snapshot.connectionState ==
                ConnectionState.waiting
            ? Center(
                child: CircularProgressIndicator(),
              )
            : Consumer<MyProductOrders>(
                builder: (ctx, productsData, _) => Padding(
                  padding: EdgeInsets.all(10),
                  child: ListView.builder(
                    itemBuilder: (_, i) => Column(
                      children: [
                        MyProductOrderItem(
                            productsData.myProductOrders[i].imageUrl,
                            productsData.myProductOrders[i].title.toString(),
                            productsData.myProductOrders[i].quantity,
                            productsData.myProductOrders[i].price,
                            productsData.myProductOrders[i].address,
                            productsData.myProductOrders[i].number,
                            productsData.myProductOrders[i].name),
                        Divider(),
                      ],
                    ),
                    itemCount: productsData.myProductOrders.length,
                  ),
                ),
              ),
        future: Provider.of<MyProductOrders>(context, listen: false)
            .fetchAndSetMyProductOrders(),
      ),
      drawer: AppDrawer(),
    );
  }
}
