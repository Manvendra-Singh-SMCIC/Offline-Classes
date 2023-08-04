import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';

import 'package:sizer/sizer.dart';
import 'package:http/http.dart' as http;

import '../../../global_data/GlobalData.dart';
import '../../../global_data/student_global_data.dart';
import '../../../global_data/teacher_global_data.dart';
import '../../../utils/constants.dart';
import '../../../widget/custom_button.dart';

class TeachersCourseTab extends StatefulWidget {
  const TeachersCourseTab({super.key});

  @override
  State<TeachersCourseTab> createState() => _TeachersCourseTabState();
}

class _TeachersCourseTabState extends State<TeachersCourseTab> {
  Future<void> getCourses() async {
    final http.Response response = await http.get(Uri.parse(
        "${GlobalData.baseUrl}/studentList?authKey=${GlobalData.auth1}&teacher_id=${GlobalTeacher.id}"));
    courses = json.decode(response.body);
    if (response.statusCode == 200) {
      log(courses.toString());
    } else {
      print("Unsuccessful");
    }
  }

  Map<String, dynamic> courses = {};

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: white,
        foregroundColor: black,
        elevation: 0,
        leadingWidth: width(context) * 0.4,
        leading: Padding(
          padding: const EdgeInsets.only(top: 12.0),
          child: Text(
            '  Courses',
            style: kBodyText20wBold(primary),
          ),
        ),
      ),
      body: FutureBuilder(
        builder: (context, snapshot) {
          return Column(
            children: [
              Center(
                child: Text(
                  'Courses List',
                  style: kBodyText20wBold(primary),
                ),
              ),
              FutureBuilder(
                future: getCourses(),
                builder: (context, snapshot) {
                  if (courses.isEmpty) {
                    return const Center(
                        child: CircularProgressIndicator(color: primary2));
                  } else {
                    return Expanded(
                      child: ListView.builder(
                          itemCount: courses["data"].length,
                          itemBuilder: (ctx, i) {
                            return Container(
                              margin: EdgeInsets.all(2.h),
                              padding: EdgeInsets.symmetric(
                                  horizontal: 8.w, vertical: 1.7.h),
                              // height: 21.h,
                              width: 95.w,
                              decoration:
                                  kGradientBoxDecoration(42, purpleGradident()),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
                                children: [
                                  Text(
                                    courses["data"][i]["name"],
                                    style: kBodyText24wBold(white),
                                  ),
                                  Text(
                                    'Course Started On : ${courses["data"][i]["dt"].substring(0, courses["data"][i]["dt"].indexOf(' '))}',
                                    style: kBodyText14w500(white),
                                  ),
                                  Text(
                                    'End date : ${courses["data"][i]["end_date"]}',
                                    style: kBodyText14w500(white),
                                  ),
                                  Text(
                                    'Subject : ${courses["data"][i]["subject"]}',
                                    style: kBodyText14w500(white),
                                  ),
                                  Text(
                                    '${courses["data"][i]["city"]},${courses["data"][i]["state"]}',
                                    style: kBodyText14w500(white),
                                  ),
                                  addVerticalSpace(5),
                                  Container(
                                    decoration: kGradientBoxDecoration(
                                        30, greenGradient()),
                                    width: 32.w,
                                    height: 4.5.h,
                                    child: Center(
                                      child: Text(
                                        courses["data"][i]["type"] == "demo"
                                            ? 'Demo Course'
                                            : 'Full Plan',
                                        style: kBodyText12wBold(white),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            );
                          }),
                    );
                  }
                },
              )
            ],
          );
        },
      ),
    );
  }
}
