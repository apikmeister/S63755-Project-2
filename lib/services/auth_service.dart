import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'package:school_management/providers/school_provider.dart';
import 'package:school_management/utils/error_handler.dart';
import 'package:school_management/widgets/shared/toast.dart';
import 'package:shared_preferences/shared_preferences.dart';

// class AuthService {
//   final String baseUrl = 'http://localhost:3000/api/auth';

//   // AuthService(this.baseUrl);
//   Future<void> login(String username, String password) async {
//     final res = await http.post(
//       Uri.parse('$baseUrl/login'),
//       body: jsonEncode({
//         'username': username,
//         'password': password,
//       }),
//       headers: {
//         'Content-Type': 'application/x-www-form-urlencoded',
//       },
//     );

//     if (res.statusCode == 200) {
//       final data = jsonDecode(res.body);
//       final token = data['token'];
//       final prefs = await SharedPreferences.getInstance();
//       await prefs.setString('token', '123');
//     } else {
//       final data = jsonDecode(res.body);
//       throw Exception(data['message'] ?? 'Failed to login');
//     }
//   }

//   Future<bool> validateToken(String token) async {
//     final res = await http.post(Uri.parse('$baseUrl/validate'), headers: {
//       'Authorization': 'Bearer $token',
//     });

//     if (res.statusCode == 200) {
//       return true;
//     } else {
//       final data = jsonDecode(res.body);
//       throw Exception(data['message'] ?? 'Failed to validate token');
//     }
//   }
// }

class AuthSevice {
  void logIn({
    required BuildContext context,
    required String username,
    required String password,
  }) async {
    try {
      http.Response res = await http.post(
        Uri.parse('http://localhost:3000/api/auth/login'),
        body: {
          'username': username,
          'password': password,
        },
        headers: {
          'Content-Type': 'application/x-www-form-urlencoded',
        },
      );
      // TODO: IDK if it can be fixed
      // ignore: use_build_context_synchronously
      httpErrorHandler(
        res: res,
        context: context,
        onSuccess: () async {
          SharedPreferences prefs = await SharedPreferences.getInstance();
          prefs.setString('token', jsonDecode(res.body)['token']);
          prefs.setString('schoolId', jsonDecode(res.body)['schoolId']);
          prefs.setBool('isLoggedIn', true);
          Provider.of<SchoolProvider>(context, listen: false)
              .setSchoolId(jsonDecode(res.body)['schoolId']);
          Navigator.pushNamedAndRemoveUntil(
              context, '/dashboard', (route) => false);
        },
      );
    } catch (e) {
      showErrorToast(context, e.toString());
      // ScaffoldMessenger.of(context).showSnackBar(
      //   SnackBar(
      //     content: Text('Error ${e.toString()}'),
      //   ),
      // );
    }
  }

  Future<bool> validateToken({
    required BuildContext context,
    required String token,
  }) async {
    try {
      bool isValid = false;
      final http.Response res = await http.post(
        Uri.parse('http://localhost:3000/api/auth/validate'),
        headers: {
          'Content-Type': 'application/x-www-form-urlencoded',
          'Authorization': 'Bearer $token',
        },
      );
      if (res.statusCode == 200) {
        isValid = true;
      } else {
        final data = jsonDecode(res.body);
        throw Exception(data['message'] ?? 'Failed to validate token');
      }
      return isValid;
    } catch (e) {
      throw Exception('Invalid token');
    }
  }
}
