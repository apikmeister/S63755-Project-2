class SchoolDetails {
  School? school;

  SchoolDetails({this.school});

  SchoolDetails.fromJson(Map<String, dynamic> json) {
    school =
        json['school'] != null ? new School.fromJson(json['school']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.school != null) {
      data['school'] = this.school!.toJson();
    }
    return data;
  }
}

class School {
  String? schoolId;
  String? schoolName;
  String? address;
  String? phone;

  School({this.schoolId, this.schoolName, this.address, this.phone});

  School.fromJson(Map<String, dynamic> json) {
    schoolId = json['school_id'];
    schoolName = json['school_name'];
    address = json['address'];
    phone = json['phone'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['school_id'] = this.schoolId;
    data['school_name'] = this.schoolName;
    data['address'] = this.address;
    data['phone'] = this.phone;
    return data;
  }
}
