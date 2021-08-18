// Dart Packages
import 'dart:convert';

import 'package:flutter/material.dart';

// Provider Imports
import './cart.dart';

// Third Party Packages
import 'package:http/http.dart' as http;

class MyProductOrderItemProfile {
  final String imageUrl;
  final int quantity;
  final double price;
  final String title;
  final String address;
  final String number;
  final String name;
  final String ordererId;
  final String num;
  final String productId;
  final String orderStatus;

  MyProductOrderItemProfile(
      this.imageUrl,
      this.quantity,
      this.price,
      this.title,
      this.address,
      this.number,
      this.name,
      this.ordererId,
      this.productId,
      this.num,
      this.orderStatus);
}

class MyProductOrders with ChangeNotifier {
  final String _authToken;
  final String _userId;
  MyProductOrders(this._authToken, this._userId, this.myProductOrders);

  List<MyProductOrderItemProfile> myProductOrders = [];

  Future<List<String>> addProductOrder(String productId, int quantity,
      String address, String name, String mobile) async {
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
          'address': address,
          'mobile': mobile,
          'name': name
        }));
    // print(extractedProductedResponse);
    print(responseFromOtherSide);
    print(responseFromOtherSide.body);
    final responseFromOtherSideData =
        json.decode(responseFromOtherSide.body) as Map<String, dynamic>;
    return [responseFromOtherSideData['name'] as String, creatorId];
  }

  Future<void> cancelOrderUserSide(CartItem ci) async {
    final creatorId = ci.productCreatorId;
    final myProductOrderId = ci.id;
    final url =
        "https://amazine-001-default-rtdb.firebaseio.com/myproductorders/$creatorId/$myProductOrderId.json?auth=$_authToken";
    final resp = await http.get(url);
    final extractedResp = json.decode(resp.body) as Map<String, Object>;
    final ordererId = extractedResp['ordererId'];
    final productId = extractedResp['productId'];
    final num = int.parse(extractedResp['num']);
    final productUrl =
        "https://amazine-001-default-rtdb.firebaseio.com/orders/$ordererId/$productId.json?auth=$_authToken";
    final productUrlResp = await http.get(
        "https://amazine-001-default-rtdb.firebaseio.com/orders/$ordererId/$productId.json?auth=$_authToken");

    final extractedProductUrl =
        json.decode(productUrlResp.body) as Map<String, Object>;

    double extractedProductUrlAmount = 0;

    final extractedProductUrlDateTime =
        extractedProductUrl['dateTime'] as String;

    final extractedProductUrlProducts =
        extractedProductUrl['products'] as List<dynamic>;
    if (extractedProductUrlProducts.length <= 1) {
      await http.delete(
          "https://amazine-001-default-rtdb.firebaseio.com/orders/$ordererId/$productId.json?auth=$_authToken");
      await http.delete(url);
      return;
    }
    extractedProductUrlProducts.removeAt(num);

    for (int i = 0; i < extractedProductUrlProducts.length; i++) {
      final price = double.parse(extractedProductUrlProducts[i]['price']);
      final qty = int.parse(extractedProductUrlProducts[i]['quantity']);
      extractedProductUrlAmount += price * qty;
    }
    final sentData = json.encode({
      'amount': extractedProductUrlAmount,
      'dateTime': extractedProductUrlDateTime,
      'products': extractedProductUrlProducts
    });
    print(sentData);
    await http.patch(productUrl, body: sentData);
    // print(sentData);
    // TO DOS USE POST REQUEST INSTEAD OF DELETE TO UPDATE DATA
    // await http.delete(productUrl);
    await http.delete(url);
  }

  Future<void> linkData(
      String userId, String myProductId, int num, List<String> lists) async {
    final url =
        "https://amazine-001-default-rtdb.firebaseio.com/myproductorders/$userId/$myProductId.json?auth=$_authToken";
    final jsonEncodedData = json.encode({
      'ordererId': lists[1],
      'productId': lists[0],
      'num': num.toString(),
      'orderstatus': 'In Process'
    });
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
    if (extractedData.isEmpty) {
      myProductOrders = [];
      return;
    }
    myProductOrders = [];
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
            finalData['title'] as String,
            finalData['address'] as String,
            finalData['mobile'] as String,
            finalData['name'] as String,
            finalData['ordererId'] as String,
            finalData['productId'] as String,
            finalData['num'] as String,
            finalData['orderstatus'] as String),
      );
      print(myProductOrders[i].imageUrl);
    }

    notifyListeners();
  }
}
