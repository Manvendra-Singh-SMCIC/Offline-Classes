import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:offline_classes/Views/home/students_facilities/teacher_profile.dart';
import 'package:offline_classes/utils/constants.dart';
import 'package:offline_classes/utils/my_appbar.dart';
import 'package:offline_classes/widget/custom_back_button.dart';
import 'package:sizer/sizer.dart';

import '../../../global_data/GlobalData.dart';
import '../../../global_data/student_global_data.dart';

class TeachersListScreen extends StatelessWidget {
  TeachersListScreen({super.key});

  Future<void> getTeacherList() async {
    log("${GlobalData.baseUrl}/teacherAssign?authKey=${GlobalData.auth1}&student_id=${GlobalStudent.id}");
    final http.Response response = await http.get(Uri.parse(
        "${GlobalData.baseUrl}/teacherAssign?authKey=${GlobalData.auth1}&student_id=${GlobalStudent.id}"));
    teacherList = json.decode(response.body);
    if (response.statusCode == 200) {
      print(teacherList);
    } else {
      print("Unsuccessful");
    }
  }

  Map<String, dynamic> teacherList = {};

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: customAppbar2(context, 'Teachers Profile'),
      body: FutureBuilder(
        future: getTeacherList(),
        builder: (context, snapshot) {
          if (teacherList.isEmpty) {
            return Center(child: nullWidget());
          } else {
            return teacherList["data"].isEmpty
                ? const Center(
                    child: Text(
                      'Teachers will be assigned soon',
                    ),
                  )
                : Column(
                    children: [
                      addVerticalSpace(10),
                      Expanded(
                        child: ListView.builder(
                          itemCount: teacherList["data"].length,
                          itemBuilder: (ctx, i) {
                            return InkWell(
                              onTap: () {
                                nextScreen(
                                  context,
                                  TeacherProfile(
                                    id: teacherList["data"][i]["teacher_id"],
                                  ),
                                );
                              },
                              child: Container(
                                margin: EdgeInsets.all(10),
                                padding: EdgeInsets.all(12),
                                // height: 12.h,
                                width: 93.w,
                                decoration: kGradientBoxDecoration(
                                    35, purpleGradident()),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Container(
                                      height: 11.h,
                                      width: 25.w,
                                      decoration: kGradientBoxDecoration(
                                          18, orangeGradient()),
                                      child: ClipRRect(
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(12)),
                                        child: Image.network(
                                          GlobalStudent.urlPrefix +
                                              teacherList["data"][i]["image"],
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                    ),
                                    addHorizontalySpace(width(context) * 0.06),
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceEvenly,
                                      children: [
                                        SingleChildScrollView(
                                          scrollDirection: Axis.horizontal,
                                          child: Text(
                                            teacherList["data"][i]["name"],
                                            style: kBodyText22bold(white),
                                          ),
                                        ),
                                        addVerticalSpace(10),
                                        Text(
                                          teacherList["data"][i]["subject"],
                                          style: kBodyText18wNormal(white),
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
                  );
          }
        },
      ),
    );
  }
}
