import 'package:flutter/material.dart';

import 'package:http/http.dart' as http;

import '../constant/constant.dart';

class Auth with ChangeNotifier {
  late String _token;
  late DateTime _expireDate;
  late DateTime _userId;

  Future<void> signUp(String email, String password) async {
    const url = 'https://identitytoolkit.googleapis.com/v1/accounts:signUp?key=$API_KEY' ;


  }
}
