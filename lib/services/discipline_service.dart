import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'package:school_management/models/discipline.dart';
import 'package:school_management/providers/data_provider.dart';
import 'package:school_management/utils/error_handler.dart';
import 'package:school_management/utils/token_validator.dart';
import 'package:school_management/widgets/shared/toast.dart';

class DisciplineService {
  Future<DisciplineRecords> getDisciplineRecords({
    required BuildContext context,
    required String userId,
  }) async {
    try {
      String token = await getToken();
      http.Response res = await http.get(
        Uri.parse('http://localhost:3000/api/discipline/$userId'),
        headers: {
          'Content-Type': 'application/x-www-form-urlencoded',
          'Authorization': 'Bearer $token'
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

      return records;
    } catch (e) {
      showErrorToast(context, 'Error $e');
      // ScaffoldMessenger.of(context)
      //   ..hideCurrentSnackBar()
      //   ..showSnackBar(errorSnackBar('Error $e'));
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
          'Authorization': 'Bearer $token'
        },
      );
      httpErrorHandler(
          res: res,
          context: context,
          onSuccess: () {
            Navigator.pushReplacementNamed(context, '/dashboard');
            showSuccessToast(context, 'Discipline Recorded Successfully');
            // ScaffoldMessenger.of(context)
            //   ..hideCurrentSnackBar()
            //   ..showSnackBar(
            //       successSnackBar('Discipline Recorded Successfully'));
          });
    } catch (e) {
      showErrorToast(context, 'Error $e');
      // ScaffoldMessenger.of(context)
      //   ..hideCurrentSnackBar()
      //   ..showSnackBar(errorSnackBar('Error $e'));
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
          'Authorization': 'Bearer $token'
        },
      );

      late final Discipline record;
      httpErrorHandler(
          res: res,
          context: context,
          onSuccess: () {
            record = Discipline.fromJson(json.decode(res.body));
          });
      return record;
    } catch (e) {
      showErrorToast(context, 'Error $e');
      // ScaffoldMessenger.of(context)
      //   ..hideCurrentSnackBar()
      //   ..showSnackBar(errorSnackBar('Error $e'));
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
          'Authorization': 'Bearer $token'
        },
      );
      httpErrorHandler(
        res: res,
        context: context,
        onSuccess: () {
          Provider.of<DataNotifier>(context, listen: false).refresh();
          Navigator.pop(context);
          showSuccessToast(context, 'Record Edited Successfully');
          // ScaffoldMessenger.of(context)
          //   ..hideCurrentSnackBar()
          //   ..showSnackBar(successSnackBar('Record Edited Successfully'));
        },
      );
    } catch (e) {
      showErrorToast(context, 'Error $e');

      // ScaffoldMessenger.of(context)
      //   ..hideCurrentSnackBar()
      //   ..showSnackBar(errorSnackBar('Error $e'));
    }
  }
}
