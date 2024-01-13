import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:school_management/models/school.dart';
import 'package:school_management/utils/error_handler.dart';
import 'package:school_management/utils/token_validator.dart';
import 'package:school_management/widgets/shared/toast.dart';

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
          'Authorization': 'Bearer $token'
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
      showErrorToast(context, 'Error $e');
      // ScaffoldMessenger.of(context).showSnackBar(
      //   SnackBar(
      //     content: Text('Error $e'),
      //   ),
      // );
    }
    return School();
  }

  Future<List<ClassSchool>> getClass({
    required BuildContext context,
    required String schoolId,
  }) async {
    try {
      String token = await getToken();
      http.Response res = await http.get(
        Uri.parse('http://localhost:3000/api/subject/class/$schoolId'),
        headers: {
          'Content-Type': 'application/x-www-form-urlencoded',
          'Authorization': 'Bearer $token'
        },
      );
      late final List<ClassSchool> schoolClass;
      httpErrorHandler(
        res: res,
        context: context,
        onSuccess: () {
          // schoolClass = ClassSchool.fromJson(json.decode(res.body));
          schoolClass = (json.decode(res.body) as List)
              .map((item) => ClassSchool.fromJson(item))
              .toList();
          // schoolClass = json
          //     .decode(res.body)
          //     .map((json) => ClassSchool.fromJson(json))
          //     .toList();
        },
      );
      return schoolClass;
    } catch (e) {
      showErrorToast(context, 'Error $e');
      // ScaffoldMessenger.of(context).showSnackBar(
      //   SnackBar(
      //     content: Text('Error $e'),
      //   ),
      // );
    }
    return [];
  }
}
