import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:offline_classes/model/student_home_data_model.dart';

String baseUrl = "https://trusir.com/api";

class ApiServices {
  Future<List<StudentHomeDataModel>> getInfoStudentHome(
      String apiurl, String authkey, String mobno) async {
    var apiUrl = apiurl;
    var authKey = authkey;
    final http.Response response = await http.get(Uri.parse(
        baseUrl + apiUrl + "?authKey=" + authKey + "&mobile=91" + mobno));
    var mapResponse = json.decode(response.body);
    if (response.statusCode == 200) {
      List<dynamic> list = [];
      return list.map((e) => StudentHomeDataModel.fromJson(e)).toList();
    } else {
      return <StudentHomeDataModel>[];
    }
  }
}
