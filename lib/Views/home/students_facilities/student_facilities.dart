// ignore_for_file: prefer_const_constructors

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:offline_classes/Views/home/courses_tab.dart';
import 'package:offline_classes/Views/home/students_facilities/attendance_screen.dart';
import 'package:offline_classes/Views/home/students_facilities/fee_payment_screen.dart';
import 'package:offline_classes/Views/home/students_facilities/gk_screen.dart';
import 'package:offline_classes/Views/home/students_facilities/logout_screen.dart';
import 'package:offline_classes/Views/home/students_facilities/my_profile_screen.dart';
import 'package:offline_classes/Views/home/students_facilities/notice_screen.dart';
import 'package:offline_classes/Views/home/students_facilities/parents_doubts.dart';
import 'package:offline_classes/Views/home/students_facilities/progress_reports.dart';
import 'package:offline_classes/Views/home/students_facilities/settings_screen.dart';
import 'package:offline_classes/Views/home/students_facilities/student_doubts.dart';
import 'package:offline_classes/Views/home/students_facilities/teachers_list.dart';
import 'package:offline_classes/Views/home/students_facilities/test_series_screen.dart';
import 'package:offline_classes/global_data/GlobalData.dart';
import 'package:offline_classes/global_data/student_global_data.dart';
import 'package:offline_classes/model/statics_list.dart';
import 'package:offline_classes/utils/constants.dart';
import 'package:sizer/sizer.dart';
import 'package:http/http.dart' as http;

class StudentFacilities extends StatelessWidget {
  StudentFacilities({super.key});

  Future<void> getCourses() async {
    final http.Response response = await http.get(Uri.parse(
        "${GlobalData.baseUrl}/courses?authKey=${GlobalData.auth1}&user_id=${GlobalStudent.id}&class=${GlobalStudent.specificProfile["data"][0]["class"]}&medium=${GlobalStudent.specificProfile["data"][0]["medium"]}"));
    courses = json.decode(response.body);
    if (response.statusCode == 200) {
      // print(courses);
    } else {
      print("Unsuccessful");
    }
  }

  redirect(context) {
    Future.delayed(const Duration(milliseconds: 500), () {
      Get.snackbar(
        "Access Denied",
        "You need to enroll in a course first",
        backgroundColor: Colors.red.withOpacity(0.65),
      );
    });
    nextScreen(context, CoursesTab());
  }

