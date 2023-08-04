import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:get/get.dart';
import 'package:offline_classes/Views/home/students_facilities/about_us.dart';
import 'package:offline_classes/Views/home/students_facilities/change_mobile_number.dart';
import 'package:offline_classes/Views/home/students_facilities/contact_us.dart';
import 'package:offline_classes/Views/home/students_facilities/my_profile_screen.dart';
import 'package:offline_classes/Views/home/students_facilities/parents_doubts_saved.dart';
import 'package:offline_classes/Views/home/students_facilities/select_student_profile.dart';
import 'package:offline_classes/Views/home/students_facilities/terms_conditions.dart';
import 'package:offline_classes/Views/home/students_facilities/your_doubts.dart';
import 'package:offline_classes/global_data/GlobalData.dart';
import 'package:offline_classes/global_data/student_global_data.dart';
import 'package:offline_classes/utils/my_appbar.dart';
import 'package:sizer/sizer.dart';

import '../../../utils/constants.dart';
import '../courses_tab.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key, required this.isVisible});
  final bool isVisible;

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: customAppbar2(context, 'Settings'),
      body: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: SingleChildScrollView(
          child: Container(
            width: 110.w,
            child: Column(
              children: [
                addVerticalSpace(5.h),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Container(
                      height: 8.h,
                      width: 18.w,
                      decoration: kGradientBoxDecoration(20, purpleGradident()),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Image.asset('assets/images/set1.png'),
                      ),
                    ),
                    InkWell(
                      onTap: () {
                        nextScreen(
                            context,
                            MyProfileScreen(
                                image: 'assets/images/dummy1.png',
                                username: 'Diksha Shah'));
                      },
                      child: Container(
                        height: 8.h,
                        width: 81.w,
                        decoration: kFillBoxDecoration(
                            0, Color.fromRGBO(121, 62, 255, 0.2), 20),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            addHorizontalySpace(width(context) * 0.06),
                            Text(
                              'Edit Profile',
                              style: kBodyText16wBold(black),
                            ),
                            Spacer(),
                            Icon(Icons.arrow_forward_ios),
                            addHorizontalySpace(2.w),
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
                      decoration: kGradientBoxDecoration(20, purpleGradident()),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Image.asset('assets/images/set2.png'),
                      ),
                    ),
                    InkWell(
                      onTap: () {
                        nextScreen(context, ChangeMobileNumber());
                      },
                      child: Container(
                        height: 8.h,
                        width: 81.w,
                        decoration: kFillBoxDecoration(
                            0, Color.fromRGBO(121, 62, 255, 0.2), 20),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            addHorizontalySpace(width(context) * 0.03),
                            Text(
                              'Change Phone Number',
                              style: kBodyText16wBold(black),
                            ),
                            Spacer(),
                            Icon(Icons.arrow_forward_ios),
                            addHorizontalySpace(2.w),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
                Visibility(
                  visible: isVisible,
                  child: Column(
                    children: [
                      addVerticalSpace(height(context) * 0.02),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          InkWell(
                            onTap: () {},
                            child: Container(
                              height: 8.h,
                              width: 18.w,
                              decoration:
                                  kGradientBoxDecoration(20, purpleGradident()),
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Image.asset('assets/images/set3.png'),
                              ),
                            ),
                          ),
                          InkWell(
                            onTap: () {
                              !GlobalStudent.purchased
                                  ? redirect(context)
                                  : nextScreen(
                                      context, SelectTeacherForDoubtShow());
                            },
                            child: Container(
                              height: 8.h,
                              width: 81.w,
                              decoration: kFillBoxDecoration(
                                  0, Color.fromRGBO(121, 62, 255, 0.2), 20),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  addHorizontalySpace(width(context) * 0.06),
                                  Text(
                                    'Your Doubts',
                                    style: kBodyText16wBold(black),
                                  ),
                                  Spacer(),
                                  Icon(Icons.arrow_forward_ios),
                                  addHorizontalySpace(2.w),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                      // addVerticalSpace(height(context) * 0.02),
                      // Row(
                      //   mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      //   crossAxisAlignment: CrossAxisAlignment.center,
                      //   children: [
                      //     InkWell(
                      //       onTap: () {
                      //         // nextScreen(context, screen),
                      //       },
                      //       child: Container(
                      //         height: 8.h,
                      //         width: 18.w,
                      //         decoration:
                      //             kGradientBoxDecoration(20, purpleGradident()),
                      //         child: Padding(
                      //           padding: const EdgeInsets.all(8.0),
                      //           child: Image.asset('assets/images/sf8.png'),
                      //         ),
                      //       ),
                      //     ),
                      //     InkWell(
                      //       onTap: () {
                      //         !GlobalStudent.purchased
                      //             ? redirect(context)
                      //             : nextScreen(context, ParentsDoubtsSaved());
                      //       },
                      //       child: Container(
                      //         height: 8.h,
                      //         width: 81.w,
                      //         decoration: kFillBoxDecoration(
                      //             0, Color.fromRGBO(121, 62, 255, 0.2), 20),
                      //         child: Row(
                      //           mainAxisAlignment: MainAxisAlignment.start,
                      //           crossAxisAlignment: CrossAxisAlignment.center,
                      //           children: [
                      //             addHorizontalySpace(width(context) * 0.06),
                      //             Text(
                      //               'Parents Doubts',
                      //               style: kBodyText16wBold(black),
                      //             ),
                      //             Spacer(),
                      //             Icon(Icons.arrow_forward_ios),
                      //             addHorizontalySpace(2.w),
                      //           ],
                      //         ),
                      //       ),
                      //     ),
                      //   ],
                      // ),
                    ],
                  ),
                ),
                addVerticalSpace(height(context) * 0.02),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    InkWell(
                      onTap: () {
                        // nextScreen(context, screen),
                      },
                      child: Container(
                        height: 8.h,
                        width: 18.w,
                        decoration:
                            kGradientBoxDecoration(20, purpleGradident()),
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Image.asset('assets/images/set4.png'),
                        ),
                      ),
                    ),
                    InkWell(
                      onTap: () {
                        nextScreen(context, AboutUs());
                      },
                      child: Container(
                        height: 8.h,
                        width: 81.w,
                        decoration: kFillBoxDecoration(
                            0, Color.fromRGBO(121, 62, 255, 0.2), 20),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            addHorizontalySpace(width(context) * 0.06),
                            Text(
                              'About Us',
                              style: kBodyText16wBold(black),
                            ),
                            Spacer(),
                            Icon(Icons.arrow_forward_ios),
                            addHorizontalySpace(2.w),
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
                    InkWell(
                      onTap: () {
                        // nextScreen(context, screen),
                      },
                      child: Container(
                        height: 8.h,
                        width: 18.w,
                        decoration:
                            kGradientBoxDecoration(20, purpleGradident()),
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Image.asset('assets/images/set5.png'),
                        ),
                      ),
                    ),
                    InkWell(
                      onTap: () {
                        nextScreen(context, ContactUs());
                      },
                      child: Container(
                        height: 8.h,
                        width: 81.w,
                        decoration: kFillBoxDecoration(
                            0, Color.fromRGBO(121, 62, 255, 0.2), 20),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            addHorizontalySpace(width(context) * 0.06),
                            Text(
                              'Contact Us',
                              style: kBodyText16wBold(black),
                            ),
                            Spacer(),
                            Icon(Icons.arrow_forward_ios),
                            addHorizontalySpace(2.w),
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
                    InkWell(
                      onTap: () {
                        // nextScreen(context, screen),
                      },
                      child: Container(
                        height: 8.h,
                        width: 18.w,
                        decoration:
                            kGradientBoxDecoration(20, purpleGradident()),
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Image.asset('assets/images/set6.png'),
                        ),
                      ),
                    ),
                    InkWell(
                      onTap: () {
                        nextScreen(context, TermsAndConditions());
                      },
                      child: Container(
                        height: 8.h,
                        width: 81.w,
                        decoration: kFillBoxDecoration(
                            0, Color.fromRGBO(121, 62, 255, 0.2), 20),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            addHorizontalySpace(width(context) * 0.06),
                            Text(
                              'Terms & Conditions',
                              style: kBodyText16wBold(black),
                            ),
                            Spacer(),
                            Icon(Icons.arrow_forward_ios),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
                addVerticalSpace(10.w),
                Visibility(
                  visible: GlobalData.role == 'student',
                  child: GestureDetector(
                    onTap: () {
                      GlobalStudent().destroy();
                      nextScreen(context, SelectStudentProfile());
                    },
                    child: Center(
                      child: Text(
                        "Switch Student Account?",
                        style: kBodyText12wBold(Colors.blue),
                      ),
                    ),
                  ),
                ),
                addHorizontalySpace(10.w)
              ],
            ),
          ),
        ),
      ),
    );
  }
}
