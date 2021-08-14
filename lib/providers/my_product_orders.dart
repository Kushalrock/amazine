// Dart Packages
import 'dart:convert';

import 'package:flutter/material.dart';

// Third Party Packages
import 'package:http/http.dart' as http;

class MyProductOrders with ChangeNotifier {
  final String _authToken;
  MyProductOrders(this._authToken);

  List<Map<String, Object>> myProductOrders;

  Future<void> addProductOrder(String productId, int quantity) async {
    print('Done');
    final productUrl =
        "https://amazine-001-default-rtdb.firebaseio.com/products/$productId.json?auth=$_authToken";
    final productResponse = await http.get(productUrl);
    final extractedProductedResponse =
        json.decode(productResponse.body) as Map<String, Object>;
    final creatorId = extractedProductedResponse['creatorId'];
    final url =
        "https://amazine-001-default-rtdb.firebaseio.com/myproductorders/$creatorId.json?auth=$_authToken";
    http.post(url,
        body: json.encode({
          'title': extractedProductedResponse['title'],
          'price': extractedProductedResponse['price'],
          'imageUrl': extractedProductedResponse['imageUrl'],
          'quantity': quantity,
        }));
    print(extractedProductedResponse);
  }
}
