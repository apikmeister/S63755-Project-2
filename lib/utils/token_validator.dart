import 'package:flutter/material.dart';
import 'package:school_management/services/auth_service.dart';
import 'package:school_management/utils/error_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';

class TokenValidationWrapper extends StatelessWidget {
  final Widget child;
  final AuthSevice _authService = AuthSevice();

  TokenValidationWrapper({Key? key, required this.child}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Future<bool> isValidToken() async {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('token');

      return _authService.validateToken(context: context, token: token!);
    }

    return FutureBuilder<bool>(
      future: isValidToken(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
              body: Center(child: CircularProgressIndicator()));
        } else if (snapshot.hasError || !snapshot.data!) {
          // If the token is not valid, show a warning message and redirect to the login screen
          WidgetsBinding.instance!.addPostFrameCallback((_) {
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
