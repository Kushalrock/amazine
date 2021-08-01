import 'package:flutter/material.dart';

// Third party packages import
import 'package:provider/provider.dart';

// Providers imports
import '../providers/products.dart';

// Widgets Imports
import '../widgets/user_product_item.dart';
import '../widgets/app_drawer.dart';

class UserProductsScreen extends StatelessWidget {
  static const routeName = '/user-products';

  @override
  Widget build(BuildContext context) {
    final productsData = Provider.of<Products>(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Your Products'),
        actions: [
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.add),
          ),
        ],
      ),
      body: Padding(
        padding: EdgeInsets.all(10),
        child: ListView.builder(
          itemBuilder: (_, i) => Column(
            children: [
              UserProductItem(
                productsData.items[i].title,
                productsData.items[i].imageUrl,
              ),
              Divider(),
            ],
          ),
          itemCount: productsData.items.length,
        ),
      ),
      drawer: AppDrawer(),
    );
  }
}
