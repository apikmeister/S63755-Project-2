import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'package:school_management/models/discipline.dart';
import 'package:school_management/providers/data_provider.dart';
import 'package:school_management/utils/error_handler.dart';
import 'package:school_management/utils/token_validator.dart';

class DisciplineService {
  Future<DisciplineRecords> getDisciplineRecords({
    required BuildContext context,
    required String userId,
  }) async {
    try {
      String token = await getToken();
      http.Response res = await http.get(
        // Uri.parse('http://localhost:3000/api/user/student/$schoolId'),
        Uri.parse('http://localhost:3000/api/discipline/$userId'),
        headers: {
          'Content-Type': 'application/x-www-form-urlencoded',
          'Authorization': //TODO: Change this to token
              'Bearer eyJhbGciOiJIUzI1NiJ9.eyJpZCI6MSwiZXhwIjoxNzA1Mzk0NDQwfQ.1ZC3QrQrcWnOGfV7t-u_aKizoTY1L2NlOeijtsNIsEA'
        },
      );
      late final DisciplineRecords records;
      httpErrorHandler(
        res: res,
        context: context,
        onSuccess: () {
          records = DisciplineRecords.fromJson(json.decode(res.body));
        },
      );

      // return data;
      return records;
    } catch (e) {
      // ScaffoldMessenger.of(context).showSnackBar(
      //   SnackBar(
      //     content: Text('Error $e'),
      //   ),
      // );
      ScaffoldMessenger.of(context)
        ..hideCurrentSnackBar()
        ..showSnackBar(errorSnackBar('Error $e'));
    }
    return DisciplineRecords.fromJson({});
  }

  Future<void> addDisciplineRecords({
    required BuildContext context,
    required String userId,
    required String incidentDate,
    required String description,
    required String score,
  }) async {
    try {
      String token = await getToken();
      http.Response res = await http.post(
        Uri.parse('http://localhost:3000/api/discipline/$userId'),
        body: {
          'incidentDate': incidentDate.toString(),
          'description': description,
          'merit': score,
        },
        headers: {
          'Content-Type': 'application/x-www-form-urlencoded',
          'Authorization': //TODO: Change this to token
              'Bearer eyJhbGciOiJIUzI1NiJ9.eyJpZCI6MSwiZXhwIjoxNzA1Mzk0NDQwfQ.1ZC3QrQrcWnOGfV7t-u_aKizoTY1L2NlOeijtsNIsEA'
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
              ..showSnackBar(successSnackBar('Student Added Successfully'));
          });
    } catch (e) {
      ScaffoldMessenger.of(context)
        ..hideCurrentSnackBar()
        ..showSnackBar(errorSnackBar('Error $e'));
    }
  }

  Future<Discipline> getSingleRecord({
    required BuildContext context,
    required String recordId,
  }) async {
    try {
      String token = await getToken();
      http.Response res = await http.get(
        Uri.parse('http://localhost:3000/api/discipline/record/$recordId'),
        headers: {
          'Content-Type': 'application/x-www-form-urlencoded',
          'Authorization': //TODO: Change this to token
              'Bearer eyJhbGciOiJIUzI1NiJ9.eyJpZCI6MSwiZXhwIjoxNzA1Mzk0NDQwfQ.1ZC3QrQrcWnOGfV7t-u_aKizoTY1L2NlOeijtsNIsEA'
        },
      );
      // return res.body;
      late final Discipline record;
      httpErrorHandler(
          res: res,
          context: context,
          onSuccess: () {
            record = Discipline.fromJson(json.decode(res.body));
          });
      return record;
    } catch (e) {
      ScaffoldMessenger.of(context)
        ..hideCurrentSnackBar()
        ..showSnackBar(errorSnackBar('Error $e'));
    }
    return Discipline();
  }

  Future<void> updateDisciplineRecord({
    required BuildContext context,
    required String recordId,
    required String incidentDate,
    required String description,
    required String score,
  }) async {
    try {
      String token = await getToken();
      http.Response res = await http.patch(
        Uri.parse('http://localhost:3000/api/discipline/edit/$recordId'),
        body: {
          'incidentDate': incidentDate,
          'description': description,
          'merit': score,
        },
        headers: {
          'Content-Type': 'application/x-www-form-urlencoded',
          'Authorization': //TODO: Change this to token
              'Bearer eyJhbGciOiJIUzI1NiJ9.eyJpZCI6MSwiZXhwIjoxNzA1Mzk0NDQwfQ.1ZC3QrQrcWnOGfV7t-u_aKizoTY1L2NlOeijtsNIsEA'
        },
      );
      // return res.body;
      httpErrorHandler(
          res: res,
          context: context,
          onSuccess: () {
            // Navigator.pushReplacementNamed(context, '/dashboard');
            Provider.of<DataNotifier>(context, listen: false).refresh();
            Navigator.pop(context);
            ScaffoldMessenger.of(context)
              ..hideCurrentSnackBar()
              ..showSnackBar(successSnackBar('Record Edited Successfully'));
          });
    } catch (e) {
      ScaffoldMessenger.of(context)
        ..hideCurrentSnackBar()
        ..showSnackBar(errorSnackBar('Error $e'));
    }
  }
}
