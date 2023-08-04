import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:offline_classes/Views/home/teachers_facilities/teacher_profile_edit.dart';
import 'package:offline_classes/global_data/GlobalData.dart';
import 'package:sizer/sizer.dart';

import '../../../global_data/student_global_data.dart';
import '../../../global_data/teacher_global_data.dart';
import '../../../utils/constants.dart';
import '../../../widget/custom_back_button.dart';

class MyProfileScreenTeacher extends StatelessWidget {
  const MyProfileScreenTeacher({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              // height: 42.h,
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
                          "My Profile",
                          textAlign: TextAlign.center,
                          style: kBodyText20wBold(white),
                        ),
                      ],
                    ),
                    addVerticalSpace(2.w),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        addHorizontalySpace(9.w),
                        Container(
                          height: 17.h,
                          width: 39.w,
                          decoration:
                              kGradientBoxDecoration(40, orangeGradient()),
                          child: ClipRRect(
                            borderRadius: BorderRadius.all(Radius.circular(25)),
                            child: Image.network(
                              "${GlobalTeacher.urlPrefix}${GlobalTeacher.profile["data"][0]["image"]}",
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                        InkWell(
                          onTap: () {
                            nextScreen(context, const TeacherProfileEdit());
                          },
                          child: Container(
                            height: 40,
                            width: 40,
                            decoration:
                                kGradientBoxDecoration(50, orangeGradient()),
                            child: const Icon(
                              Icons.edit,
                              color: white,
                            ),
                          ),
                        )
                      ],
                    ),
                    addVerticalSpace(1.h),
                    Text(
                      GlobalTeacher.profile["data"][0]["name"],
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
                  height: 8.h,
                  width: 18.w,
                  decoration: kGradientBoxDecoration(20, orangeGradient()),
                  child: Image.asset('assets/images/birth.png'),
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
                        GlobalTeacher.profile["data"][0]["dob"],
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
                  decoration: kGradientBoxDecoration(20, orangeGradient()),
                  child: Image.asset('assets/images/graduation.png'),
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
                        GlobalTeacher.profile["data"][0]["preferd_class"],
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
                  decoration: kGradientBoxDecoration(20, orangeGradient()),
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
                      Text(
                        GlobalTeacher.profile["data"][0]["subject"],
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
                  decoration: kGradientBoxDecoration(20, orangeGradient()),
                  child: SizedBox(
                    child: Image.asset(
                      'assets/images/tp2.png',
                    ),
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
                      SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Text(
                          '${GlobalTeacher.profile["data"][0]["city"]},${GlobalTeacher.profile["data"][0]["state"]}',
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
                  width: 18.w,
                  decoration: kGradientBoxDecoration(20, orangeGradient()),
                  child: SizedBox(
                    // height: ,
                    child: Image.asset(
                      'assets/images/phone.png',
                    ),
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
                        GlobalData.phoneNumber.toString().substring(1),
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
}
