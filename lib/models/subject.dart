class SubjectList {
  List<Subject>? subject;

  SubjectList({this.subject});

  SubjectList.fromJson(Map<String, dynamic> json) {
    if (json['subject'] != null) {
      subject = <Subject>[];
      json['subject'].forEach((v) {
        subject!.add(new Subject.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.subject != null) {
      data['subject'] = this.subject!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Subject {
  int? id;
  int? classID;
  String? subjectID;

  Subject({this.id, this.classID, this.subjectID});

  Subject.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    classID = json['classID'];
    subjectID = json['subjectID'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['classID'] = this.classID;
    data['subjectID'] = this.subjectID;
    return data;
  }
}
