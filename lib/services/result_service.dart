import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'package:school_management/models/result.dart';
import 'package:school_management/models/subject.dart';
import 'package:school_management/providers/data_provider.dart';
import 'package:school_management/utils/error_handler.dart';
import 'package:school_management/utils/token_validator.dart';
import 'package:school_management/widgets/shared/toast.dart';

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
      showErrorToast(context, 'Error $e');
      // ScaffoldMessenger.of(context).showSnackBar(
      //   SnackBar(
      //     content: Text('Error $e'),
      //   ),
      // );
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
        Uri.parse('http://localhost:3000/api/subject/subjects/$classId'),
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
      showErrorToast(context, 'Error $e');

      // ScaffoldMessenger.of(context).showSnackBar(
      //   SnackBar(
      //     content: Text('Error $e'),
      //   ),
      // );
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
          Provider.of<DataNotifier>(context, listen: false).refresh();
          Navigator.pop(context);
          // Navigator.pushReplacementNamed(context, '/dashboard');
          showSuccessToast(context, 'Result Added Successfully');
          // ScaffoldMessenger.of(context)
          //   ..hideCurrentSnackBar()
          //   ..showSnackBar(successSnackBar('Result Added Successfully'));
        },
      );
    } catch (e) {
      showErrorToast(context, 'Error $e');
      // ScaffoldMessenger.of(context)
      //   ..hideCurrentSnackBar()
      //   ..showSnackBar(errorSnackBar('Error $e'));
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
            Provider.of<DataNotifier>(context, listen: false).refresh();
            Navigator.pop(context);
            // Navigator.pushReplacementNamed(context, '/dashboard');
            showSuccessToast(context, 'Result Updated Successfully');
            // ScaffoldMessenger.of(context)
            //   ..hideCurrentSnackBar()
            //   ..showSnackBar(successSnackBar('Result Updated Successfully'));
          });
    } catch (e) {
      showErrorToast(context, 'Error $e');
      // ScaffoldMessenger.of(context)
      //   ..hideCurrentSnackBar()
      //   ..showSnackBar(errorSnackBar('Error $e'));
    }
  }

  Future<Results> getResultStudent({
    required BuildContext context,
    required String icNo,
  }) async {
    try {
      http.Response res = await http.get(
        Uri.parse('http://localhost:3000/result/$icNo'),
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
      Navigator.pop(context);
      showErrorToast(context, 'Error $e');
      // ScaffoldMessenger.of(context).showSnackBar(
      //   SnackBar(
      //     content: Text('Error $e'),
      //   ),
      // );
    }
    return Results.fromJson({});
  }
}
