import 'dart:async';
import 'dart:convert';
import 'package:AppDown/Shared/Services/SessionService.dart';
import 'package:AppDown/Shared/Utils/AuthException.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class AuthProvider with ChangeNotifier
{
  // 'https://identitytoolkit.googleapis.com/v1/accounts:signUp?key=AIzaSyCcGz1VoWXcGsTCyO68qoM_XBcVnEHkRpw';
  // 'https://identitytoolkit.googleapis.com/v1/accounts:signInWithPassword?key=AIzaSyCcGz1VoWXcGsTCyO68qoM_XBcVnEHkRpw'

  String _token;
  DateTime _expiryDate;
  String _userId;
  Timer _logoutTimer;

  String get userId
  {
    return isAuth ? _userId : null;
  }

  bool get isAuth
  {
    return token != null;
  }

  String get token
  {
    if (_token != null && _expiryDate != null && _expiryDate.isAfter(DateTime.now()))
    {
      return _token;
    }

    return null;
  }

  Future<void> _authenticate(String email, String password, String urlSegment) async
  {
    final url = 'https://identitytoolkit.googleapis.com/v1/accounts:$urlSegment?key=AIzaSyCcGz1VoWXcGsTCyO68qoM_XBcVnEHkRpw';

    final Map<String, dynamic> map = {'email': email, 
                                     'password': password, 
                                     'returnSecureToken': true};
    String s = jsonEncode(map);                                   

    final response = await http.post(url, body: s);

    final responseBody = jsonDecode(response.body);
    //print(responseBody);

    if (responseBody['error'] != null)
    {
      throw AuthException(responseBody['error']['message']);
    }
    else
    {
      _token = responseBody['idToken'];
      _expiryDate = DateTime.now().add(Duration(seconds: int.parse(responseBody['expiresIn'])));
      _userId = responseBody['localId'];

      await SessionService.saveSessionMap({
        "token": _token,
        "userId": _userId,
        "expiryDate": _expiryDate.toIso8601String()
      });
    }

    print('efetuou login');
    print('token: $_token, userId: $_userId, expiryDate: $_expiryDate');

    _autoLogout();
    notifyListeners();
  }

  Future<void> signup(String email, String password) async 
  {
    return _authenticate(email, password, 'signUp');
  }

  Future<void> login(String email, String password) async
  {
    return _authenticate(email, password, 'signInWithPassword');
  }

  Future<bool> tryAutoLogin() async
  {
    if (isAuth) // usuário autenticado
      return Future.value();
    
    final userSession = await SessionService.getSessionMap();
    if (userSession == null) // sessão não encontrada
      return Future.value();

    final expiryDate = DateTime.parse(userSession['expiryDate']);
    if (expiryDate.isBefore(DateTime.now())) // token expirado
      return Future.value();

    _userId = userSession['userId'];
    _token = userSession['token'];
    _expiryDate = expiryDate;

    _autoLogout();
    notifyListeners();
    return Future.value();
  }

  void logout() async
  {
    _token = null;
    _expiryDate = null;
    _userId = null;

    if (_logoutTimer != null)
    {
      _logoutTimer.cancel();
      _logoutTimer = null;
    }

    await SessionService.logoutSession();
    notifyListeners();
  }

  void _autoLogout()
  {
    if (_logoutTimer != null)
    {
      _logoutTimer.cancel();
    }

    final timeToLogout = _expiryDate.difference(DateTime.now()).inSeconds;
    _logoutTimer = Timer(Duration(seconds: timeToLogout), logout);
  }
}