import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class AuthProvider extends ChangeNotifier {
  String? _token;

  Future<void> login(String username, String password) async {
    final http.Response res = await http.post(
      Uri.parse('http://localhost:3000/api/auth/login'),
      body: {
        'username': username,
        'password': password,
      },
      headers: {
        'Content-Type': 'application/x-www-form-urlencoded',
      },
    );

    if (res.statusCode == 200) {
      _token = res.body;
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('token', _token.toString());
      notifyListeners();
    } else {
      throw Exception('Failed to login');
    }
  }

  Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('token');
    _token = null;
    notifyListeners();
  }

  String get token => _token.toString();
}
