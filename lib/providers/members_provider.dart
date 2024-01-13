import 'package:flutter/material.dart';

class MembersProvider extends ChangeNotifier {
  String? memberType;
  String? processType;
  String? memberId;
  String? disciplineId;
  String? classId;
  String? protected;

  void setProtected(String id) {
    protected = id;
    notifyListeners();
  }

  void setClassId(String id) {
    classId = id;
    notifyListeners();
  }

  void setDisciplineId(String id) {
    disciplineId = id;
    notifyListeners();
  }

  void setMemberId(String id) {
    memberId = id;
    notifyListeners();
  }

  void setProcessType(String type) {
    processType = type;
    notifyListeners();
  }

  void setMemberType(String type) {
    memberType = type;
    notifyListeners();
  }

  String? get getMemberType => memberType;
  String? get getProcessType => processType;
  String? get getMemberId => memberId;

  String? get getDisciplineId => disciplineId;
  String? get getClassId => classId;
  String? get getProtected => protected;
}
