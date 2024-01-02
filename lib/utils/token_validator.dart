import 'package:flutter/material.dart';
import 'package:school_management/services/auth_service.dart';
import 'package:school_management/utils/error_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';

class TokenValidationWrapper extends StatelessWidget {
  final Widget child;
  // final AuthService _authService = AuthService();
  final AuthSevice _authService = AuthSevice();

  // const
  TokenValidationWrapper({Key? key, required this.child}) : super(key: key);

  // Future<bool> _isValidToken() async {
  //   final prefs = await SharedPreferences.getInstance();
  //   final token = prefs.getString('token');
  //   return _authService.validateToken(context: context, token: token)
  //   // Add your token validation logic here
  //   // return token != null && token.isNotEmpty;
  // }

  @override
  Widget build(BuildContext context) {
    Future<bool> _isValidToken() async {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('token');
      print(token);
      return _authService.validateToken(context: context, token: token!);
      // Add your token validation logic here
      // return token != null && token.isNotEmpty;
    }

    return FutureBuilder<bool>(
      future: _isValidToken(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Scaffold(body: Center(child: CircularProgressIndicator()));
        } else if (snapshot.hasError || !snapshot.data!) {
          // If the token is not valid, show a warning message and redirect to the login screen
          WidgetsBinding.instance!.addPostFrameCallback((_) {
            // ScaffoldMessenger.of(context).showSnackBar(
            //   SnackBar(content: Text('Invalid token. Please log in again.')),
            // );
            ScaffoldMessenger.of(context)
              ..hideCurrentSnackBar()
              ..showSnackBar(
                  errorSnackBar('Invalid token. Please log in again.'));
            Navigator.pushReplacementNamed(context, '/login');
          });
          return Container();
        } else {
          // If the token is valid, return the child widget
          return child;
        }
      },
    );
  }
}

Future<String> getToken() async {
  final prefs = await SharedPreferences.getInstance();
  final token = prefs.getString('token');
  return token!;
}
