// Dart Pacakges
import 'dart:convert';
import 'dart:async';

import 'package:flutter/material.dart';

// Third Party Packages
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

// Models Imports
import '../models/http_exception.dart';

class Auth with ChangeNotifier {
  String _token;
  DateTime _expirydate;
  String _userId;
  Timer _authTimer;

  var _manualLogout = false;

  bool get isAuth {
    return token != null;
  }

  String get userId {
    return _userId;
  }

  String get token {
    if (_expirydate != null &&
        _expirydate.isAfter(DateTime.now()) &&
        _token != null) {
      return _token;
    }
    return null;
  }

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
      _token = responseData['idToken'];
      _userId = responseData['localId'];
      _expirydate = DateTime.now().add(
        Duration(
          seconds: int.parse(responseData['expiresIn']),
        ),
      );
      _autoLogout();
      notifyListeners();
      _manualLogout = false;
      final prefs = await SharedPreferences.getInstance();
      final userData = json.encode({
        'token': _token,
        'userId': _userId,
        'expiryDate': _expirydate.toIso8601String(),
        'manualLogout': _manualLogout
      });
      // print(userData);
      prefs.setString('userData', userData);
      // print('$userData after save');
    } catch (error) {
      throw error;
    }
  }

  Future<bool> tryAutoLogin() async {
    final prefs = await SharedPreferences.getInstance();
    final data = prefs.getString('userData');
    if (data == null) {
      return false;
    }
    final extractedUserData = json.decode(data) as Map<String, Object>;
    if (extractedUserData['manualLogout'] == null ||
        extractedUserData['manualLogout'] == true) {
      return false;
    }
    final expiryDate = DateTime.parse(extractedUserData['expiryDate']);

    if (expiryDate.isBefore(DateTime.now())) {
      return false;
    }

    _token = extractedUserData['token'];
    _userId = extractedUserData['userId'];
    _expirydate = expiryDate;
    notifyListeners();
    _autoLogout();

    return true;
  }

  Future<void> signUp(String email, String password) async {
    return _authenticate(email, password, 'signUp');
  }

  Future<void> login(String email, String password) async {
    return _authenticate(email, password, 'signInWithPassword');
  }

  Future<void> logout() async {
    _manualLogout = true;
    final prefs = await SharedPreferences.getInstance();
    final userData = json.encode({
      'token': _token,
      'userId': _userId,
      'expiryDate': _expirydate.toIso8601String(),
      'manualLogout': _manualLogout
    });
    prefs.setString('userData', userData);
    _token = null;
    _userId = null;
    _expirydate = null;
    if (_authTimer != null) {
      _authTimer = null;
    }
    notifyListeners();
  }

  void _autoLogout() {
    if (_authTimer != null) {
      _authTimer.cancel();
    }
    final timeToExpiry = _expirydate.difference(DateTime.now()).inSeconds;
    _authTimer = Timer(Duration(seconds: timeToExpiry), logout);
  }
}
