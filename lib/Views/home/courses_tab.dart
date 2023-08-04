import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:offline_classes/Views/home/students_facilities/cancel_course_screen.dart';
import 'package:offline_classes/razorpay_payments/razorpay_screen.dart';
import 'package:offline_classes/utils/constants.dart';
import 'package:offline_classes/widget/custom_button.dart';
import 'package:http/http.dart' as http;
import 'package:sizer/sizer.dart';

import '../../global_data/GlobalData.dart';
import '../../global_data/student_global_data.dart';

class CoursesTab extends StatefulWidget {
  CoursesTab({super.key});

  @override
  State<CoursesTab> createState() => _CoursesTabState();
}

class _CoursesTabState extends State<CoursesTab> {
  bool showSpinner = false;

  Future<void> getCourses() async {
    final http.Response response = await http.get(Uri.parse(
        "${GlobalData.baseUrl}/courses?authKey=${GlobalData.auth1}&user_id=${GlobalStudent.id}&class=${GlobalStudent.specificProfile["data"][0]["class"]}&medium=${GlobalStudent.specificProfile["data"][0]["medium"]}"));
    courses = json.decode(response.body);
    if (response.statusCode == 200) {
      log(courses.toString());
    } else {
      print("Unsuccessful");
    }
  }

  Future<void> bookDemo(String id) async {
    final http.Response response = await http.get(Uri.parse(
        "${GlobalData.baseUrl}/demoCourse?authKey=${GlobalData.auth1}&student_id=${GlobalStudent.id}&course_id=$id"));
    var map = json.decode(response.body);
    // print("Demo");
    // print("Demo");
    // print("Demo");
    if (response.statusCode == 200) {
      // print(map);
      Get.snackbar(
        "Success",
        "Demo Course Booked",
        backgroundColor: Colors.green.withOpacity(0.65),
      );
      if (GlobalStudent.purchasedCourses.contains(id) == false) {
        GlobalStudent.purchasedCourses.add(id);
      }
      setState(() {});
    } else {
      Get.snackbar(
        "Error",
        "Course Booking Failed",
        backgroundColor: Colors.red.withOpacity(0.65),
      );
      print("Unsuccessful");
    }
  }

  Map<String, dynamic> courses = {};

  List moveCourse = [];

