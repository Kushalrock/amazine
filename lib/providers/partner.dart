import 'dart:convert';

import 'package:flutter/material.dart';

// Third Party Packages
import 'package:http/http.dart' as http;

class Partner with ChangeNotifier {
  bool _partner;
  bool get partner {
    return _partner;
  }

  Future<void> partnerStatus() async {
    final url =
        "https://amazine-001-default-rtdb.firebaseio.com/partners/$_userId.json?auth=$_authToken";
    final response = await http.get(url);
    if (response.body == "null") {
      _partner = false;
      return;
    }
    final extractedData = json.decode(response.body) as bool;
    print(extractedData);
    if (extractedData == null) {
      _partner = false;
      return;
    }
    _partner = extractedData;
    print(_partner);
    notifyListeners();
  }

  final String _authToken;
  final String _userId;
  Partner(this._authToken, this._userId);

  Future<void> becomePartner() async {
    _partner = true;
    final url =
        "https://amazine-001-default-rtdb.firebaseio.com/partners/$_userId.json?auth=$_authToken";
    try {
      final response = await http.put(
        url,
        body: json.encode(_partner),
      );
    } catch (e) {
      throw (e);
    }

    notifyListeners();
  }

  Future<void> revokePartnership() async {
    _partner = false;
    final url =
        "https://amazine-001-default-rtdb.firebaseio.com/partners/$_userId.json?auth=$_authToken";
    try {
      await http.delete(url);
    } catch (e) {
      throw (e);
    }
    notifyListeners();
  }
}
