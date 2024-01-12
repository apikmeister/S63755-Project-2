import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:school_management/models/school.dart';
import 'package:school_management/utils/error_handler.dart';
import 'package:school_management/utils/token_validator.dart';

class SchoolService {
  Future<School> getSchool({
    required BuildContext context,
    required String schoolId,
  }) async {
    try {
      String token = await getToken();
      http.Response res = await http.get(
        Uri.parse('http://localhost:3000/api/school/$schoolId'),
        headers: {
          'Content-Type': 'application/x-www-form-urlencoded',
          'Authorization': //TODO: Change this to token
              'Bearer eyJhbGciOiJIUzI1NiJ9.eyJpZCI6MSwiZXhwIjoxNzA1Mzk0NDQwfQ.1ZC3QrQrcWnOGfV7t-u_aKizoTY1L2NlOeijtsNIsEA'
        },
      );
      late final SchoolDetails school;
      httpErrorHandler(
        res: res,
        context: context,
        onSuccess: () {
          school = SchoolDetails.fromJson(json.decode(res.body));
        },
      );
      return school.school!;
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error $e'),
        ),
      );
    }
    return School();
  }
}
