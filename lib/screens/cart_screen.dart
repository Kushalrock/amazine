import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

// Providers Imports
import '../providers/cart.dart';

// Screen Imports
import '../widgets/cart_item.dart';

class CartScreen extends StatelessWidget {
  static const routeName = '/cart';

  @override
  Widget build(BuildContext context) {
    final cart = Provider.of<Cart>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text('Your Cart'),
      ),
      body: Column(
        children: [
          Card(
            margin: EdgeInsets.all(15),
            child: Padding(
              padding: EdgeInsets.all(10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Total',
                    style: TextStyle(
                      fontSize: 20,
                    ),
                  ),
                  Consumer<Cart>(
                    builder: (ctx, cartData, _) => Chip(
                      label: Text(
                        '\$${cartData.totalAmount}',
                        style: TextStyle(
                          color: Theme.of(context).primaryTextTheme.title.color,
                        ),
                      ),
                      backgroundColor: Theme.of(context).primaryColor,
                    ),
                  ),
                  FlatButton(
                    onPressed: () {},
                    child: Text('ORDER NOW!!'),
                    textColor: Theme.of(context).primaryColor,
                  ),
                ],
              ),
            ),
          ),
          SizedBox(
            height: 10,
          ),
          Expanded(
              child: ListView.builder(
            itemBuilder: (ctx, i) => CartCard(
              id: cart.items.values.toList()[i].id,
              productId: cart.items.keys.toList()[i],
              title: cart.items.values.toList()[i].title,
              quantity: cart.items.values.toList()[i].qty,
              price: cart.items.values.toList()[i].price,
              imageUrl: cart.items.values.toList()[i].imageUrl,
            ),
            itemCount: cart.items.length,
          ))
        ],
      ),
    );
  }
}
