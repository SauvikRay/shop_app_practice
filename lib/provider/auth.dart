import 'dart:convert';

import 'package:flutter/material.dart';

import 'package:http/http.dart' as http;
import 'package:shop_app_practice/models/http_exceptions.dart';

import '../constant/constant.dart';

class Auth with ChangeNotifier {
 late String? _token;
  //String? _userId;
  DateTime? _expireDate;

  //checking the expire date
  String? get token {
    if (_expireDate != null &&
        _expireDate!.isAfter(DateTime.now()) &&
        _token != null) {
      return _token;
    }
    return null;
  }

  //get the toke
  bool get isAuth {
    return token != null;
  }

  //Checking Authentication Logic
  Future<void> _authenticate(
      String email, String password, String urlSegment) async {
    try {
      final url =
          'https://identitytoolkit.googleapis.com/v1/accounts:$urlSegment?key=$apiKey';
      final response = await http.post(
        Uri.parse(url),
        body: jsonEncode(
          {
            'email': email,
            'password': password,
            'returnSecureToken': true,
          },
        ),
      );
      final responseDdata = jsonDecode(response.body);

      if (responseDdata['error'] != null) {
        throw HttpException(responseDdata['error']['message']);
      }
      //if not erroe occured
      _token = responseDdata['idToken'];
      //_userId = responseDdata['localId'];
      _expireDate = DateTime.now()
          .add(Duration(seconds: int.parse(responseDdata['expiresIn'])));

      notifyListeners();
    } catch (e) {
      rethrow;
    }
    // print(jsonDecode(response.body));
  }

  //Creating signUp logic
  Future<void> signUp(String email, String password) async {
    return _authenticate(email, password, 'signUp');
  }

//Creating Login logic
  Future<void> login(String email, String password) async {
    return _authenticate(email, password, 'signInWithPassword');
  }
}
