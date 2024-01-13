import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:provider/provider.dart';
import 'package:school_management/models/school.dart';
import 'package:school_management/models/student.dart';
import 'package:school_management/models/teacher.dart';
import 'package:school_management/providers/members_provider.dart';
import 'package:school_management/providers/school_provider.dart';
import 'package:school_management/services/school_service.dart';
import 'package:school_management/services/student_service.dart';
import 'package:school_management/services/teacher_service.dart';
import 'package:school_management/utils/token_validator.dart';
import 'package:school_management/widgets/common/pluto_table.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DashboardScreen extends StatelessWidget {
  StudentService studentService = StudentService();
  TeacherService teacherService = TeacherService();
  SchoolService schoolService = SchoolService();

  DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    Future<int> getTotalStudents() async {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      List<Students> students =
          await studentService.getAllStudentWithoutPagination(
        context: context,
        schoolId: prefs.getString('schoolId')!,
        // page: 1,
        // rowsPerPage: 10,
      );
      return students.length;
    }

    Future<int> getTotalTeachers() async {
      SharedPreferences prefs = await SharedPreferences.getInstance();

      List<Teachers> teachers = await teacherService.getAllTeacher(
        context: context,
        // schoolId: Provider.of<SchoolProvider>(context, listen: false).schoolId!,
        schoolId: prefs.getString('schoolId')!,
      );
      return teachers.length;
    }

    Future<School> getSchool() async {
      SharedPreferences prefs = await SharedPreferences.getInstance();

      School school = await schoolService.getSchool(
          context: context,
          // schoolId: Provider.of<SchoolProvider>(context, listen: false).schoolId!,
          schoolId: prefs.getString('schoolId')!);
      return school;
    }

    return Scaffold(
      backgroundColor: const Color(0xFFA842F8),
      appBar: AppBar(
        title: const Text('Dashboard Screen'),
        // backgroundColor: Colors.deepPurple,
        elevation: 0,
        actions: [
          IconButton(
            onPressed: () async {
              SharedPreferences prefs = await SharedPreferences.getInstance();
              prefs.remove('token');
              prefs.remove('schoolId');
              prefs.setBool('isLoggedIn', false);

              Navigator.pushNamedAndRemoveUntil(
                  context, '/login', (route) => false);
            },
            icon: Icon(Icons.logout),
          )
        ],
        automaticallyImplyLeading: false,
      ),
      body: TokenValidationWrapper(
        child: Column(
          children: [
            const Padding(
              padding: EdgeInsets.all(8.0),
              child: Text(
                'Welcome back, user!',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(height: 50),
            Expanded(
              child: Container(
                width: double.infinity,
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(20),
                    topRight: Radius.circular(20),
                  ),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(15.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      FutureBuilder(
                        future: getSchool(),
                        builder: (context, snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return LoadingAnimationWidget.prograssiveDots(
                                color: Colors.purple,
                                size:
                                    20); // Show loading indicator while waiting for data
                          } else if (snapshot.hasError) {
                            return Text(
                                'Error: ${snapshot.error}'); // Show error message if there's an error
                          } else {
                            if (snapshot.data == null) {
                              return const Text(
                                'No data',
                                style: TextStyle(
                                  fontSize: 24,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black,
                                ),
                              );
                            } else {
                              return Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Container(
                                    width: 200, // Adjust this value as needed
                                    child: Text(
                                      snapshot.data!.schoolName ??
                                          'No school name',
                                      style: GoogleFonts.inter(
                                        fontSize: 18,
                                        fontWeight: FontWeight.w600,
                                        color: Colors.black,
                                      ),
                                      overflow: TextOverflow.ellipsis,
                                      maxLines: 4,
                                    ),
                                  ),
                                  Text(
                                    snapshot.data!.schoolId ?? 'No school ID',
                                    style: GoogleFonts.inter(
                                      fontSize: 18,
                                      fontWeight: FontWeight.w600,
                                      color: Colors.black,
                                    ),
                                  ),
                                ],
                              );
                            }
                          }
                        },
                      ),
                      const SizedBox(height: 10),
                      const Text(
                        'Current stats',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w500,
                          color: Colors.black,
                        ),
                      ),
                      const SizedBox(height: 10),
                      Row(
                        children: [
                          Expanded(
                            child: StatsWidget(
                              getTotalMembers: getTotalStudents,
                              cardTitle: 'Students',
                            ),
                          ),
                          Expanded(
                            child: StatsWidget(
                              getTotalMembers: getTotalTeachers,
                              cardTitle: 'Teachers',
                            ),
                          ),
                          // const SizedBox(width: 10),
                          // Expanded(
                          //   child: StatsWidget(),
                          // ),
                        ],
                      ),
                      const SizedBox(height: 10),
                      const Text(
                        'Manage your students',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w500,
                          color: Colors.black,
                        ),
                      ),
                      const SizedBox(height: 10),
                      OptionMenu(
                        // getTotalMembers: getTotalStudents,
                        cardTitle: 'View Students',
                      ),
                      OptionMenu(
                        cardTitle: 'Add Students',
                      ),
                      const SizedBox(height: 10),
                      const Text(
                        'Manage your teachers',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w500,
                          color: Colors.black,
                        ),
                      ),
                      const SizedBox(height: 10),
                      OptionMenu(
                        // getTotalMembers: getTotalTeachers,
                        cardTitle: 'View Teachers',
                      ),
                      OptionMenu(
                        cardTitle: 'Add Teachers',
                      ),
                    ],
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}

class OptionMenu extends StatelessWidget {
  late String cardTitle;
  late String memberType = cardTitle.split(' ')[1];
  late String cardType = cardTitle.split(' ')[0];

  OptionMenu({
    super.key,
    required this.cardTitle,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: () => {
        Provider.of<MembersProvider>(context, listen: false).setMemberType(
          memberType.substring(0, memberType.length - 1),
        ),
        if (cardType == 'View')
          {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => const LazyRowPagination()))
          }
        else
          {
            Provider.of<MembersProvider>(context, listen: false).setProcessType(
              'Add',
            ),
            Navigator.pushNamed(
              context,
              '/add-member',
            ),
          }
      },
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            children: [
              Text(
                cardTitle,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w500,
                  color: Colors.black,
                ),
              ),
              const Spacer(),
              const Icon(
                Icons.arrow_forward_ios,
                size: 18,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class StatsWidget extends StatelessWidget {
  late Future<int> Function() getTotalMembers;
  late String cardTitle;

  StatsWidget({
    super.key,
    required this.getTotalMembers,
    required this.cardTitle,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.symmetric(
          vertical: 10,
          horizontal: 15,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  'Total $cardTitle',
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const Icon(
                  Icons.person,
                  size: 18,
                ),
              ],
            ),
            const SizedBox(height: 10),
            FutureBuilder(
              future: getTotalMembers(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const CircularProgressIndicator(); // Show loading indicator while waiting for data
                } else if (snapshot.hasError) {
                  return Text(
                      'Error: ${snapshot.error}'); // Show error message if there's an error
                } else {
                  if (snapshot.data == null) {
                    return const Text(
                      'No data',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    );
                  } else {
                    return Text(
                      snapshot.data.toString(),
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    );
                  }
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
