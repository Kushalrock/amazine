import 'package:flutter/material.dart';

class MyProductOrderItem extends StatelessWidget {
  final String imageUrl;
  final String title;
  final int quantity;
  final double price;
  final String address;
  final String number;
  final String name;

  MyProductOrderItem(this.imageUrl, this.title, this.quantity, this.price,
      this.address, this.number, this.name);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(10),
      child: Container(
        child: Column(
          children: [
            ListTile(
              leading: Image.network(
                imageUrl,
                fit: BoxFit.cover,
              ),
              title: Text(title),
              trailing: Text('$quantity X $price =   ${price * quantity}'),
              subtitle: Row(
                children: [
                  IconButton(
                    onPressed: () {},
                    icon: Icon(
                      Icons.check,
                      color: Colors.green,
                    ),
                  ),
                  IconButton(
                    onPressed: () {},
                    icon: Icon(
                      Icons.cancel_outlined,
                      color: Colors.red,
                    ),
                  ),
                  IconButton(
                      onPressed: () {},
                      icon: Icon(
                        Icons.unarchive,
                        color: Colors.yellow,
                      ))
                ],
              ),
            ),
            Text(
              address,
              textAlign: TextAlign.center,
            ),
            SizedBox(
              height: 10,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [Text(name), Text(number)],
            )
          ],
        ),
      ),
    );
  }
}