  @override
  Widget build(BuildContext context) {
    return ModalProgressHUD(
      inAsyncCall: showSpinner,
      child: Scaffold(
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
          actions: [
            TextButton(
              onPressed: () {
                nextScreen(context, CancelCourseScreen());
                setState(() {});
              },
              child: Text(
                'Cancel Courses',
                style: kBodyText14wBold(primary2),
              ),
            )
          ],
        ),
        body: FutureBuilder(
          future: getCourses(),
          builder: (context, snapshot) {
            if (courses.isEmpty) {
              return const Center(
                  child: CircularProgressIndicator(color: primary2));
            } else {
              GlobalStudent.purchasedCourses.clear();
              log("Clear: " + GlobalStudent.purchasedCourses.toString());
              for (var i in courses["mycourse"]) {
                GlobalStudent.purchasedCourses.add(i["id"]);
              }
              log("PR: ${GlobalStudent.purchasedCourses}");
              log("MC: ${GlobalStudent.moveCourse}");
              GlobalStudent().updateCourses(courses);
              return SingleChildScrollView(
                child: Column(
                  children: [
                    addVerticalSpace(10),
                    Center(
                      child: Text(
                        'Courses Enrolled',
                        style: kBodyText18wBold(primary),
                      ),
                    ),
                    addVerticalSpace(3.h),
                    ListView.builder(
                        shrinkWrap: true,
                        physics: NeverScrollableScrollPhysics(),
                        itemCount: courses["mycourse"].length,
                        itemBuilder: (ctx, i) {
                          if (GlobalStudent.purchasedCourses
                                  .contains(courses["mycourse"][i]["id"]) ==
                              false) {
                            GlobalStudent.purchasedCourses
                                .add(courses["mycourse"][i]["id"]);
                          }
                          return Container(
                            margin: EdgeInsets.all(10),
                            padding: EdgeInsets.symmetric(
                                horizontal: 10.w, vertical: 1.5.h),
                            // height: 11.h,
                            width: 93.w,
                            decoration:
                                kGradientBoxDecoration(35, purpleGradident()),
                            // decoration: kFillBoxDecoration(0, Color(0xff48116a), 35),

                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                Row(
                                  children: [
                                    SizedBox(
                                      width: 60.w,
                                      child: SingleChildScrollView(
                                        scrollDirection: Axis.horizontal,
                                        child: Text(
                                          courses["mycourse"][i]["course_name"],
                                          style: kBodyText24wBold(white),
                                        ),
                                      ),
                                    ),
                                    Spacer(),
                                    addHorizontalySpace(5.w),
                                    ClipRRect(
                                      borderRadius: BorderRadius.circular(30.h),
                                      child: Container(
                                        color: Colors.blue,
                                        padding: const EdgeInsets.all(8.0),
                                        child: InkWell(
                                          onTap: () {
                                            confirmationPopup(context);
                                          },
                                          child: const CircleAvatar(
                                            backgroundColor: Colors.white,
                                            radius: 10,
                                            child: Icon(
                                              Icons.close,
                                              size: 15,
                                            ),
                                          ),
                                        ),
                                      ),
                                    )
                                  ],
                                ),
                                Text(
                                  'Course started on: ${courses["mycourse"][i]["dt"].toString().substring(0, courses["mycourse"][i]["dt"].indexOf(" "))}',
                                  style: kBodyText15wNormal(white),
                                )
                              ],
                            ),
                          );
                        }),
                    addVerticalSpace(15),
                    Text(
                      'Selected Courses',
                      style: kBodyText20wBold(primary),
                    ),
                    addVerticalSpace(10),
                    ListView.builder(
                        itemCount: courses["data"].length,
                        shrinkWrap: true,
                        physics: NeverScrollableScrollPhysics(),
                        itemBuilder: (ctx, i) {
                          return !(GlobalStudent.moveCourse
                                      .contains(courses["data"][i]["id"])) ||
                                  GlobalStudent.purchasedCourses
                                      .contains(courses["data"][i]["id"])
                              ? const SizedBox(height: 0.1)
                              : GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      if (GlobalStudent.moveCourse
                                          .contains(courses["data"][i]["id"])) {
                                        GlobalStudent.moveCourse
                                            .remove(courses["data"][i]["id"]);
                                      } else {
                                        GlobalStudent.moveCourse
                                            .add(courses["data"][i]["id"]);
                                      }
                                    });
                                  },
                                  child: Container(
                                      // height: 8.h,
                                      padding: EdgeInsets.all(2.h),
                                      width: 93.w,
                                      margin: EdgeInsets.all(10),
                                      decoration: k3DboxDecoration(25),
                                      child: Column(
                                        children: [
                                          Row(
                                            children: [
                                              Text(
                                                courses["data"][i]
                                                    ["course_name"],
                                                style:
                                                    kBodyText18wBold(primary),
                                              ),
                                              Spacer(),
                                              Text(
                                                "Rs. ${courses["data"][i]["price"].toString()}",
                                                style:
                                                    kBodyText16wNormal(primary),
                                              ),
                                            ],
                                          ),
                                          addVerticalSpace(2.5.h),
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              CustomButtonOutline(
                                                  textWidget: Text(
                                                    'Book Demo',
                                                    style:
                                                        kBodyText12wBold(black),
                                                  ),
                                                  ontap: () {
                                                    bookDemo(courses["data"][i]
                                                            ["id"]
                                                        .toString());
                                                  },
                                                  width: 38.w,
                                                  height: 4.5.h),
                                              addHorizontalySpace(5.w),
                                              GestureDetector(
                                                onTap: () {
                                                  setState(() {
                                                    showSpinner = true;
                                                  });
                                                  nextScreen(
                                                    context,
                                                    RazorpayScreen(
                                                      amount: courses["data"][i]
                                                              ["price"]
                                                          .toDouble(),
                                                      role: GlobalData.role,
                                                      payment_type:
                                                          "Add course",
                                                      courseid: courses["data"]
                                                          [i]["id"],
                                                      user_id:
                                                          GlobalStudent.id!,
                                                    ),
                                                  );
                                                  setState(() {
                                                    showSpinner = false;
                                                  });
                                                },
                                                child: Container(
                                                  width: 30.w,
                                                  height: 4.5.h,
                                                  decoration:
                                                      kGradientBoxDecoration(
                                                          30, greenGradient()),
                                                  child: Center(
                                                    child: Text(
                                                      'Buy Course',
                                                      style: kBodyText12wBold(
                                                          white),
                                                    ),
                                                  ),
                                                ),
                                              )
                                            ],
                                          )
                                        ],
                                      )),
                                );
                        }),
                    addVerticalSpace(15),
                    Text(
                      'Add Courses',
                      style: kBodyText20wBold(primary),
                    ),
                    addVerticalSpace(10),
                    ListView.builder(
                      itemCount: courses["data"].length,
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      itemBuilder: (ctx, i) {
                        return (GlobalStudent.moveCourse
                                    .contains(courses["data"][i]["id"])) ||
                                GlobalStudent.purchasedCourses
                                    .contains(courses["data"][i]["id"])
                            ? const SizedBox(height: 0.1)
                            : GestureDetector(
                                onTap: () {
                                  setState(() {
                                    if (GlobalStudent.moveCourse
                                        .contains(courses["data"][i]["id"])) {
                                      GlobalStudent.moveCourse
                                          .remove(courses["data"][i]["id"]);
                                    } else {
                                      GlobalStudent.moveCourse
                                          .add(courses["data"][i]["id"]);
                                    }
                                  });
                                },
                                child: Container(
                                  // height: 8.h,
                                  padding: EdgeInsets.all(2.h),
                                  width: 93.w,
                                  margin: EdgeInsets.all(10),
                                  decoration: k3DboxDecoration(25),
                                  child: Column(
                                    children: [
                                      Row(
                                        children: [
                                          Text(
                                            courses["data"][i]["course_name"],
                                            style: kBodyText18wBold(primary),
                                          ),
                                          Spacer(),
                                          Text(
                                            "Rs. ${courses["data"][i]["price"].toString()}",
                                            style: kBodyText16wNormal(primary),
                                          ),
                                        ],
                                      ),
                                      addVerticalSpace(2.5.h),
                                    ],
                                  ),
                                ),
                              );
                      },
                    ),
                    addVerticalSpace(15),
                  ],
                ),
              );
            }
          },
        ),
      ),
    );
  }

  Future<dynamic> confirmationPopup(BuildContext context) {
    return showDialog(
      context: context,
      builder: (_) => AlertDialog(
        contentPadding: const EdgeInsets.all(6),
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(10.0))),
        content: StatefulBuilder(
          builder: (BuildContext context, StateSetter setState) {
            var height = MediaQuery.of(context).size.height;
            var width = MediaQuery.of(context).size.width;

            return Container(
              height: height * 0.3,
              // decoration: kFillBoxDecoration(0, white, 40),
              padding: EdgeInsets.all(10),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Text(
                    'Are you sure you want to cancel this Course?',
                    style: kBodyText18wBold(black),
                    textAlign: TextAlign.center,
                  ),
                  addVerticalSpace(2.h),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      InkWell(
                        onTap: () {
                          goBack(context);
                        },
                        child: Container(
                          height: 5.h,
                          width: 20.w,
                          decoration: kOutlineBoxDecoration(2, green, 18),
                          child: Center(
                            child: Text(
                              'No',
                              style: kBodyText16wBold(green),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 5.h,
                        width: 20.w,
                        child: CustomButton(
                          text: 'Yes',
                          onTap: () {
                            goBack(context);
                            nextScreen(context, CancelCourseScreen());
                          },
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
