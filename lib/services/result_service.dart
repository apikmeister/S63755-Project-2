import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:school_management/models/result.dart';
import 'package:school_management/models/subject.dart';
import 'package:school_management/utils/error_handler.dart';
import 'package:school_management/utils/token_validator.dart';

class ResultService {
  Future<Results> getResult({
    required BuildContext context,
    required String studentId,
  }) async {
    try {
      String token = await getToken();
      http.Response res = await http.get(
        Uri.parse('http://localhost:3000/api/result/$studentId'),
        headers: {
          'Content-Type': 'application/x-www-form-urlencoded',
          'Authorization': 'Bearer $token'
        },
      );

      late final Results result;

      httpErrorHandler(
        res: res,
        context: context,
        onSuccess: () {
          result = Results.fromJson(json.decode(res.body));
        },
      );
      return result;
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error $e'),
        ),
      );
    }
    return Results.fromJson({});
  }

  Future<SubjectList> getSubjects({
    required BuildContext context,
    required String classId,
  }) async {
    try {
      String token = await getToken();
      http.Response res = await http.get(
        Uri.parse('http://localhost:3000/api/subject/class/$classId'),
        headers: {
          'Content-Type': 'application/x-www-form-urlencoded',
          'Authorization': 'Bearer $token'
        },
      );

      late final SubjectList subjects;

      httpErrorHandler(
        res: res,
        context: context,
        onSuccess: () {
          subjects = SubjectList.fromJson(json.decode(res.body));
        },
      );
      return subjects;
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error $e'),
        ),
      );
    }
    return SubjectList.fromJson({});
  }

  Future<void> addResult({
    required BuildContext context,
    required String studentId,
    required String subjectId,
    required String gradeLevel,
    required String term,
  }) async {
    try {
      String token = await getToken();
      http.Response res = await http.post(
        Uri.parse('http://localhost:3000/api/result/'),
        body: {
          'studentID': studentId,
          'subjectID': subjectId,
          'gradeLevel': gradeLevel,
          'term': term,
        },
        headers: {
          'Content-Type': 'application/x-www-form-urlencoded',
          'Authorization': 'Bearer $token'
        },
      );
      httpErrorHandler(
        res: res,
        context: context,
        onSuccess: () {
          Navigator.pushReplacementNamed(context, '/dashboard');
          ScaffoldMessenger.of(context)
            ..hideCurrentSnackBar()
            ..showSnackBar(successSnackBar('Result Added Successfully'));
        },
      );
    } catch (e) {
      ScaffoldMessenger.of(context)
        ..hideCurrentSnackBar()
        ..showSnackBar(errorSnackBar('Error $e'));
    }
  }

  Future<void> updateResult({
    required BuildContext context,
    required String gradeId,
    required String gradeLevel,
  }) async {
    try {
      String token = await getToken();
      http.Response res = await http.put(
        Uri.parse('http://localhost:3000/api/result/$gradeId'),
        body: {
          'gradeLevel': gradeLevel,
        },
        headers: {
          'Content-Type': 'application/x-www-form-urlencoded',
          'Authorization': 'Bearer $token'
        },
      );
      // return res.body;
      httpErrorHandler(
          res: res,
          context: context,
          onSuccess: () {
            Navigator.pushReplacementNamed(context, '/dashboard');
            ScaffoldMessenger.of(context)
              ..hideCurrentSnackBar()
              ..showSnackBar(successSnackBar('Result Updated Successfully'));
          });
    } catch (e) {
      ScaffoldMessenger.of(context)
        ..hideCurrentSnackBar()
        ..showSnackBar(errorSnackBar('Error $e'));
    }
  }
}
