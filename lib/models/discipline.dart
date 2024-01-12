class DisciplineRecords {
  Student? student;
  List<Discipline>? discipline;

  DisciplineRecords({this.student, this.discipline});

  DisciplineRecords.fromJson(Map<String, dynamic> json) {
    student =
        json['student'] != null ? new Student.fromJson(json['student']) : null;
    if (json['discipline'] != null) {
      discipline = <Discipline>[];
      json['discipline'].forEach((v) {
        discipline!.add(new Discipline.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.student != null) {
      data['student'] = this.student!.toJson();
    }
    if (this.discipline != null) {
      data['discipline'] = this.discipline!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Student {
  String? firstName;
  String? lastName;
  String? gender;
  String? className;

  Student({this.firstName, this.lastName, this.gender, this.className});

  Student.fromJson(Map<String, dynamic> json) {
    firstName = json['first_name'];
    lastName = json['last_name'];
    gender = json['gender'];
    className = json['class_name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['first_name'] = this.firstName;
    data['last_name'] = this.lastName;
    data['gender'] = this.gender;
    data['class_name'] = this.className;
    return data;
  }
}

class Discipline {
  int? recordID;
  String? studentId;
  String? description;
  String? incidentDate;
  String? score;

  Discipline({this.description, this.incidentDate, this.score});

  Discipline.fromJson(Map<String, dynamic> json) {
    recordID = json['recordID'];
    studentId = json['student_id'];
    incidentDate = json['incident_date'];
    description = json['description'];
    score = json['score'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['recordID'] = this.recordID;
    data['student_id'] = this.studentId;
    data['incident_date'] = this.incidentDate;
    data['description'] = this.description;
    data['score'] = this.score;
    return data;
  }
}
