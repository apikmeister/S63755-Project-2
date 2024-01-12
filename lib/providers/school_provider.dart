import 'package:flutter/material.dart';

class SchoolProvider extends ChangeNotifier {
  String? schoolId;

  void setSchoolId(String id) {
    schoolId = id;
    notifyListeners();
  }

  String? get getSchoolId => schoolId;
}
