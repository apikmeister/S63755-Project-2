import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:school_management/models/school.dart';
import 'package:school_management/models/student.dart';
import 'package:school_management/models/teacher.dart';
import 'package:school_management/providers/members_provider.dart';
import 'package:school_management/services/school_service.dart';
import 'package:school_management/services/student_service.dart';
import 'package:school_management/services/teacher_service.dart';
import 'package:school_management/utils/token_validator.dart';

class DashboardScreen extends StatelessWidget {
  StudentService studentService = StudentService();
  TeacherService teacherService = TeacherService();
  SchoolService schoolService = SchoolService();

  DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    Future<int> getTotalStudents() async {
      List<Students> students = await studentService.getAllStudent(
        context: context,
        schoolId: 'SCH001', //TODO: Change this to schoolId
      );
      return students.length;
    }

    Future<int> getTotalTeachers() async {
      List<Teachers> teachers = await teacherService.getAllTeacher(
        context: context,
        schoolId: 'SCH001', //TODO: Change this to schoolId
      );
      return teachers.length;
    }

    Future<School> getSchool() async {
      School school = await schoolService.getSchool(
        context: context,
        schoolId: 'SCH001', //TODO: Change this to schoolId
      );
      return school;
    }

    return Scaffold(
      backgroundColor: Color(0xFFA842F8),
      appBar: AppBar(
        title: Text('Dashboard Screen'),
        // backgroundColor: Colors.deepPurple,
        elevation: 0,
      ),
      body:
          // TokenValidationWrapper(
          //   child: //TODO: uncomment this
          Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
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
              decoration: BoxDecoration(
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
                        if (snapshot.hasData) {
                          return Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                snapshot.data!.schoolName!,
                                style: GoogleFonts.inter(
                                  fontSize: 21,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.black,
                                ),
                              ),
                              // SizedBox(width: 10),
                              Text(
                                snapshot.data!.schoolId!,
                                style: GoogleFonts.inter(
                                  fontSize: 21,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.black,
                                ),
                              ),
                            ],
                          );
                        } else {
                          return Text(
                            'School Name',
                            style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                            ),
                          );
                        }
                      },
                    ),
                    const SizedBox(height: 10),
                    Text(
                      'Current stats',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w500,
                        color: Colors.black,
                      ),
                    ),
                    SizedBox(height: 10),
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
                    Text(
                      'Manage your students',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w500,
                        color: Colors.black,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Card(
                      child: Text(
                        'View students',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w500,
                          color: Colors.black,
                        ),
                      ),
                    ),
                    Card(
                      child: Text(
                        'Add students',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w500,
                          color: Colors.black,
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      'Manage your teachers',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w500,
                        color: Colors.black,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Card(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          children: [
                            Text(
                              'View teachers',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w500,
                                color: Colors.black,
                              ),
                            ),
                            Spacer(),
                            Icon(
                              Icons.arrow_forward_ios,
                              size: 18,
                            ),
                          ],
                        ),
                      ),
                    ),
                    Card(
                      child: Text(
                        'Add teachers',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w500,
                          color: Colors.black,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          )
        ],
      ),
      // ),
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
    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: () => {
        Provider.of<MembersProvider>(context, listen: false).setMemberType(
          cardTitle.substring(0, cardTitle.length - 1),
        ),
        Navigator.pushNamed(
          context,
          '/view-member',
        ),
      },
      child: Card(
        // width: 150,
        // decoration: BoxDecoration(
        //   color: Colors.white,
        //   borderRadius: BorderRadius.circular(10),
        // ),
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
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Icon(
                    Icons.person,
                    size: 18,
                  ),
                ],
              ),
              const SizedBox(height: 10),
              FutureBuilder(
                future: getTotalMembers(),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    return Text(
                      snapshot.data.toString(),
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    );
                  } else {
                    return Text(
                      '0',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    );
                  }
                },
                // child: Text(
                //   getTotalStudents(),
                //   style: TextStyle(
                //     fontSize: 24,
                //     fontWeight: FontWeight.bold,
                //   ),
                // ),
              ),
              // Text(
              //   '+20 Since last month',
              //   style: TextStyle(
              //     fontSize: 12,
              //     // fontWeight: FontWeight.bold,
              //   ),
              // )
            ],
          ),
        ),
      ),
    );
  }
}
