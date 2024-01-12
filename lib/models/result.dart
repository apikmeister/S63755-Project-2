class Results {
  StudentResult? student;
  List<Result>? result;

  Results({this.student, this.result});

  Results.fromJson(Map<String, dynamic> json) {
    student = json['student'] != null
        ? new StudentResult.fromJson(json['student'])
        : null;
    if (json['result'] != null) {
      result = <Result>[];
      json['result'].forEach((v) {
        result!.add(new Result.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.student != null) {
      data['student'] = this.student!.toJson();
    }
    if (this.result != null) {
      data['result'] = this.result!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class StudentResult {
  String? firstName;
  String? lastName;
  String? className;

  StudentResult({this.firstName, this.lastName, this.className});

  StudentResult.fromJson(Map<String, dynamic> json) {
    firstName = json['first_name'];
    lastName = json['last_name'];
    className = json['class_name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['first_name'] = this.firstName;
    data['last_name'] = this.lastName;
    data['class_name'] = this.className;
    return data;
  }
}

class Result {
  String? subjectName;
  String? gradeLevel;
  String? term;

  Result({this.subjectName, this.gradeLevel, this.term});

  Result.fromJson(Map<String, dynamic> json) {
    subjectName = json['subject_name'];
    gradeLevel = json['grade_level'];
    term = json['term'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['subject_name'] = this.subjectName;
    data['grade_level'] = this.gradeLevel;
    data['term'] = this.term;
    return data;
  }
}

// class Results {
//   List<Result>? result;

//   Results({this.result});

//   Results.fromJson(Map<String, dynamic> json) {
//     if (json['result'] != null) {
//       result = <Result>[];
//       json['result'].forEach((v) {
//         result!.add(new Result.fromJson(v));
//       });
//     }
//   }

//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = new Map<String, dynamic>();
//     if (this.result != null) {
//       data['result'] = this.result!.map((v) => v.toJson()).toList();
//     }
//     return data;
//   }
// }

// class Result {
//   String? firstName;
//   String? lastName;
//   String? className;
//   String? subjectName;
//   String? gradeLevel;
//   String? term;

//   Result(
//       {this.firstName,
//       this.lastName,
//       this.className,
//       this.subjectName,
//       this.gradeLevel,
//       this.term});

//   Result.fromJson(Map<String, dynamic> json) {
//     firstName = json['first_name'];
//     lastName = json['last_name'];
//     className = json['class_name'];
//     subjectName = json['subject_name'];
//     gradeLevel = json['grade_level'];
//     term = json['term'];
//   }

//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = new Map<String, dynamic>();
//     data['first_name'] = this.firstName;
//     data['last_name'] = this.lastName;
//     data['class_name'] = this.className;
//     data['subject_name'] = this.subjectName;
//     data['grade_level'] = this.gradeLevel;
//     data['term'] = this.term;
//     return data;
//   }
// }