import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:offline_classes/Views/home/teachers_facilities/students_details.dart';
import 'package:offline_classes/Views/home/teachers_facilities/view_student_profile.dart';
import 'package:offline_classes/utils/my_appbar.dart';
import 'package:sizer/sizer.dart';
import 'package:http/http.dart' as http;
import '../../../global_data/GlobalData.dart';
import '../../../global_data/student_global_data.dart';
import '../../../global_data/teacher_global_data.dart';
import '../../../utils/constants.dart';
import '../../../widget/image_opener.dart';

class ListOfStudentsScreen extends StatelessWidget {
  ListOfStudentsScreen({super.key});

  Future<void> getStudents() async {
    final http.Response response = await http.get(Uri.parse(
        "${GlobalData.baseUrl}/studentList?authKey=${GlobalData.auth1}&teacher_id=${GlobalTeacher.id}"));
    studentlist = json.decode(response.body);
    if (response.statusCode == 200) {
      print(studentlist);
    } else {
      print("Unsuccessful");
    }
  }

  Future<bool> checkImageURL(String imageUrl) async {
    try {
      final response = await http.head(Uri.parse(imageUrl));
      return response.statusCode == 200;
    } catch (e) {
      return false;
    }
  }

  Map<String, dynamic> studentlist = {};
  Map<String, dynamic> courseTest = {};

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: getStudents(),
      builder: (context, snapshot) {
        if (studentlist.isEmpty) {
          return Center(child: Scaffold(body: Container(color: white)));
        } else {
          return Scaffold(
            appBar: customAppbar2(context, 'Students List'),
            body: Column(
              children: [
                Expanded(
                  child: ListView.builder(
                    itemCount: studentlist["data"].length,
                    itemBuilder: (ctx, i) {
                      return InkWell(
                        onTap: () {
                          nextScreen(context,
                              StudentsDetails(student: studentlist["data"][i]));
                        },
                        child: Container(
                          margin: EdgeInsets.all(10),
                          padding: EdgeInsets.all(12),
                          // height: 12.h,
                          width: 93.w,
                          decoration:
                              kGradientBoxDecoration(35, purpleGradident()),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Container(
                                height: 11.h,
                                width: 25.w,
                                decoration: kGradientBoxDecoration(
                                    18, orangeGradient()),
                                child: FutureBuilder(
                                  future: checkImageURL(
                                      GlobalStudent.urlPrefix +
                                          studentlist["data"][i]["image"]),
                                  builder: (BuildContext context,
                                      AsyncSnapshot<bool> snapshot) {
                                    if (snapshot.connectionState ==
                                            ConnectionState.done &&
                                        snapshot.data == true) {
                                      return imageNetwork(
                                        GlobalStudent.urlPrefix +
                                            studentlist["data"][i]["name"],
                                        fit: BoxFit.cover,
                                      );
                                    } else {
                                      return Image.asset(
                                          'assets/images/dummy1.png');
                                    }
                                  },
                                ),
                              ),
                              addHorizontalySpace(width(context) * 0.06),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    studentlist["data"][i]["name"],
                                    style: kBodyText24wBold(white),
                                  ),
                                  addVerticalSpace(10),
                                  Text(
                                    studentlist["data"][i]["subject"],
                                    style: kBodyText16wNormal(white),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          );
        }
      },
    );
  }
}
