import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:offline_classes/Views/home/students_facilities/student_profile_edit.dart';
import 'package:offline_classes/global_data/GlobalData.dart';
import 'package:offline_classes/global_data/student_global_data.dart';
import 'package:sizer/sizer.dart';

import '../../../utils/constants.dart';
import '../../../widget/custom_back_button.dart';

class MyProfileScreen extends StatefulWidget {
  const MyProfileScreen(
      {super.key, required this.image, required this.username});
  final String image;
  final String username;

  @override
  State<MyProfileScreen> createState() => _MyProfileScreenState();
}

class _MyProfileScreenState extends State<MyProfileScreen> {
  File? image;
  ImagePicker picker = ImagePicker();
  bool showSpinner = false;
  @override
  Widget build(BuildContext context) {
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
                          "My Profile",
                          textAlign: TextAlign.center,
                          style: kBodyText20wBold(white),
                        ),
                      ],
                    ),
                    addVerticalSpace(10),
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
                            borderRadius: BorderRadius.all(Radius.circular(40)),
                            child: Image.network(
                              "${GlobalStudent.urlPrefix}${GlobalStudent.specificProfile["data"][0]["image"]}",
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                        InkWell(
                          onTap: () {
                            nextScreen(context, StudentProfileEdit());
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
                    addVerticalSpace(0.5.h),
                    Text(
                      GlobalStudent.specificProfile["data"][0]["name"],
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
                        GlobalStudent.specificProfile["data"][0]["dob"],
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
                  child: Image.asset('assets/images/school.png'),
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
                        width: 68.w,
                        child: Text(
                          GlobalStudent.specificProfile["data"][0]
                              ["school_name"],
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
                        GlobalStudent.specificProfile["data"][0]["class"],
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
                        GlobalStudent.specificProfile["data"][0]["subject"],
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
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        addHorizontalySpace(width(context) * 0.06),
                        Text(
                          '${GlobalStudent.specificProfile["data"][0]["city"]}, ${GlobalStudent.specificProfile["data"][0]["state"]}',
                          style: kBodyText16wBold(black),
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
                        GlobalData.phoneNumber,
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
