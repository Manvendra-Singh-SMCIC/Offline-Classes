import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:offline_classes/utils/my_appbar.dart';
import 'package:sizer/sizer.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../global_data/GlobalData.dart';
import '../../../global_data/student_global_data.dart';
import '../../../utils/constants.dart';
import '../../../widget/custom_back_button.dart';

class TeacherProfile extends StatefulWidget {
  const TeacherProfile({super.key, required this.id});

  final int id;

  @override
  State<TeacherProfile> createState() => _TeacherProfileState();
}

class _TeacherProfileState extends State<TeacherProfile> {
  void _launchPhone(String phoneNumber) async {
    final Uri phoneUri = Uri(scheme: 'tel', path: phoneNumber);
    if (await canLaunchUrl(phoneUri)) {
      await launchUrl(phoneUri);
    } else {
      Get.snackbar(
        "Error",
        "Cannot make a call.",
        backgroundColor: Colors.red.withOpacity(0.65),
      );
    }
  }

  Future<void> getTeacherProfile() async {
    final http.Response response = await http.get(Uri.parse(
        "${GlobalData.baseUrl}/teacherProfile?authKey=${GlobalData.auth1}&teacher_id=${widget.id}"));
    teacherProfile = json.decode(response.body);
    if (response.statusCode == 200) {
      print(teacherProfile);
    } else {
      print("Unsuccessful");
    }
  }

