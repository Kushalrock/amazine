// Dart Pacakges
import 'dart:convert';

import 'package:flutter/material.dart';

// Third Party Packages
import 'package:http/http.dart' as http;

// Models Imports
import '../models/http_exception.dart';

class Auth with ChangeNotifier {
  String _token;
  DateTime _expirydate;
  String _userId;

  Future<void> _authenticate(
      String email, String password, String urlText) async {
    var url =
        'https://identitytoolkit.googleapis.com/v1/accounts:$urlText?key=AIzaSyCKNWh9dqxRTxrVKgM6-vItonY8ySUVOU0';
    try {
      final response = await http.post(
        url,
        body: json.encode(
          {
            'email': email,
            'password': password,
            'returnSecureToken': true,
          },
        ),
      );
      final responseData = json.decode(response.body);
      if (responseData['error'] != null) {
        throw HTTPException(responseData['error']['message']);
      }
    } catch (error) {
      throw error;
    }
  }

  Future<void> signUp(String email, String password) async {
    return _authenticate(email, password, 'signUp');
  }

  Future<void> login(String email, String password) async {
    return _authenticate(email, password, 'signInWithPassword');
  }
}