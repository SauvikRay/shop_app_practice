import 'dart:convert';
import 'dart:async';
import 'package:flutter/material.dart';

import 'package:http/http.dart' as http;
import 'package:shop_app_practice/models/http_exceptions.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../constant/constant.dart';

class Auth with ChangeNotifier {
  String? _token;
  String? _userId;
  DateTime? _expireDate;
  Timer? _authTimer;

  //get the userId
  String? get userId {
    return _userId;
  }

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
      //  print(responseDdata['error']);
      //if not erroe occured
      _token = responseDdata['idToken'];
      _userId = responseDdata['localId'];
      _expireDate = DateTime.now()
          .add(Duration(seconds: int.parse(responseDdata['expiresIn'])));
      _autoLogOut(); //AutoLogout function
      notifyListeners();

      //This is fo Complex data store in storage
      final storage = await SharedPreferences.getInstance();
      final userData = jsonEncode(
        {
          'token': _token,
          'userId': _userId,
          'expireDate': _expireDate!.toIso8601String(),
        },
      );
      storage.setString('userData', userData);
    } catch (e) {
      rethrow;
    }
    // print(jsonDecode(response.body));
  }

  //AutoLogIn method as a boolean
  Future<bool> tryAutoLogin() async {
    final storage =
        await SharedPreferences.getInstance(); //Initialize the storage variable
    if (!storage.containsKey('userData')) {
      //user data false
      return false;
    }
    final extractedStorageData = jsonDecode(storage.getString('userData')!)
        as Map<String, dynamic>; //Complex data so decode the jesob formate
    //print(extractedStorageData);
    final expireDate = DateTime.parse(extractedStorageData['expireDate']);
    // print(expireDate);
    if (expireDate.isBefore(DateTime.now())) {
      return false;
    }
    _token = extractedStorageData['token'];
    _userId = extractedStorageData['userId'];
    _expireDate = expireDate;
    notifyListeners();
    _autoLogOut();
    return true;
  }

  //Creating signUp logic
  Future<void> signUp(String email, String password) async {
    return _authenticate(email, password, 'signUp');
  }

//Creating Login logic
  Future<void> login(String email, String password) async {
    return _authenticate(email, password, 'signInWithPassword');
  }

  Future<void> logOut() async {
    _token = null;
    _userId = null;
    _expireDate = null;
    if (_authTimer != null) {
      _authTimer!.cancel;
      _authTimer = null;
    }
    notifyListeners();
    final storage = await SharedPreferences.getInstance();
    storage.clear();//all are cleared
  }

//autoLogOut
  void _autoLogOut() {
    if (_authTimer != null) {
      _authTimer!.cancel();
    }
    final expireTime = _expireDate!.difference(DateTime.now()).inMinutes;
    // print('Time is $expireTime');
    _authTimer = Timer(
      Duration(minutes: expireTime),
      logOut,
    );
  }
}
