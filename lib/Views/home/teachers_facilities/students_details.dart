import 'package:flutter/material.dart';
import 'package:offline_classes/Views/home/students_facilities/attendance_screen.dart';
import 'package:offline_classes/Views/home/students_facilities/my_profile_screen.dart';
import 'package:offline_classes/Views/home/students_facilities/notice_screen.dart';
import 'package:offline_classes/Views/home/students_facilities/progress_reports.dart';
import 'package:offline_classes/Views/home/teachers_facilities/gk_screen_for_teachers.dart';
import 'package:offline_classes/Views/home/teachers_facilities/test_series_teacher.dart';
import 'package:offline_classes/Views/home/teachers_facilities/view_student_doubts.dart';
import 'package:offline_classes/Views/home/teachers_facilities/view_student_profile.dart';
import 'package:offline_classes/global_data/student_global_data.dart';
import 'package:offline_classes/utils/my_appbar.dart';
import 'package:sizer/sizer.dart';
import 'package:http/http.dart' as http;
import '../../../global_data/teacher_global_data.dart';
import '../../../utils/constants.dart';
import '../../../widget/image_opener.dart';
import 'add_progress_report.dart';
import 'attendence_for_teacher.dart';

class StudentsDetails extends StatelessWidget {
  const StudentsDetails({super.key, required this.student});

  final Map<String, dynamic> student;

  Future<bool> checkImageURL(String imageUrl) async {
    try {
      final response = await http.head(Uri.parse(imageUrl));
      return response.statusCode == 200;
    } catch (e) {
      return false;
    }
  }

