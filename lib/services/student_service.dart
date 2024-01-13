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
import 'package:school_management/widgets/shared/toast.dart';

class StudentService {
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
          'Authorization': 'Bearer $token'
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

      return student.students!;
    } catch (e) {
      showErrorToast(context, 'Error $e');

      // ScaffoldMessenger.of(context)
      //   ..hideCurrentSnackBar()
      //   ..showSnackBar(errorSnackBar('Error $e'));
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
        Uri.parse('http://localhost:3000/api/user/student/wo/$schoolId'),
        headers: {
          'Content-Type': 'application/x-www-form-urlencoded',
          'Authorization': //TODO: Change this to token
              'Bearer $token'
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

      return student.students!;
    } catch (e) {
      showErrorToast(context, 'Error $e');
      // ScaffoldMessenger.of(context)
      //   ..hideCurrentSnackBar()
      //   ..showSnackBar(errorSnackBar('Error $e'));
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
          'Authorization': 'Bearer $token'
        },
      );
      late final Student student;
      httpErrorHandler(
        res: res,
        context: context,
        onSuccess: () {
          student = Student.fromJson(json.decode(res.body));
        },
      );
      return student.totalPages!;
    } catch (e) {
      showErrorToast(context, 'Error $e');
      // ScaffoldMessenger.of(context)
      //   ..hideCurrentSnackBar()
      //   ..showSnackBar(errorSnackBar('Error $e'));
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
          'Authorization': 'Bearer $token'
        },
      );

      httpErrorHandler(
        res: res,
        context: context,
        onSuccess: () {
          Navigator.pushReplacementNamed(context, '/dashboard');
          showSuccessToast(context, 'Student Added Successfully');
          // ScaffoldMessenger.of(context)
          //   ..hideCurrentSnackBar()
          //   ..showSnackBar(successSnackBar('Student Added Successfully'));
        },
      );
    } catch (e) {
      showErrorToast(context, 'Error $e');
      // ScaffoldMessenger.of(context)
      //   ..hideCurrentSnackBar()
      //   ..showSnackBar(errorSnackBar('Error $e'));
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
          'Authorization': 'Bearer $token'
        },
      );

      late final Members student;

      httpErrorHandler(
        res: res,
        context: context,
        onSuccess: () {
          student = Members.fromJson(json.decode(res.body));
        },
      );
      return student;
    } catch (e) {
      showErrorToast(context, 'Error $e');
      // ScaffoldMessenger.of(context)
      //   ..hideCurrentSnackBar()
      //   ..showSnackBar(errorSnackBar('Error $e'));
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
        Uri.parse('http://localhost:3000/api/user/$userId'),
        headers: {
          'Content-Type': 'application/x-www-form-urlencoded',
          'Authorization': 'Bearer $token'
        },
      );
      httpErrorHandler(
        res: res,
        context: context,
        onSuccess: () {
          Navigator.pushNamed(context, '/dashboard');
          showSuccessToast(context, 'Student Deleted Successfully');
          // ScaffoldMessenger.of(context)
          //   ..hideCurrentSnackBar()
          //   ..showSnackBar(successSnackBar('Student Deleted Successfully'));
        },
      );
    } catch (e) {
      showErrorToast(context, 'Error $e');
      // ScaffoldMessenger.of(context)
      //   ..hideCurrentSnackBar()
      //   ..showSnackBar(errorSnackBar('Error $e'));
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
          'Authorization': 'Bearer $token'
        },
      );
      // return res.body;
      httpErrorHandler(
        res: res,
        context: context,
        onSuccess: () {
          Navigator.pushReplacementNamed(context, '/dashboard');
          showSuccessToast(context, 'User Updated Successfully');
          // ScaffoldMessenger.of(context)
          //   ..hideCurrentSnackBar()
          //   ..showSnackBar(successSnackBar('Student Update Successfully'));
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
          ),
        ),
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
          },
        );
      }).toList();
}