  Map<String, dynamic> teacherProfile = {};

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: getTeacherProfile(),
      builder: (context, snapshot) {
        if (teacherProfile.isEmpty) {
          return Center(child: CircularProgressIndicator(color: primary2));
        } else {
          return Scaffold(
            body: SingleChildScrollView(
              child: Column(
                children: [
                  Container(
                    height: 42.h,
                    padding: EdgeInsets.all(2.h),
                    width: width(context),
                    decoration: BoxDecoration(
                        gradient: purpleGradident(),
                        borderRadius: BorderRadius.only(
                            bottomLeft: Radius.circular(100),
                            bottomRight: Radius.circular(100))),
                    child: SafeArea(
                      child: Column(
                        children: [
                          Row(
                            children: [
                              CustomBackButton(),
                              addHorizontalySpace(10),
                              Text(
                                "Teacher Profile",
                                textAlign: TextAlign.center,
                                style: kBodyText20wBold(white),
                              ),
                            ],
                          ),
                          addVerticalSpace(10),
                          Container(
                            height: 16.h,
                            width: 35.w,
                            decoration:
                                kGradientBoxDecoration(18, orangeGradient()),
                            child: ClipRRect(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(15)),
                              child: Image.network(
                                GlobalStudent.urlPrefix +
                                    teacherProfile["data"][0]["image"],
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                          addVerticalSpace(0.5.h),
                          Text(
                            teacherProfile["data"][0]["name"],
                            style: kBodyText27wBold(white),
                          )
                        ],
                      ),
                    ),
                  ),
                  addVerticalSpace(7.h),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Container(
                        padding: EdgeInsets.all(1.5.h),
                        height: 8.h,
                        width: 18.w,
                        decoration:
                            kGradientBoxDecoration(20, orangeGradient()),
                        child: Image.asset('assets/images/tp1.png'),
                      ),
                      Container(
                        height: 8.h,
                        width: 75.w,
                        decoration: kFillBoxDecoration(0, skinColor, 20),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            addHorizontalySpace(width(context) * 0.06),
                            Text(
                              '${teacherProfile["data"][0]["age"]}, ${teacherProfile["data"][0]["gender"]}',
                              style: kBodyText16wBold(black),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  addVerticalSpace(height(context) * 0.02),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Container(
                        padding: EdgeInsets.all(1.5.h),
                        height: 8.h,
                        width: 18.w,
                        decoration:
                            kGradientBoxDecoration(20, orangeGradient()),
                        child: Image.asset('assets/images/tp2.png'),
                      ),
                      Container(
                        height: 8.h,
                        width: 75.w,
                        decoration: kFillBoxDecoration(0, skinColor, 20),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            addHorizontalySpace(width(context) * 0.06),
                            SingleChildScrollView(
                              scrollDirection: Axis.horizontal,
                              child: Text(
                                '${teacherProfile["data"][0]["city"]}, ${teacherProfile["data"][0]["state"]}',
                                style: kBodyText16wBold(black),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  addVerticalSpace(height(context) * 0.02),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Container(
                        padding: EdgeInsets.all(1.5.h),
                        height: 8.h,
                        width: 18.w,
                        decoration:
                            kGradientBoxDecoration(20, orangeGradient()),
                        child: Image.asset('assets/images/tp3.png'),
                      ),
                      Container(
                        height: 8.h,
                        width: 75.w,
                        decoration: kFillBoxDecoration(0, skinColor, 20),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            addHorizontalySpace(width(context) * 0.06),
                            Text(
                              teacherProfile["data"][0]["qulification"],
                              style: kBodyText16wBold(black),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  addVerticalSpace(height(context) * 0.02),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Container(
                        height: 8.h,
                        width: 18.w,
                        padding: EdgeInsets.all(1.5.h),
                        decoration:
                            kGradientBoxDecoration(20, orangeGradient()),
                        child: Image.asset(
                          'assets/images/tp4.png',
                        ),
                      ),
                      Container(
                        height: 8.h,
                        width: 75.w,
                        decoration: kFillBoxDecoration(0, skinColor, 20),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            addHorizontalySpace(width(context) * 0.06),
                            SizedBox(
                              width: 69.w,
                              child: Text(
                                teacherProfile["data"][0]["exp"].toString(),
                                style: kBodyText16wBold(black),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  addVerticalSpace(height(context) * 0.02),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Container(
                        height: 8.h,
                        padding: EdgeInsets.all(1.h),
                        width: 18.w,
                        decoration:
                            kGradientBoxDecoration(20, orangeGradient()),
                        child: Image.asset(
                          'assets/images/pencil.png',
                        ),
                      ),
                      Container(
                        height: 8.h,
                        width: 75.w,
                        decoration: kFillBoxDecoration(0, skinColor, 20),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            addHorizontalySpace(width(context) * 0.06),
                            SizedBox(
                              width: 69.w,
                              child: Text(
                                teacherProfile["data"][0]["subject"],
                                style: kBodyText16wBold(black),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  addVerticalSpace(height(context) * 0.02),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      GestureDetector(
                        onTap: () {
                          _launchPhone((teacherProfile["data"][0]["phone"]
                              .toString()
                              .substring(2)));
                        },
                        child: Container(
                          height: 8.h,
                          padding: EdgeInsets.all(1.h),
                          width: 18.w,
                          decoration:
                              kGradientBoxDecoration(20, orangeGradient()),
                          child: Image.asset(
                            'assets/images/phone.png',
                          ),
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          _launchPhone((teacherProfile["data"][0]["phone"]
                              .toString()
                              .substring(2)));
                        },
                        child: Container(
                          height: 8.h,
                          width: 75.w,
                          decoration: kFillBoxDecoration(0, skinColor, 20),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              addHorizontalySpace(width(context) * 0.06),
                              SizedBox(
                                width: 69.w,
                                child: Text(
                                  teacherProfile["data"][0]["phone"]
                                      .toString()
                                      .substring(2),
                                  style: kBodyText16wBold(black),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                  addVerticalSpace(height(context) * 0.02),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Container(
                        padding: EdgeInsets.all(1.5.h),
                        height: 8.h,
                        width: 18.w,
                        decoration:
                            kGradientBoxDecoration(20, orangeGradient()),
                        child: Image.asset(
                          'assets/images/tp6.png',
                        ),
                      ),
                      Container(
                        height: 8.h,
                        width: 75.w,
                        decoration: kFillBoxDecoration(0, skinColor, 20),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            addHorizontalySpace(width(context) * 0.06),
                            Text(
                              '${teacherProfile["data"][0]["medium"]}',
                              style: kBodyText16wBold(black),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  addVerticalSpace(2.h)
                ],
              ),
            ),
          );
        }
      },
    );
  }
}
