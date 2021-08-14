import 'package:flutter/material.dart';

// Widgets Imports
import '../widgets/app_drawer.dart';

class MyProductOrdersScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('My Products Orders'),
      ),
      drawer: AppDrawer(),
    );
  }
}
