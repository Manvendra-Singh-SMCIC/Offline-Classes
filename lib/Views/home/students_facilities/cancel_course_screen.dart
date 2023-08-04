import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:offline_classes/utils/my_appbar.dart';
import 'package:sizer/sizer.dart';

import '../../../global_data/GlobalData.dart';
import '../../../global_data/student_global_data.dart';
import '../../../utils/constants.dart';
import '../../../widget/custom_button.dart';

class CancelCourseScreen extends StatefulWidget {
  const CancelCourseScreen({Key? key}) : super(key: key);

  @override
  _CancelCourseScreenState createState() => _CancelCourseScreenState();
}

class _CancelCourseScreenState extends State<CancelCourseScreen> {
  bool showSpinner = false;

  Future<void> delete() async {}

  @override
  Widget build(BuildContext context) {
    return ModalProgressHUD(
      inAsyncCall: showSpinner,
      child: Scaffold(
        appBar: customAppbar2(context, "Cancel Courses"),
        body: FutureBuilder(
            future: delete(),
            builder: (context, snapshot) {
              if (GlobalStudent.courses.isEmpty) {
                return const Center(
                  child: Text("No Courses to Delete"),
                );
              } else {
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
                      GlobalStudent.courses["mycourse"].length == 0
                          ? Center(
                              child: Text("No courses to delete."),
                            )
                          : ListView.builder(
                              shrinkWrap: true,
                              physics: NeverScrollableScrollPhysics(),
                              itemCount:
                                  GlobalStudent.courses["mycourse"].length,
                              itemBuilder: (ctx, i) {
                                GlobalStudent.courses["mycourse"][i]["id"];
                                return Container(
                                  margin: EdgeInsets.all(10),
                                  padding: EdgeInsets.symmetric(
                                      horizontal: 10.w, vertical: 1.5.h),
                                  // height: 11.h,
                                  width: 93.w,
                                  decoration: kGradientBoxDecoration(
                                      35, purpleGradident()),
                                  // decoration: kFillBoxDecoration(0, Color(0xff48116a), 35),

                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceEvenly,
                                    children: [
                                      Row(
                                        children: [
                                          Text(
                                            GlobalStudent.courses["mycourse"][i]
                                                ["course_name"],
                                            style: kBodyText24wBold(white),
                                          ),
                                          Spacer(),
                                          addHorizontalySpace(5.w),
                                          InkWell(
                                            onTap: () {
                                              confirmationPopup(context, i);
                                            },
                                            child: const CircleAvatar(
                                              backgroundColor: Colors.white,
                                              radius: 10,
                                              child: Icon(
                                                Icons.close,
                                                size: 15,
                                              ),
                                            ),
                                          )
                                        ],
                                      ),
                                      Text(
                                        'Course started on: ${GlobalStudent.courses["mycourse"][i]["dt"].toString().substring(0, GlobalStudent.courses["mycourse"][i]["dt"].indexOf(" "))}',
                                        style: kBodyText15wNormal(white),
                                      )
                                    ],
                                  ),
                                );
                              },
                            ),
                    ],
                  ),
                );
              }
            }),
      ),
    );
  }

  Future<dynamic> confirmationPopup(BuildContext context, int i) {
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
                              GlobalStudent.purchasedCourses.removeWhere(
                                  (element) =>
                                      element ==
                                      GlobalStudent.courses["mycourse"][i]
                                          ["id"]);
                              goBack(context);
                              deleteCourse(i);
                            },
                          ),
                        ),
                      ],
                    ),
                  ],
                ));
          },
        ),
      ),
    );
  }

  void deleteCourse(int i) async {
    setState(() {
      showSpinner = true;
    });
    final http.Response response = await http.get(Uri.parse(
        "${GlobalData.baseUrl}/coursesDelete?authKey=${GlobalData.auth1}&user_id=${GlobalStudent.id}&course_id=${GlobalStudent.courses["mycourse"][i]["id"]}"));

    Map<String, dynamic> map = json.decode(response.body);
    if (response.statusCode == 200) {
      print(map["Message"]);
      if (map["Message"] == "course deletion failed ,try again!") {
        Get.snackbar(
          "Failure",
          "Course not deleted or does not exist.",
          backgroundColor: Colors.red.withOpacity(0.65),
        );
      } else {
        GlobalStudent.purchasedCourses
            .remove(GlobalStudent.courses["mycourse"][i]["id"]);
        Get.snackbar(
          "Success",
          "Course Deleted",
          backgroundColor: Colors.green.withOpacity(0.65),
        );
        setState(() {});
      }
    } else {
      Get.snackbar(
        "Failure",
        "Course not deleted or does not exist.",
        backgroundColor: Colors.red.withOpacity(0.65),
      );
    }
    setState(() {
      showSpinner = false;
    });
  }
}
