import 'package:flutter/material.dart';

// Third party packages import
import 'package:provider/provider.dart';

// Providers imports
import '../providers/cart.dart';

class CartCard extends StatelessWidget {
  final String id;
  final String productId;
  final double price;
  final int quantity;
  final String title;
  final String imageUrl;

  CartCard(
      {this.id,
      this.productId,
      this.price,
      this.quantity,
      this.title,
      this.imageUrl});

  @override
  Widget build(BuildContext context) {
    return Dismissible(
      key: ValueKey(id),
      background: Container(
        color: Theme.of(context).errorColor,
        child: Icon(
          Icons.delete,
          color: Colors.white,
          size: 40,
        ),
        alignment: Alignment.centerRight,
        padding: EdgeInsets.only(right: 20),
        margin: EdgeInsets.symmetric(
          horizontal: 15,
          vertical: 4,
        ),
      ),
      direction: DismissDirection.endToStart,
      onDismissed: (_) {
        Provider.of<Cart>(context, listen: false).removeItem(productId);
      },
      child: Card(
        margin: EdgeInsets.symmetric(
          horizontal: 15,
          vertical: 4,
        ),
        elevation: 10,
        child: Padding(
          padding: EdgeInsets.all(10),
          child: ListTile(
            leading: Image.network(
              imageUrl,
              fit: BoxFit.cover,
            ),
            title: Text(
              title,
              style: Theme.of(context).textTheme.title,
            ),
            subtitle: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('\$$price each'),
                Text('\$${price * quantity}'),
              ],
            ),
            trailing: Container(
                margin: EdgeInsets.only(left: 40), child: Text('$quantity X')),
          ),
        ),
      ),
    );
  }
}
