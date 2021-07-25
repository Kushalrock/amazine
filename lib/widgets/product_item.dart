import 'package:flutter/material.dart';

class ProductItem extends StatelessWidget {
  // Product Properties

  final String id;
  final String title;
  // final String description;
  final String imageUrl;
  // final double price;

  ProductItem(this.id, this.title, this.imageUrl);

  @override
  Widget build(BuildContext context) {
    return GridTile(
      child: Image.network(
        imageUrl,
        fit: BoxFit.cover,
      ),
      footer: GridTileBar(
        backgroundColor: Colors.black54,
        leading: IconButton(onPressed: () {}, icon: Icon(Icons.favorite)),
        title: Text(
          title,
          textAlign: TextAlign.center,
        ),
        trailing: IconButton(
          onPressed: () {},
          icon: Icon(Icons.shopping_cart),
        ),
      ),
    );
  }
}
