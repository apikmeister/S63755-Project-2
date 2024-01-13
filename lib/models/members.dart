class Members {
  List<Member>? member;

  Members({this.member});

  Members.fromJson(Map<String, dynamic> json) {
    if (json['member'] != null) {
      member = <Member>[];
      json['member'].forEach((v) {
        member!.add(new Member.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.member != null) {
      data['member'] = this.member!.map((v) => v.toJson()).toList();
    }
    return data;
  }

  @override
  String toString() {
    return 'Members{member: $member}';
  }
}

class Member {
  String? userId;
  String? schoolId;
  String? firstName;
  String? lastName;
  String? gender;
  String? address;
  String? role;
  String? grade;
  String? hireDate;
  String? updatedAt;
  String? icNo;

  Member({
    this.userId,
    this.schoolId,
    this.firstName,
    this.lastName,
    this.gender,
    this.address,
    this.role,
    this.grade,
    this.hireDate,
    this.updatedAt,
    this.icNo,
  });

  Member.fromJson(Map<String, dynamic> json) {
    userId = json['user_id'];
    schoolId = json['school_id'];
    firstName = json['first_name'];
    lastName = json['last_name'];
    gender = json['gender'];
    address = json['address'];
    role = json['role'];
    grade = json['grade'];
    hireDate = json['hire_date'];
    updatedAt = json['updated_at'];
    icNo = json['ic_no'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['user_id'] = this.userId;
    data['school_id'] = this.schoolId;
    data['first_name'] = this.firstName;
    data['last_name'] = this.lastName;
    data['gender'] = this.gender;
    data['address'] = this.address;
    data['role'] = this.role;
    data['grade'] = this.grade;
    data['hire_date'] = this.hireDate;
    data['updated_at'] = this.updatedAt;
    data['ic_no'] = this.icNo;
    return data;
  }

  @override
  String toString() {
    return 'Member{userId: $userId, schoolId: $schoolId, firstName: $firstName, lastName: $lastName, gender: $gender, address: $address, role: $role, grade: $grade, hireDate: $hireDate, updatedAt: $updatedAt, icNo: $icNo}';
  }
}
