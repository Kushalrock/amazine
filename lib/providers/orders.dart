// Dart Packages
import 'dart:convert';

import 'package:flutter/foundation.dart';

// Third party pacakages imports
import 'package:http/http.dart' as http;

// Providers Imports
import '../providers/cart.dart';

class OrderItem {
  final String id;
  final double amount;
  final List<CartItem> products;
  final DateTime dateTime;

  OrderItem({
    @required this.id,
    @required this.amount,
    @required this.products,
    @required this.dateTime,
  });
}

class Orders with ChangeNotifier {
  List<OrderItem> _orders = [];

  final String _authToken;
  final String userId;
  Orders(this._authToken, this.userId, this._orders);

  List<OrderItem> get orders {
    return [..._orders];
  }

  List<Map<String, String>> setOrder(
      List<CartItem> cp, List<List<String>> lists) {
    List<Map<String, String>> returnData = [];
    for (int i = 0; i < cp.length; i++) {
      returnData.add({
        'myproductid': lists[i][0],
        'title': cp[i].title,
        'quantity': cp[i].qty.toString(),
        'price': cp[i].price.toString(),
        'imageurl': cp[i].imageUrl,
        'productcreatorid': lists[i][1]
      });
    }
    return returnData;
  }

  Future<void> fetchAndSetorder() async {
    final url =
        "https://amazine-001-default-rtdb.firebaseio.com/orders/$userId.json?auth=$_authToken";
    final response = await http.get(url);
    final List<OrderItem> loadedOrders = [];
    final extractedData = json.decode(response.body) as Map<String, dynamic>;
    if (extractedData == null) {
      return;
    }
    extractedData.forEach((orderId, orderData) {
      loadedOrders.add(OrderItem(
          id: orderId,
          amount: orderData['amount'],
          products: (orderData['products'] as List<dynamic>)
              .map(
                (e) => CartItem(
                  id: e['myproductid'],
                  title: e['title'],
                  qty: int.parse(e['quantity']),
                  price: double.parse(e['price']),
                  imageUrl: e['imageurl'],
                  productCreatorId: e['productcreatorid'],
                ),
              )
              .toList(),
          dateTime: DateTime.parse(orderData['dateTime'])));
    });
    _orders = loadedOrders.reversed.toList();
    notifyListeners();
  }

  Future<List<String>> addOrder(List<CartItem> cartProducts, double total,
      List<List<String>> lists) async {
    final url =
        'https://amazine-001-default-rtdb.firebaseio.com/orders/$userId.json?auth=$_authToken';
    final timeStamp = DateTime.now();
    final response = await http.post(url,
        body: json.encode({
          'amount': total,
          'dateTime': timeStamp.toIso8601String(),
          'products': setOrder(cartProducts, lists),
        }));
    print(response.body + " from Orders.dart file");
    final respData = json.decode(response.body) as Map<String, dynamic>;
    _orders.insert(
      0,
      OrderItem(
        id: json.decode(response.body)['name'],
        amount: total,
        products: cartProducts,
        dateTime: timeStamp,
      ),
    );
    notifyListeners();
    return [respData['name'] as String, userId];
  }
}
