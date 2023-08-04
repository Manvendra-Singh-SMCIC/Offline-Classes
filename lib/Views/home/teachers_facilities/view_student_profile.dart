import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:sizer/sizer.dart';

import '../../../global_data/teacher_global_data.dart';
import '../../../utils/constants.dart';
import '../../../widget/custom_back_button.dart';

class ViewStudentProfile extends StatelessWidget {
  const ViewStudentProfile({super.key, required this.studentlist});

  final Map<String, dynamic> studentlist;

  @override
  Widget build(BuildContext context) {
    print(studentlist);
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
                          "Student Profile",
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
                          height: 12.h,
                          width: 26.w,
                          decoration:
                              kGradientBoxDecoration(18, orangeGradient()),
                          child: ClipRRect(
                            borderRadius: BorderRadius.all(Radius.circular(12)),
                            child: Image.network(
                              "${GlobalTeacher.urlPrefix}${studentlist["aadhar"]}",
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                      ],
                    ),
                    addVerticalSpace(2.h),
                    Text(
                      studentlist["name"],
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
                        studentlist["dob"],
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
                          studentlist["school_name"],
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
                        studentlist["class"],
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
                        studentlist["subject"],
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
                        SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: Text(
                            '${studentlist["city"]},${studentlist["state"]}',
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
                        studentlist["phone"].toString(),
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