  Map<String, dynamic> courses = {};

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: white,
        foregroundColor: black,
        leading: SizedBox(),
        title: Text(
          'Student Facilities',
          style: kBodyText20wBold(primary),
        ),
      ),
      body: FutureBuilder(
        future: getCourses(),
        builder: (context, snapshot) {
          if (courses.isEmpty) {
            return const Center(
                child: CircularProgressIndicator(color: primary2));
          } else {
            GlobalStudent.purchased = courses["mycourse"].length != 0;
            print(GlobalStudent.purchased);
            return SingleChildScrollView(
              child: Column(
                children: [
                  InkWell(
                    onTap: () {
                      nextScreen(
                          context,
                          MyProfileScreen(
                            image: 'assets/images/dummy1.png',
                            username: 'Diksha Shah',
                          ));
                    },
                    child: Container(
                      margin: EdgeInsets.all(10),
                      padding: EdgeInsets.only(
                          left: 7.w, right: 5.w, top: 2.h, bottom: 2.h),
                      // height: 18.h,
                      width: 95.w,
                      decoration: kGradientBoxDecoration(35, purpleGradident()),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Container(
                            width: 54.w,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                Text(
                                  GlobalStudent.specificProfile["data"][0]
                                      ["name"],
                                  style: kBodyText24wBold(white),
                                ),
                                SingleChildScrollView(
                                  scrollDirection: Axis.horizontal,
                                  child: Text(
                                    GlobalStudent.specificProfile["data"][0]
                                            ["city"] +
                                        ',' +
                                        GlobalStudent.specificProfile["data"][0]
                                            ["state"],
                                    style: kBodyText12wNormal(white),
                                  ),
                                ),
                                Text(
                                  GlobalData.phoneNumber,
                                  style: kBodyText12wNormal(white),
                                ),
                              ],
                            ),
                          ),
                          addHorizontalySpace(10),
                          Container(
                            height: 12.h,
                            width: 26.w,
                            decoration:
                                kGradientBoxDecoration(18, orangeGradient()),
                            child: ClipRRect(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(12)),
                              child: Image.network(
                                "${GlobalStudent.urlPrefix}${GlobalStudent.specificProfile["data"][0]["image"]}",
                                fit: BoxFit.cover,
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                  addVerticalSpace(1.h),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: GridView.builder(
                        shrinkWrap: true,
                        itemCount: studentFacilityList.length,
                        physics: NeverScrollableScrollPhysics(),
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                            mainAxisSpacing: 10,
                            crossAxisSpacing: 10,
                            crossAxisCount: 3,
                            childAspectRatio: 0.83),
                        itemBuilder: (ctx, i) {
                          return Visibility(
                            child: InkWell(
                              onTap: () {
                                if (i == 0) {
                                  nextScreen(
                                      context,
                                      MyProfileScreen(
                                        image: 'assets/images/dummy1.png',
                                        username: GlobalStudent
                                            .specificProfile["data"][0]["name"],
                                      ));
                                } else if (i == 1) {
                                  !GlobalStudent.purchased
                                      ? redirect(context)
                                      : nextScreen(
                                          context, TeachersListScreen());
                                } else if (i == 2) {
                                  !GlobalStudent.purchased
                                      ? redirect(context)
                                      : nextScreen(
                                          context, AttendanceTeacersList());
                                } else if (i == 3) {
                                  !GlobalStudent.purchased
                                      ? redirect(context)
                                      : nextScreen(context, FeePaymentScreen());
                                } else if (i == 4) {
                                  !GlobalStudent.purchased
                                      ? redirect(context)
                                      : nextScreen(context, TestSeriesScreen());
                                } else if (i == 5) {
                                  !GlobalStudent.purchased
                                      ? redirect(context)
                                      : nextScreen(context, ProgressReports());
                                } else if (i == 6) {
                                  !GlobalStudent.purchased
                                      ? redirect(context)
                                      : nextScreen(context, StudentsDoubts());
                                } else if (i == 7) {
                                  !GlobalStudent.purchased
                                      ? redirect(context)
                                      : nextScreen(context, GKScreen());
                                } else if (i == 8) {
                                  !GlobalStudent.purchased
                                      ? redirect(context)
                                      : nextScreen(
                                          context,
                                          NoticeScreen(
                                            isVisible: false,
                                          ));
                                } else if (i == 9) {
                                  nextScreen(
                                      context,
                                      SettingsScreen(
                                        isVisible: true,
                                      ));
                                } else if (i == 10) {
                                  nextScreen(context, LogoutScreen());
                                }
                              },
                              child: Container(
                                padding: EdgeInsets.all(7),
                                // padding: EdgeInsets.all(10),
                                // height: 17.h,
                                width: 33.w,
                                decoration: k3DboxDecorationWithColor(
                                  35,
                                  studentFacilityList[i]['color'],
                                ),
                                child: Column(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: [
                                    SizedBox(
                                      height: 7.8.h,
                                      child: Image.asset(
                                        studentFacilityList[i]['img'],
                                        fit: BoxFit.fill,
                                      ),
                                    ),
                                    Text(
                                      studentFacilityList[i]['title'],
                                      style: kBodyText14w500withoutSizer(black),
                                      textAlign: TextAlign.center,
                                    )
                                  ],
                                ),
                              ),
                            ),
                          );
                        }),
                  )
                ],
              ),
            );
          }
        },
      ),
    );
  }
}
