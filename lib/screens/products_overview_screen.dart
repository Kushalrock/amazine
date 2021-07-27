import 'package:flutter/material.dart';

// Widgets Imports
import '../widgets/products_grid.dart';

class ProductsOverViewScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Amazine'),
      ),
      body: ProductsGrid(),
    );
  }
}
