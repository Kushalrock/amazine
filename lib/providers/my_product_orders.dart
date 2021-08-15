// Dart Packages
import 'dart:convert';

import 'package:flutter/material.dart';

// Third Party Packages
import 'package:http/http.dart' as http;

class MyProductOrderItemProfile {
  final String imageUrl;
  final int quantity;
  final double price;
  final String title;

  MyProductOrderItemProfile(
      this.imageUrl, this.quantity, this.price, this.title);
}

class MyProductOrders with ChangeNotifier {
  final String _authToken;
  final String _userId;
  MyProductOrders(this._authToken, this._userId, this.myProductOrders);

  List<MyProductOrderItemProfile> myProductOrders = [];

  Future<List<String>> addProductOrder(String productId, int quantity) async {
    print('Done');
    final productUrl =
        "https://amazine-001-default-rtdb.firebaseio.com/products/$productId.json?auth=$_authToken";
    final productResponse = await http.get(productUrl);
    final extractedProductedResponse =
        json.decode(productResponse.body) as Map<String, Object>;
    final creatorId = extractedProductedResponse['creatorId'];
    final url =
        "https://amazine-001-default-rtdb.firebaseio.com/myproductorders/$creatorId.json?auth=$_authToken";
    final responseFromOtherSide = await http.post(url,
        body: json.encode({
          'title': extractedProductedResponse['title'],
          'price': extractedProductedResponse['price'],
          'imageUrl': extractedProductedResponse['imageUrl'],
          'quantity': quantity,
        }));
    // print(extractedProductedResponse);
    print(responseFromOtherSide);
    print(responseFromOtherSide.body);
    final responseFromOtherSideData =
        json.decode(responseFromOtherSide.body) as Map<String, dynamic>;
    return [responseFromOtherSideData['name'] as String, creatorId];
  }

  Future<void> linkData(
      String userId, String myProductId, int num, List<String> lists) async {
    final url =
        "https://amazine-001-default-rtdb.firebaseio.com/myproductorders/$userId/$myProductId.json?auth=$_authToken";
    final jsonEncodedData = json.encode(
        {'ordererId': lists[1], 'productId': lists[0], 'num': num.toString()});
    final resp = await http.patch(url, body: jsonEncodedData);
    print(resp.body + "my products order");
  }

  Future<void> fetchAndSetMyProductOrders() async {
    //print('Hiii');
    final url =
        "https://amazine-001-default-rtdb.firebaseio.com/myproductorders/$_userId.json?auth=$_authToken";
    final response = await http.get(url);
    final extractedData = json.decode(response.body) as Map<String, Object>;
    // print(extractedData.length);
    for (int i = 0; i <= extractedData.length; i++) {
      final finalData =
          extractedData[extractedData.keys.toList()[i]] as Map<String, Object>;
      int quantityk = finalData['quantity'] as int;
      print(quantityk);
      myProductOrders.add(
        MyProductOrderItemProfile(
            finalData['imageUrl'] as String,
            finalData['quantity'] as int,
            finalData['price'] as double,
            finalData['title'] as String),
      );
      print(myProductOrders[i].imageUrl);
    }

    notifyListeners();
  }
}
