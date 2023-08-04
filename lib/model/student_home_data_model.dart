class StudentHomeDataModel {
  StudentHomeDataModel({
    required this.classes,
    required this.subjects,
    required this.testimonials,
    required this.apphomesliders,
    required this.city,
    required this.fee,
    required this.StudentEnq,
    required this.Message,
  });
  late final List<Classes> classes;
  late final List<Subjects> subjects;
  late final List<dynamic> testimonials;
  late final List<dynamic> apphomesliders;
  late final List<dynamic> city;
  late final String fee;
  late final String StudentEnq;
  late final String Message;

  StudentHomeDataModel.fromJson(Map<String, dynamic> json) {
    classes =
        List.from(json['classes']).map((e) => Classes.fromJson(e)).toList();
    subjects =
        List.from(json['subjects']).map((e) => Subjects.fromJson(e)).toList();
    testimonials = List.castFrom<dynamic, dynamic>(json['testimonials']);
    apphomesliders = List.castFrom<dynamic, dynamic>(json['apphomesliders']);
    city = List.castFrom<dynamic, dynamic>(json['city']);
    fee = json['fee'];
    StudentEnq = json['StudentEnq'];
    Message = json['Message'];
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['classes'] = classes.map((e) => e.toJson()).toList();
    _data['subjects'] = subjects.map((e) => e.toJson()).toList();
    _data['testimonials'] = testimonials;
    _data['apphomesliders'] = apphomesliders;
    _data['city'] = city;
    _data['fee'] = fee;
    _data['StudentEnq'] = StudentEnq;
    _data['Message'] = Message;
    return _data;
  }
}

class Classes {
  Classes({
    required this.id,
    required this.className,
    required this.dt,
  });
  late final int id;
  late final String className;
  late final String dt;

  Classes.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    className = json['class_name'];
    dt = json['dt'];
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['id'] = id;
    _data['class_name'] = className;
    _data['dt'] = dt;
    return _data;
  }
}

class Subjects {
  Subjects({
    required this.id,
    required this.subjectName,
    required this.dt,
  });
  late final int id;
  late final String subjectName;
  late final String dt;

  Subjects.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    subjectName = json['subject_name'];
    dt = json['dt'];
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['id'] = id;
    _data['subject_name'] = subjectName;
    _data['dt'] = dt;
    return _data;
  }
}
