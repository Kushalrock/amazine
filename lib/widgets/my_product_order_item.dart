import 'package:flutter/material.dart';

class MyProductOrderItem extends StatelessWidget {
  final String imageUrl;
  final String title;
  final int quantity;
  final double price;

  MyProductOrderItem(this.imageUrl, this.title, this.quantity, this.price);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(10),
      child: ListTile(
        leading: Image.network(
          imageUrl,
          fit: BoxFit.cover,
        ),
        title: Text(title),
        subtitle: Text('$quantity X $price =   ${price * quantity}'),
        trailing: Text(quantity.toString()),
      ),
    );
  }
}
