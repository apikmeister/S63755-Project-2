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
  // final List<Student> students = List.generate(
  //   100,
  //   (index) => Student(id: index, name: 'Student $index'),
  // );

  ViewMemberScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('View Member Screen'),
        backgroundColor: Colors.deepPurple,
        elevation: 0,
        actions: [
          Builder(builder: (context) {
            return IconButton(
              onPressed: () {
                Scaffold.of(context).openEndDrawer();
                // Navigator.pushNamed(context, '/add_member');
              },
              icon: Icon(Icons.filter_alt_outlined),
            );
          }),
        ],
      ),
      body: StudentTable(),
      endDrawer: Drawer(
        child: ListView(
          children: [
            // DrawerHeader(
            //   child: Text('Drawer Header'),
            // ),
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
  // @override
  // Widget build(BuildContext context)  {
  //   final students = await StudentService().getAllStudent(
  //     context: context,
  //     schoolId: Provider.of<SchoolProvider>(context, listen: false).schoolId!,
  //   );
  //   final dataSource = StudentDataSource(students);
  //   return Scaffold(
  //     appBar: AppBar(
  //       title: Text('View Member Screen'),
  //       backgroundColor: Colors.deepPurple,
  //       elevation: 0,
  //     ),
  //     body: SingleChildScrollView(
  //       child: PaginatedDataTable(
  //         header: Text('Students'),
  //         rowsPerPage: 10,
  //         columns: [
  //           DataColumn(label: Text('Name')),
  //           DataColumn(label: Text('Age')),
  //         ],
  //         source: dataSource,
  //       ),
  //     ),
  //   );
  // }
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
              schoolId: 'SMKATAHAP', //TODO: Change this to schoolId
              page: 1,
              rowsPerPage: 10,
            ),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return CircularProgressIndicator();
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
              schoolId: 'SMKATAHAP', //TODO: Change this to schoolId
            ),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return CircularProgressIndicator();
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

  final dataSource;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: PlutoGrid(
            columns: dataSource.columns,
            rows: dataSource.rows,
            // createFooter: (stateManager) {
            //   return PlutoLazyPagination(
            //     initialPage: 1,
            //     initialFetch: true,
            //     // Decide whether sorting will be handled by the server.
            //     // If false, handle sorting on the client side.
            //     // Default is true.
            //     fetchWithSorting: true,
            //     // Decide whether filtering is handled by the server.
            //     // If false, handle filtering on the client side.
            //     // Default is true.
            //     fetchWithFiltering: true,
            //     // Determines the page size to move to the previous and next page buttons.
            //     // Default value is null. In this case,
            //     // it moves as many as the number of page buttons visible on the screen.
            //     pageSizeToMove: null,
            //     fetch: , //Dont understand this
            //     stateManager: stateManager,
            //     );
            // },
            // pagination: PlutoLazyPagination(
            //   pageSize: 10,
            //   loadMore: (PlutoGridLoadMoreEvent event) async {
            //     // Load more data here
            //   },
            // ),
          ),
        ),
      ],
    );
  }
}
