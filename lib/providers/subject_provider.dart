import 'package:flutter/material.dart';

class SubjectProvider extends ChangeNotifier {
  String? subjectName;
  String? subjectGrade;
  String? subjectTerm;
  int? gradeId;

  void setGradeId(int id) {
    gradeId = id;
    notifyListeners();
  }

  void setSubjectTerm(String name) {
    subjectTerm = name;
    notifyListeners();
  }

  void setSubjectGrade(String name) {
    subjectGrade = name;
    notifyListeners();
  }

  void setSubjectName(String name) {
    subjectName = name;
    notifyListeners();
  }

  String? get getSubjectName => subjectName;
  String? get getSubjectGrade => subjectGrade;
  String? get getSubjectTerm => subjectTerm;
  int? get getGradeId => gradeId;
}
