import 'package:flutter/material.dart';
import 'package:pluto_grid/pluto_grid.dart';
import 'package:provider/provider.dart';
import 'package:school_management/models/student.dart';
import 'package:school_management/models/teacher.dart';
import 'package:school_management/providers/members_provider.dart';
import 'package:school_management/providers/school_provider.dart';
import 'package:school_management/services/student_service.dart';
import 'package:school_management/services/teacher_service.dart';

class ViewMemberScreen extends StatelessWidget {
  const ViewMemberScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('View Member Screen'),
        backgroundColor: Colors.deepPurple,
        elevation: 0,
        actions: [
          Builder(builder: (context) {
            return IconButton(
              onPressed: () {
                Scaffold.of(context).openEndDrawer();
              },
              icon: const Icon(Icons.filter_alt_outlined),
            );
          }),
        ],
      ),
      body: const StudentTable(),
      endDrawer: Drawer(
        child: ListView(
          children: const [
            ListTile(
              title: Row(
                children: [],
              ),
            ),
            ListTile(
              title: Text('Item 2'),
            ),
          ],
        ),
      ),
    );
  }
}

class StudentTable extends StatefulWidget {
  const StudentTable({super.key});

  @override
  State<StudentTable> createState() => _StudentTableState();
}

class _StudentTableState extends State<StudentTable> {
  String? selectedClass;

  List<String> getClasses(List<Students> students) {
    return students.map((student) => student.className!).toSet().toList();
  }

  @override
  Widget build(BuildContext context) {
    return Provider.of<MembersProvider>(context, listen: false).memberType ==
            'Student'
        ? FutureBuilder<List<Students>>(
            future: StudentService().getAllStudent(
              context: context,
              schoolId:
                  Provider.of<SchoolProvider>(context, listen: false).schoolId!,
              page: 1,
              rowsPerPage: 10,
            ),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const CircularProgressIndicator();
              } else if (snapshot.hasError) {
                return Text('Error: ${snapshot.error}');
              } else {
                return TableMembers(
                  dataSource: StudentDataSource(snapshot.data!),
                );
              }
            },
          )
        : FutureBuilder<List<Teachers>>(
            future: TeacherService().getAllTeacher(
              context: context,
              schoolId:
                  Provider.of<SchoolProvider>(context, listen: false).schoolId!,
            ),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const CircularProgressIndicator();
              } else if (snapshot.hasError) {
                return Text('Error: ${snapshot.error}');
              } else {
                return TableMembers(
                  dataSource: TeacherDataSource(snapshot.data!),
                );
              }
            },
          );
  }
}

class TableMembers extends StatelessWidget {
  const TableMembers({
    super.key,
    this.dataSource,
  });

  final dynamic dataSource;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: PlutoGrid(
            columns: dataSource.columns,
            rows: dataSource.rows,
          ),
        ),
      ],
    );
  }
}
