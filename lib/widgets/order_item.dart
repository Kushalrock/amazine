// dart Packages
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_complete_guide/providers/my_product_orders.dart';

//Third party packages imports
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

// Providers Imports
import '../providers/orders.dart';

class OrderCard extends StatefulWidget {
  final OrderItem order;

  OrderCard(this.order);

  @override
  _OrderCardState createState() => _OrderCardState();
}

class _OrderCardState extends State<OrderCard> {
  var _expanded = false;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.all(10),
      child: Column(
        children: [
          ListTile(
            title: Text('\$${widget.order.amount}'),
            subtitle: Text(
              DateFormat('dd MM yyyy hh:mm').format(widget.order.dateTime),
            ),
            trailing: IconButton(
              icon: Icon(_expanded ? Icons.expand_less : Icons.expand_more),
              onPressed: () {
                setState(() {
                  _expanded = !_expanded;
                });
              },
            ),
          ),
          if (_expanded)
            Container(
              height: min(widget.order.products.length * 20.0 + 60.0, 250.0),
              padding: EdgeInsets.all(10),
              child: ListView.builder(
                itemBuilder: (ctx, i) => ListTile(
                  leading: Image.network(
                    widget.order.products[i].imageUrl,
                    fit: BoxFit.cover,
                  ),
                  subtitle: Text(
                    '${widget.order.products[i].qty}x \$${widget.order.products[i].price}',
                    style: TextStyle(
                      fontSize: 18,
                      color: Colors.grey,
                    ),
                  ),
                  isThreeLine: true,
                  title: Text(widget.order.products[i].orderStatus),
                  trailing: IconButton(
                    onPressed: () async {
                      await Provider.of<MyProductOrders>(context, listen: false)
                          .cancelOrderUserSide(widget.order.products[i]);
                      await Provider.of<Orders>(context, listen: false)
                          .fetchAndSetorder();
                    },
                    icon: Icon(
                      Icons.cancel,
                      color: Colors.red,
                    ),
                  ),
                ),
                itemCount: widget.order.products.length,
              ),
            ),
        ],
      ),
    );
  }
}
