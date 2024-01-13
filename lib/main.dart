import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:school_management/providers/auth_provider.dart';
import 'package:school_management/providers/data_provider.dart';
import 'package:school_management/providers/members_provider.dart';
import 'package:school_management/providers/school_provider.dart';
import 'package:school_management/providers/subject_provider.dart';
import 'package:school_management/screen/add_discipline_screen.dart';
import 'package:school_management/screen/add_student_screen.dart';
import 'package:school_management/screen/dashboard_screen.dart';
import 'package:school_management/screen/edit_result_screen.dart';
import 'package:school_management/screen/login_screen.dart';
import 'package:school_management/screen/onboarding_screen.dart';
import 'package:school_management/screen/request_result.dart';
import 'package:school_management/screen/view_discipline_screen.dart';
import 'package:school_management/screen/view_member_screen.dart';
import 'package:school_management/screen/view_result_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  SharedPreferences prefs = await SharedPreferences.getInstance();
  bool? isFirstTime = prefs.getBool('first_time');
  bool? isLoggedIn = prefs.getBool('isLoggedIn');

  String initialRoute;
  if (isFirstTime == null || isFirstTime) {
    initialRoute = '/onboarding';
  } else if (isLoggedIn == true) {
    initialRoute = '/dashboard';
  } else {
    initialRoute = '/login';
  }
  // String initialRoute =
  //     isFirstTime == null || isFirstTime ? '/onboarding' : '/login';
  runApp(
    SchoolManagementApp(initialRoute: initialRoute),
  );
}

class SchoolManagementApp extends StatelessWidget {
  const SchoolManagementApp({
    super.key,
    required this.initialRoute,
  });

  final String initialRoute;

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<AuthProvider>(
          create: (context) => AuthProvider(),
        ),
        ChangeNotifierProvider<MembersProvider>(
          create: (context) => MembersProvider(),
        ),
        ChangeNotifierProvider<SchoolProvider>(
          create: (context) => SchoolProvider(),
        ),
        ChangeNotifierProvider<DataNotifier>(
          create: (context) => DataNotifier(),
        ),
        ChangeNotifierProvider<SubjectProvider>(
          create: (context) => SubjectProvider(),
        ),
      ],
      child: MaterialApp(
        theme: ThemeData.light().copyWith(
          textTheme: GoogleFonts.interTextTheme(
            Theme.of(context).textTheme,
          ),
          appBarTheme: AppBarTheme(
            color: Colors.deepPurple,
            foregroundColor: Colors.black,
            elevation: 0,
            iconTheme: const IconThemeData(
              color: Colors.black,
            ),
            titleTextStyle: GoogleFonts.inter(
              color: Colors.white,
              fontSize: 24,
              fontWeight: FontWeight.w600,
            ),
          ),
          textSelectionTheme: TextSelectionThemeData(
            cursorColor: Colors.deepPurple,
            selectionColor: Colors.deepPurple.withOpacity(0.4),
            selectionHandleColor: Colors.deepPurple,
          ),
          inputDecorationTheme: const InputDecorationTheme(
            filled: true,
            fillColor: Color(0xFFF5F5F5),
            hintStyle: TextStyle(
              color: Color(0xFFB8B5C3),
            ),
            border: OutlineInputBorder(
              borderSide: BorderSide.none,
              borderRadius: BorderRadius.all(Radius.circular(12)),
            ),
            enabledBorder: OutlineInputBorder(
              borderSide: BorderSide.none,
              borderRadius: BorderRadius.all(Radius.circular(12)),
            ),
            focusedBorder: OutlineInputBorder(
              borderSide: BorderSide.none,
              borderRadius: BorderRadius.all(Radius.circular(12)),
            ),
          ),
          elevatedButtonTheme: ElevatedButtonThemeData(
            style: ElevatedButton.styleFrom(
              // primary: primaryColor,
              primary: Colors.deepPurple,
              minimumSize: const Size(double.infinity, 56),
              shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(12)),
              ),
            ),
          ),
          outlinedButtonTheme: OutlinedButtonThemeData(
            style: OutlinedButton.styleFrom(
              primary: Colors.black,
              minimumSize: const Size(double.infinity, 56),
              shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(12)),
              ),
            ),
          ),
        ),
        routes: {
          '/login': (context) => const LoginScreen(),
          '/dashboard': (context) => DashboardScreen(),
          '/onboarding': (context) => const OnboardingScreen(),
          '/view-member': (context) => const ViewMemberScreen(),
          '/add-member': (context) => const AddStudentScreen(),
          '/view-discipline': (context) => ViewDisciplineScreen(),
          '/add-discipline': (context) => const AddDisciplineScreen(),
          '/view-result': (context) => const ViewResultScreen(),
          '/edit-result': (context) => EditResultScreen(),
          '/check-result': (context) => RequestResultScreen(),
        },
        initialRoute: initialRoute,
        home: const LoginScreen(),
      ),
    );
  }
}
