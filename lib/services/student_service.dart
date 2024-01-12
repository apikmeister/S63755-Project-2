import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:pluto_grid/pluto_grid.dart';
import 'package:provider/provider.dart';
import 'package:school_management/models/members.dart';
import 'package:school_management/models/student.dart';
import 'package:school_management/providers/members_provider.dart';
import 'package:school_management/utils/error_handler.dart';
import 'package:school_management/utils/token_validator.dart';

class StudentService {
  // void getAllStudent({
  //   required BuildContext context,
  //   required String schoolId,
  // }) async {
  //   try {
  //     http.Response res = await http.post(
  //       Uri.parse('http://localhost:3000/api/auth/login/$schoolId'),
  //       headers: {
  //         'Content-Type': 'application/x-www-form-urlencoded',
  //       },
  //     );

  //     httpErrorHandler(
  //       res: res,
  //       context: context,
  //       onSuccess: () {
  //         Navigator.pushReplacementNamed(context, '/dashboard');
  //       },
  //     );
  //   } catch (e) {
  //     ScaffoldMessenger.of(context).showSnackBar(
  //       SnackBar(
  //         content: Text('Error $e'),
  //       ),
  //     );
  //   }
  // }
  Future<List<Students>> getAllStudent({
    required BuildContext context,
    required String schoolId,
    required int page,
    required int rowsPerPage,
  }) async {
    try {
      String token = await getToken();
      http.Response res = await http.get(
        Uri.parse(
            'http://localhost:3000/api/user/student/$schoolId?page=$page&rowsPerPage=$rowsPerPage'),
        headers: {
          'Content-Type': 'application/x-www-form-urlencoded',
          'Authorization': //TODO: Change this to token
              'Bearer eyJhbGciOiJIUzI1NiJ9.eyJpZCI6MSwiZXhwIjoxNzA1Mzk0NDQwfQ.1ZC3QrQrcWnOGfV7t-u_aKizoTY1L2NlOeijtsNIsEA'
        },
      );
      late final Student student;
      httpErrorHandler(
        res: res,
        context: context,
        onSuccess: () {
          student = Student.fromJson(json.decode(res.body));

          for (var s in student.students!) {
            s.viewResultUrl = 'http://localhost:3000/api/result/${s.userId}';
          }
        },
      );

      // return data;
      return student.students!;
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
    return [];
  }

  Future<List<Students>> getAllStudentWithoutPagination({
    required BuildContext context,
    required String schoolId,
  }) async {
    try {
      String token = await getToken();
      http.Response res = await http.get(
        // Uri.parse('http://localhost:3000/api/user/student/$schoolId'),
        Uri.parse('http://localhost:3000/api/user/student/wo/$schoolId'),
        headers: {
          'Content-Type': 'application/x-www-form-urlencoded',
          'Authorization': //TODO: Change this to token
              'Bearer eyJhbGciOiJIUzI1NiJ9.eyJpZCI6MSwiZXhwIjoxNzA1Mzk0NDQwfQ.1ZC3QrQrcWnOGfV7t-u_aKizoTY1L2NlOeijtsNIsEA'
        },
      );
      late final Student student;
      httpErrorHandler(
        res: res,
        context: context,
        onSuccess: () {
          student = Student.fromJson(json.decode(res.body));
          for (var s in student.students!) {
            s.editUser = () {
              Provider.of<MembersProvider>(context, listen: false)
                  .setProcessType('edit');
              Navigator.pushNamed(context, '/add-student');
            };
            s.viewResultUrl = 'http://localhost:3000/api/result/${s.userId}';
          }
        },
      );

      // return data;
      return student.students!;
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
    return [];
  }

  Future<int> getTotalStudentPages({
    required BuildContext context,
    required String schoolId,
  }) async {
    try {
      String token = await getToken();
      http.Response res = await http.get(
        Uri.parse('http://localhost:3000/api/user/student/$schoolId'),
        headers: {
          'Content-Type': 'application/x-www-form-urlencoded',
          'Authorization': //TODO: Change this to token
              'Bearer eyJhbGciOiJIUzI1NiJ9.eyJpZCI6MSwiZXhwIjoxNzA1Mzk0NDQwfQ.1ZC3QrQrcWnOGfV7t-u_aKizoTY1L2NlOeijtsNIsEA'
        },
      );
      late final Student student;
      httpErrorHandler(
        res: res,
        context: context,
        onSuccess: () {
          student = Student.fromJson(json.decode(res.body));
          // return student.totalPages!;
        },
      );
      return student.totalPages!;
    } catch (e) {
      ScaffoldMessenger.of(context)
        ..hideCurrentSnackBar()
        ..showSnackBar(errorSnackBar('Error $e'));
    }
    return 0;
  }

  Future<void> addStudent({
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
        // Uri.parse('http://localhost:3000/api/user/student/$schoolId'),
        Uri.parse('http://localhost:3000/api/user/student/create/'),
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
              ..showSnackBar(successSnackBar('Student Added Successfully'));
          });
    } catch (e) {
      ScaffoldMessenger.of(context)
        ..hideCurrentSnackBar()
        ..showSnackBar(errorSnackBar('Error $e'));
    }
  }

