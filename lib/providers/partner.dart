import 'dart:convert';

import 'package:flutter/material.dart';

// Third Party Packages
import 'package:http/http.dart' as http;

class Partner with ChangeNotifier {
  bool _partner;
  Future<bool> partnerStatus() async {
    final url =
        "https://amazine-001-default-rtdb.firebaseio.com/partners/$_userId.json?auth=$_authToken";
    final response = await http.get(url);
    if (response == null) {
      return false;
    }
    final extractedData = json.decode(response.body) as Map<String, Object>;
    _partner = extractedData['partnerStatus'] as bool;
    if (_partner == null) {
      return false;
    }
    return extractedData['partnerStatus'] as bool;
  }

  final String _authToken;
  final String _userId;
  Partner(this._authToken, this._userId);

  Future<void> becomePartner() async {
    _partner = true;
    final url =
        "https://amazine-001-default-rtdb.firebaseio.com/partners/$_userId.json?auth=$_authToken";
    try {
      final response = await http.post(
        url,
        body: json.encode({'partnerStatus': _partner}),
      );
    } catch (e) {
      throw (e);
    }

    notifyListeners();
  }
}
