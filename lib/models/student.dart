class Student {
  List<Students>? students;
  int? totalPages;

  Student({this.students, this.totalPages});

  Student.fromJson(Map<String, dynamic> json) {
    if (json['students'] != null) {
      students = <Students>[];
      json['students'].forEach((v) {
        students!.add(new Students.fromJson(v));
      });
    }
    totalPages = json['totalPages'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.students != null) {
      data['students'] = this.students!.map((v) => v.toJson()).toList();
    }
    data['totalPages'] = this.totalPages;
    return data;
  }

  @override
  String toString() {
    return 'Student{students: $students, totalPages: $totalPages}';
  }
}

class Students {
  Function? editUser;
  String? userId;
  String? firstName;
  String? lastName;
  String? gender;
  String? className;
  Function? viewDisciplineRecord;
  String? viewResultUrl;

  Students({
    this.editUser,
    this.userId,
    this.firstName,
    this.lastName,
    this.gender,
    this.className,
    this.viewDisciplineRecord,
    this.viewResultUrl,
  });

  Students.fromJson(Map<String, dynamic> json) {
    editUser = json['editUser'];
    userId = json['user_id'];
    firstName = json['first_name'];
    lastName = json['last_name'];
    gender = json['gender'];
    className = json['class_name'];
    viewDisciplineRecord = json['viewDisciplineRecord'];
    viewResultUrl = json['viewResult'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['editUser'] = this.editUser;
    data['user_id'] = this.userId;
    data['first_name'] = this.firstName;
    data['last_name'] = this.lastName;
    data['gender'] = this.gender;
    data['class_name'] = this.className;
    data['viewDisciplineRecord'] = this.viewDisciplineRecord;
    data['viewResult'] = this.viewResultUrl;

    return data;
  }

  @override
  String toString() {
    return 'Students{editUser: $editUser, userId: $userId, firstName: $firstName, lastName: $lastName, gender: $gender, className: $className, viewDisciplineRecord: $viewDisciplineRecord, viewResultUrl: $viewResultUrl}';
  }
}