  @override
  Widget build(BuildContext context) {
    print(student);
    return Scaffold(
      appBar: customAppbar2(context, 'Student Profile'),
      body: Column(
        children: [
          addVerticalSpace(2.h),
          Container(
            margin: EdgeInsets.all(10),
            padding: EdgeInsets.all(12),
            // height: 12.h,
            width: 93.w,
            decoration: kGradientBoxDecoration(35, purpleGradident()),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  height: 12.h,
                  width: 25.w,
                  decoration: kGradientBoxDecoration(18, orangeGradient()),
                  child: FutureBuilder(
                    future: checkImageURL(
                        GlobalStudent.urlPrefix + student["image"]),
                    builder:
                        (BuildContext context, AsyncSnapshot<bool> snapshot) {
                      if (snapshot.connectionState == ConnectionState.done &&
                          snapshot.data == true) {
                        return ClipRRect(
                            borderRadius: BorderRadius.circular(15),
                            child: imageNetwork(
                              GlobalStudent.urlPrefix + student["image"],
                              fit: BoxFit.cover,
                            ));
                      } else {
                        return Image.asset('assets/images/dummy1.png');
                      }
                    },
                  ),
                ),
                addHorizontalySpace(5.w),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      student["name"],
                      style: kBodyText22bold(white),
                    ),
                    addVerticalSpace(2),
                    Text(
                      "+${student["phone"]}",
                      style: kBodyText12wNormal(white),
                    ),
                    addVerticalSpace(2),
                    Text(
                      student["subject"],
                      style: kBodyText12wNormal(white),
                    ),
                    addHorizontalySpace(2.w),
                    InkWell(
                      onTap: () {
                        nextScreen(
                          context,
                          ViewStudentProfile(studentlist: student),
                        );
                      },
                      child: Text(
                        'View Profile',
                        style: kBodyText10wBold(Colors.amber),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          addVerticalSpace(4.5.h),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                height: 8.h,
                width: 18.w,
                decoration: kGradientBoxDecoration(20, orangeGradient()),
                child: Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Image.asset('assets/images/sp1.png'),
                ),
              ),
              InkWell(
                onTap: () {
                  nextScreen(context,
                      AttendaceForTeacher(student_id: student["student_id"]));
                },
                child: Container(
                  height: 8.h,
                  width: 75.w,
                  decoration: kFillBoxDecoration(0, skinColor, 20),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 12.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          'Student Attendance',
                          style: kBodyText16wBold(black),
                        ),
                        const Icon(
                          Icons.arrow_forward_ios,
                          size: 20,
                        )
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
          addVerticalSpace(2.h),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                height: 8.h,
                width: 18.w,
                decoration: kGradientBoxDecoration(20, orangeGradient()),
                child: Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Image.asset('assets/images/pencil.png'),
                ),
              ),
              InkWell(
                onTap: () {
                  nextScreen(
                    context,
                    TestSeriesForTeacher(
                      title: 'Test Series',
                      student_id: student["student_id"],
                    ),
                  );
                },
                child: Container(
                  height: 8.h,
                  width: 75.w,
                  decoration: kFillBoxDecoration(0, skinColor, 20),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 12.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          'Test Series',
                          style: kBodyText16wBold(black),
                        ),
                        const Icon(
                          Icons.arrow_forward_ios,
                          size: 20,
                        )
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
          addVerticalSpace(2.h),
          // Row(
          //   mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          //   crossAxisAlignment: CrossAxisAlignment.center,
          //   children: [
          //     Container(
          //       height: 8.h,
          //       width: 18.w,
          //       decoration: kGradientBoxDecoration(20, orangeGradient()),
          //       child: Padding(
          //         padding: const EdgeInsets.all(10.0),
          //         child: Image.asset('assets/images/set3.png'),
          //       ),
          //     ),
          //     InkWell(
          //       onTap: () {
          //         nextScreen(context,
          //             AppProgressReportList(student_id: student["student_id"]));
          //       },
          //       child: Container(
          //         height: 8.h,
          //         width: 75.w,
          //         decoration: kFillBoxDecoration(0, skinColor, 20),
          //         child: Padding(
          //           padding: const EdgeInsets.symmetric(horizontal: 12.0),
          //           child: Row(
          //             mainAxisAlignment: MainAxisAlignment.spaceBetween,
          //             crossAxisAlignment: CrossAxisAlignment.center,
          //             children: [
          //               Text(
          //                 'Progress Report',
          //                 style: kBodyText16wBold(black),
          //               ),
          //               const Icon(
          //                 Icons.arrow_forward_ios,
          //                 size: 20,
          //               )
          //             ],
          //           ),
          //         ),
          //       ),
          //     ),
          //   ],
          // ),
          // addVerticalSpace(2.h),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                height: 8.h,
                width: 18.w,
                decoration: kGradientBoxDecoration(20, orangeGradient()),
                child: Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Image.asset('assets/images/set3.png'),
                ),
              ),
              InkWell(
                onTap: () {
                  nextScreen(
                    context,
                    ViewStudentDoubts(
                      title: 'Students Doubts',
                      student_id: student["student_id"],
                    ),
                  );
                },
                child: Container(
                  height: 8.h,
                  width: 75.w,
                  decoration: kFillBoxDecoration(0, skinColor, 20),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 12.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          'Student Doubts',
                          style: kBodyText16wBold(black),
                        ),
                        const Icon(
                          Icons.arrow_forward_ios,
                          size: 20,
                        )
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
          addVerticalSpace(2.h),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                height: 8.h,
                width: 18.w,
                decoration: kGradientBoxDecoration(20, orangeGradient()),
                child: Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Image.asset('assets/images/sf9.png'),
                ),
              ),
              InkWell(
                onTap: () {
                  nextScreen(
                      context,
                      AddGKContent(
                          student_id: student["id"], category: "foryou"));
                },
                child: Container(
                  height: 8.h,
                  width: 75.w,
                  decoration: kFillBoxDecoration(0, skinColor, 20),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 12.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          'General Knowledge',
                          style: kBodyText16wBold(black),
                        ),
                        const Icon(
                          Icons.arrow_forward_ios,
                          size: 20,
                        )
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
          addVerticalSpace(2.h),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                height: 8.h,
                width: 18.w,
                decoration: kGradientBoxDecoration(20, orangeGradient()),
                child: Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Image.asset('assets/images/sf10.png'),
                ),
              ),
              InkWell(
                onTap: () {
                  nextScreen(
                    context,
                    AddNoticeScreen(
                      type: "foryou",
                      student_id: student["id"],
                    ),
                  );
                },
                child: Container(
                  height: 8.h,
                  width: 75.w,
                  decoration: kFillBoxDecoration(0, skinColor, 20),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 12.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          'Notice',
                          style: kBodyText16wBold(black),
                        ),
                        const Icon(
                          Icons.arrow_forward_ios,
                          size: 20,
                        )
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
