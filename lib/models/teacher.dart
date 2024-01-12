class Teacher {
  List<Teachers>? teachers;

  Teacher({this.teachers});

  Teacher.fromJson(Map<String, dynamic> json) {
    if (json['teachers'] != null) {
      teachers = <Teachers>[];
      json['teachers'].forEach((v) {
        teachers!.add(new Teachers.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.teachers != null) {
      data['teachers'] = this.teachers!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Teachers {
  Function? editUser;
  String? userId;
  String? firstName;
  String? lastName;
  String? gender;

  Teachers({
    this.editUser,
    this.userId,
    this.firstName,
    this.lastName,
    this.gender,
  });

  Teachers.fromJson(Map<String, dynamic> json) {
    editUser = json['editUser'];
    userId = json['user_id'];
    firstName = json['first_name'];
    lastName = json['last_name'];
    gender = json['gender'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['editUser'] = this.editUser;
    data['user_id'] = this.userId;
    data['first_name'] = this.firstName;
    data['last_name'] = this.lastName;
    data['gender'] = this.gender;
    return data;
  }
}
