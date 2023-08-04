// ignore_for_file: non_constant_identifier_names

class GlobalTeacher {
  static Map<String, dynamic> profile = {};
  static int? id;
  static String urlPrefix = "https://trusir.com/";
  static int? myStudentID;
  static List<String> classes = [];
  static List<String> subjects = [];

  updateProfiles(Map<String, dynamic> map) {
    profile = map;
    print("Global Profiles");
    print(profile);
  }

  updateId(int ID) {
    id = ID;
    print("Global ID");
    print(id);
  }

  updateMyStudentId(int ID) {
    myStudentID = ID;
    print("Global Student ID");
    print(id);
  }
}
