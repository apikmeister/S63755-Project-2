import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:pluto_grid/pluto_grid.dart';
import 'package:school_management/models/teacher.dart';
import 'package:school_management/utils/error_handler.dart';
import 'package:school_management/utils/token_validator.dart';

class TeacherService {
  Future<List<Teachers>> getAllTeacher({
    required BuildContext context,
    required String schoolId,
  }) async {
    try {
      String token = await getToken();
      http.Response res = await http.get(
        Uri.parse('http://localhost:3000/api/user/teacher/$schoolId'),
        headers: {
          'Content-Type': 'application/x-www-form-urlencoded',
          'Authorization': //TODO: Change this to token
              'Bearer eyJhbGciOiJIUzI1NiJ9.eyJpZCI6MSwiZXhwIjoxNzA1Mzk0NDQwfQ.1ZC3QrQrcWnOGfV7t-u_aKizoTY1L2NlOeijtsNIsEA'
        },
      );

      late final Teacher teacher;

      httpErrorHandler(
        res: res,
        context: context,
        onSuccess: () {
          teacher = Teacher.fromJson(json.decode(res.body));
        },
      );
      // return data;
      return teacher.teachers!;
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error $e'),
        ),
      );
    }
    return [];
  }

  Future<void> addTeacher({
    required BuildContext context,
    required String firstName,
    required String lastName,
    required String address,
    required String gender,
    required String className, //FIXME: maybe doesn't need this
    required String schoolId,
  }) async {
    try {
      String token = await getToken();
      http.Response res = await http.post(
        Uri.parse('http://localhost:3000/api/user/teacher/create/'),
        body: {
          'firstName': firstName,
          'lastName': lastName,
          'address': address,
          'gender': gender,
          'schoolId': schoolId,
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
              ..showSnackBar(successSnackBar('Teacher Added Successfully'));
          });
    } catch (e) {
      ScaffoldMessenger.of(context)
        ..hideCurrentSnackBar()
        ..showSnackBar(errorSnackBar('Error $e'));
    }
  }
}

// class TeacherDataSource extends DataTableSource {
//   final List<Teachers> teachers;
//   TeacherDataSource(this.teachers);

//   @override
//   DataRow getRow(int index) {
//     final teacher = teachers[index];
//     return DataRow.byIndex(
//       index: index,
//       cells: [
//         DataCell(
//           Text(teacher.userId!),
//         ),
//         DataCell(
//           Text(teacher.firstName!),
//         ),
//         DataCell(
//           Text(teacher.lastName!),
//         ),
//         DataCell(
//           Text(teacher.gender!),
//         ),
//       ],
//     );
//   }

//   @override
//   bool get isRowCountApproximate => false;

//   @override
//   int get rowCount => teachers.length;

//   @override
//   int get selectedRowCount => 0;
// }

class TeacherDataSource {
  final List<Teachers> teachers;

  TeacherDataSource(this.teachers);

  List<PlutoColumn> get columns => [
        PlutoColumn(
          title: 'User ID',
          field: 'userId',
          type: PlutoColumnType.text(),
        ),
        PlutoColumn(
          title: 'First Name',
          field: 'firstName',
          type: PlutoColumnType.text(),
        ),
        PlutoColumn(
          title: 'Last Name',
          field: 'lastName',
          type: PlutoColumnType.text(),
        ),
        PlutoColumn(
          title: 'Gender',
          field: 'gender',
          type: PlutoColumnType.text(),
        ),
        // Add more columns for other fields...
      ];

  List<PlutoRow> get rows => teachers.map((teacher) {
        return PlutoRow(
          cells: {
            'userId': PlutoCell(value: teacher.userId),
            'firstName': PlutoCell(value: teacher.firstName),
            'lastName': PlutoCell(value: teacher.lastName),
            'gender': PlutoCell(value: teacher.gender),
          },
        );
      }).toList();
}