  Future<Members> getStudentInfo({
    required BuildContext context,
    required String userId,
  }) async {
    try {
      String token = await getToken();
      http.Response res = await http.get(
        Uri.parse('http://localhost:3000/api/user/$userId'),
        headers: {
          'Content-Type': 'application/x-www-form-urlencoded',
          'Authorization': //TODO: Change this to token
              'Bearer eyJhbGciOiJIUzI1NiJ9.eyJpZCI6MSwiZXhwIjoxNzA1Mzk0NDQwfQ.1ZC3QrQrcWnOGfV7t-u_aKizoTY1L2NlOeijtsNIsEA'
        },
      );

      late final Members student;

      httpErrorHandler(
          res: res,
          context: context,
          onSuccess: () {
            student = Members.fromJson(json.decode(res.body));
          });
      return student;
    } catch (e) {
      ScaffoldMessenger.of(context)
        ..hideCurrentSnackBar()
        ..showSnackBar(errorSnackBar('Error $e'));
    }
    return Members();
  }

  Future<void> deleteStudent({
    required BuildContext context,
    required String userId,
  }) async {
    try {
      String token = await getToken();
      http.Response res = await http.delete(
        // Uri.parse('http://localhost:3000/api/user/student/$schoolId'),
        Uri.parse('http://localhost:3000/api/user/$userId'),
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

  Future<void> updateStudent({
    required BuildContext context,
    required String userId,
    required String firstName,
    required String lastName,
    required String address,
    required String gender,
    required String className, //FIXME: maybe doesn't need this
    required String schoolId,
  }) async {
    try {
      String token = await getToken();
      http.Response res = await http.patch(
        Uri.parse('http://localhost:3000/api/user/$userId'),
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
              ..showSnackBar(successSnackBar('Student Update Successfully'));
          });
    } catch (e) {
      ScaffoldMessenger.of(context)
        ..hideCurrentSnackBar()
        ..showSnackBar(errorSnackBar('Error $e'));
    }
  }
}

// class StudentDataSource extends DataTableSource {
//   final List<Students> students;

//   StudentDataSource(this.students);

//   @override
//   DataRow getRow(int index) {
//     final student = students[index];
//     return DataRow.byIndex(
//       index: index,
//       cells: [
//         DataCell(Text(student.userId!)),
//         DataCell(Text(student.firstName!)),
//         DataCell(Text(student.lastName!)),
//         DataCell(Text(student.gender!)),
//         DataCell(Text(student.className!)),
//         // TODO: EDIT THIS TO VIEW STUDENTS RESULT
//         DataCell(TextButton(
//           onPressed: () {},
//           child: Text(student.viewResultUrl!),
//         )),
//         // DataCell(Text('Discipline Report'))
//       ],
//     );
//   }

//   @override
//   bool get isRowCountApproximate => false;

//   @override
//   int get rowCount => students.length;

//   @override
//   int get selectedRowCount => 0;
// }

class StudentDataSource {
  final List<Students> students;

  StudentDataSource(this.students);

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
        PlutoColumn(
          title: 'Class Name',
          field: 'className',
          type: PlutoColumnType.text(),
        ),
        PlutoColumn(
            title: 'View Result',
            field: 'viewResultUrl',
            type: PlutoColumnType.text(),
            renderer: (rendererContext) => ElevatedButton(
                  onPressed: () {},
                  child: Text(rendererContext.cell.value.toString()),
                )),
        // Add more columns for other fields...
      ];

  List<PlutoRow> get rows => students.map((student) {
        return PlutoRow(
          cells: {
            'userId': PlutoCell(value: student.userId),
            'firstName': PlutoCell(value: student.firstName),
            'lastName': PlutoCell(value: student.lastName),
            'gender': PlutoCell(value: student.gender),
            'className': PlutoCell(value: student.className),
            'viewResultUrl': PlutoCell(value: student.viewResultUrl),
            // Add more cells for other fields...
          },
        );
      }).toList();
}
