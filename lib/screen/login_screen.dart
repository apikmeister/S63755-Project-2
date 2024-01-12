import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'package:school_management/providers/school_provider.dart';
import 'package:school_management/services/auth_service.dart';
import 'package:school_management/utils/error_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Login Screen'),
        backgroundColor: Colors.deepPurple,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Login',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 10),
            LoginForm(),
          ],
        ),
      ),
    );
  }
}

class LoginForm extends StatefulWidget {
  const LoginForm({super.key});

  @override
  State<LoginForm> createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  bool _passwordVisible = false;

  final _formKey = GlobalKey<FormState>();
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();
  final AuthSevice _authService = AuthSevice();

  void _handleLogin() async {
    try {
      if (_formKey.currentState!.validate()) {
        // final login = await _authService.login(
        //   _usernameController.text,
        //   _passwordController.text,
        // );
        _authService.logIn(
          context: context,
          username: _usernameController.text,
          password: _passwordController.text,
        );
        // Provider.of<SchoolProvider>(context, listen: false).setSchoolId(id);
        // Navigator.pushNamed(context, '/dashboard');
        // Navigator.pushReplacementNamed(context, '/dashboard');
      }
    } catch (e) {
      // ScaffoldMessenger.of(context).showSnackBar(
      //   SnackBar(
      //     content: Text(e.toString()),
      //   ),
      // );
      ScaffoldMessenger.of(context)
        ..hideCurrentSnackBar()
        ..showSnackBar(errorSnackBar(e.toString()));
    }
  }

  // Future<void> _login() async {
  //   final prefs = await SharedPreferences.getInstance();
  //   try {
  //     final response = await http.post(
  //       Uri.parse('http://localhost:3000/api/auth/login'),
  //       body: {
  //         'username': _usernameController.text,
  //         'password': _passwordController.text,
  //       },
  //       headers: {
  //         'Content-Type': 'application/x-www-form-urlencoded',
  //       },
  //     );

  //     print(response.body);

  //     if (response.statusCode == 200) {
  //       final token = json.decode(response.body)['token'];
  //       print(token);
  //       // await _storage.write(key: 'token', value: token);
  //       await prefs.setString('token', token);
  //       Navigator.pushNamed(context, '/dashboard');
  //     } else {
  //       print(response.statusCode);
  //       ScaffoldMessenger.of(context).showSnackBar(
  //         SnackBar(
  //           content: Text('Error ${response.statusCode}'),
  //         ),
  //       );
  //     }
  //   } catch (e) {
  //     ScaffoldMessenger.of(context).showSnackBar(
  //       SnackBar(
  //         content: Text('Error ${e.toString()}'),
  //       ),
  //     );
  //   }
  // }

  @override
  void initState() {
    super.initState();
    _passwordVisible = false;
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          TextFormField(
            controller: _usernameController,
            decoration: InputDecoration(
              labelText: 'Username',
              hintText: 'Enter your username',
              border: OutlineInputBorder(),
            ),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter your username';
              }
              return null;
            },
          ),
          SizedBox(height: 10),
          TextFormField(
            controller: _passwordController,
            decoration: InputDecoration(
              labelText: 'Password',
              hintText: 'Enter your password',
              border: OutlineInputBorder(),
              suffixIcon: IconButton(
                icon: Icon(
                  _passwordVisible ? Icons.visibility : Icons.visibility_off,
                ),
                onPressed: () {
                  setState(() {
                    _passwordVisible = !_passwordVisible;
                  });
                },
              ),
            ),
            obscureText: _passwordVisible,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter your password';
              }
              return null;
            },
          ),
          const SizedBox(height: 10),
          ElevatedButton(
            onPressed: () {
              // Navigator.pushNamed(context, '/home');
              // if (_formKey.currentState!.validate()) {
              //   _login();
              // }
              _handleLogin();
            },
            child: Text('Login'),
          ),
        ],
      ),
    );
  }
}
