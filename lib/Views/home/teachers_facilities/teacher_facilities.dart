// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:offline_classes/Views/home/students_facilities/logout_screen.dart';
import 'package:offline_classes/Views/home/students_facilities/notice_screen.dart';
import 'package:offline_classes/Views/home/students_facilities/settings_screen.dart';
import 'package:offline_classes/Views/home/teachers_facilities/gk_screen_for_teachers.dart';
import 'package:offline_classes/Views/home/teachers_facilities/list_of_students.dart';
import 'package:offline_classes/Views/home/teachers_facilities/write_to_us_screen.dart';
import 'package:offline_classes/global_data/GlobalData.dart';
import 'package:sizer/sizer.dart';

import '../../../global_data/student_global_data.dart';
import '../../../global_data/teacher_global_data.dart';
import '../../../model/statics_list.dart';
import '../../../upi_pay/upi_pay.dart';
import '../../../utils/constants.dart';
import '../students_facilities/contact_us.dart';
import 'complaints.dart';
import 'package:http/http.dart' as http;
import 'my_profile_screen_teacher.dart';
import 'suggestions.dart';

class TeacherFacilities extends StatelessWidget {
  const TeacherFacilities({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: white,
        foregroundColor: black,
        leading: SizedBox(),
        title: GestureDetector(
          onTap: () {
            // nextScreen(context, UpiPay());
          },
          child: Text(
            'Teacher Facilities',
            style: kBodyText20wBold(primary),
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            InkWell(
              onTap: () {
                nextScreen(context, const MyProfileScreenTeacher());
              },
              child: Container(
                margin: EdgeInsets.all(8),
                padding: EdgeInsets.only(
                    left: 7.w, right: 5.w, top: 2.h, bottom: 2.h),
                // height: 12.h,
                width: 95.w,
                decoration: kGradientBoxDecoration(35, purpleGradident()),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SizedBox(
                      height: 12.h,
                      width: 53.w,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Text(
                            GlobalTeacher.profile["data"][0]["name"],
                            style: kBodyText22bold(white),
                          ),
                          Text(
                            '${GlobalTeacher.profile["data"][0]["city"]},${GlobalTeacher.profile["data"][0]["state"]}',
                            style: kBodyText12wNormal(white),
                          ),
                          Text(
                            GlobalData.phoneNumber,
                            style: kBodyText12wNormal(white),
                          )
                        ],
                      ),
                    ),
                    addHorizontalySpace(10),
                    Container(
                      height: 12.h,
                      width: 26.w,
                      decoration: kGradientBoxDecoration(18, orangeGradient()),
                      child: ClipRRect(
                        borderRadius: BorderRadius.all(Radius.circular(12)),
                        child: Image.network(
                          "${GlobalTeacher.urlPrefix}${GlobalTeacher.profile["data"][0]["image"]}",
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
                  itemCount: teacherFacilityList.length,
                  physics: NeverScrollableScrollPhysics(),
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      mainAxisSpacing: 10,
                      crossAxisSpacing: 10,
                      crossAxisCount: 3,
                      childAspectRatio: 0.83),
                  itemBuilder: (ctx, i) {
                    return InkWell(
                      onTap: () {
                        if (i == 0) {
                          nextScreen(context, const MyProfileScreenTeacher());
                        } else if (i == 1) {
                          nextScreen(
                              context,
                              NoticeScreen(
                                isVisible: true,
                              ));
                        } else if (i == 2) {
                          nextScreen(context, GKScreenForTeacher());
                        } else if (i == 3) {
                          nextScreen(
                              context, const ContactUs(title: "Write to Us"));
                        } else if (i == 4) {
                          nextScreen(
                              context,
                              SettingsScreen(
                                isVisible: false,
                              ));
                        } else if (i == 5) {
                          nextScreen(context, LogoutScreen());
                        } else if (i == 6) {
                          nextScreen(context, ListOfStudentsScreen());
                        } else if (i == 7) {
                          nextScreen(
                              context, const ContactUs(title: "Complaints"));
                        } else if (i == 8) {
                          nextScreen(
                              context, const ContactUs(title: "Suggestions"));
                        }
                      },
                      child: Container(
                        padding: EdgeInsets.all(10),
                        // padding: EdgeInsets.all(10),
                        height: 17.h,
                        width: 33.w,
                        decoration: k3DboxDecorationWithColor(
                          35,
                          teacherFacilityList[i]['color'],
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            SizedBox(
                                height: 8.4.h,
                                child:
                                    Image.asset(teacherFacilityList[i]['img'])),
                            Text(
                              teacherFacilityList[i]['title'],
                              style: kBodyText14w500withoutSizer(black),
                              textAlign: TextAlign.center,
                            )
                          ],
                        ),
                      ),
                    );
                  }),
            )
          ],
        ),
      ),
    );
  }
}
