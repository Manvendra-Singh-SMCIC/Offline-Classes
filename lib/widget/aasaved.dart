import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';

import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;
import 'package:offline_classes/utils/my_appbar.dart';
import 'package:offline_classes/widget/custom_button.dart';
import 'package:sizer/sizer.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';
import 'package:table_calendar/table_calendar.dart';
// import 'package:syncfusion_flutter_datepicker/datepicker.dart';

import '../../../global_data/GlobalData.dart';
import '../../../global_data/student_global_data.dart';
import '../../../utils/constants.dart';

class AttendanceTeacersList extends StatelessWidget {
  AttendanceTeacersList({super.key});

  Future<void> getTeacherList() async {
    final http.Response response = await http.get(Uri.parse(
        "${GlobalData.baseUrl}/teacherAssign?authKey=${GlobalData.auth1}&student_id=${GlobalStudent.id}"));
    teacherList = json.decode(response.body);
    if (response.statusCode == 200) {
      print(teacherList);
    } else {
      print("Unsuccessful");
    }
  }

  Map<String, dynamic> teacherList = {};

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: customAppbar2(context, 'SelectTecher'),
      body: FutureBuilder(
        future: getTeacherList(),
        builder: (context, snapshot) {
          if (teacherList.isEmpty) {
            return Center(child: CircularProgressIndicator(color: primary2));
          } else {
            return Column(
              children: [
                Expanded(
                  child: ListView.builder(
                    itemCount: teacherList["data"].length,
                    itemBuilder: (ctx, i) {
                      return InkWell(
                        onTap: () {
                          nextScreen(context, AttendaceCalendar());
                        },
                        child: Container(
                          margin: EdgeInsets.all(10),
                          padding: EdgeInsets.all(12),
                          // height: 12.h,
                          width: 93.w,
                          decoration:
                              kGradientBoxDecoration(35, purpleGradident()),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Container(
                                height: 11.h,
                                width: 25.w,
                                decoration: kGradientBoxDecoration(
                                    18, orangeGradient()),
                                child: ClipRRect(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(12)),
                                  child: Image.network(
                                    GlobalStudent.urlPrefix +
                                        teacherList["data"][i]["image"],
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                              addHorizontalySpace(width(context) * 0.06),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    teacherList["data"][i]["name"],
                                    style: kBodyText22bold(white),
                                  ),
                                  addVerticalSpace(10),
                                  Text(
                                    teacherList["data"][i]["subject"],
                                    style: kBodyText20wNormal(white),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            );
          }
        },
      ),
    );
  }
}

//---------------------------------------------------------------------------------------------------------------------------------------------------------------
//---------------------------------------------------------------------------------------------------------------------------------------------------------------
//---------------------------------------------------------------------------------------------------------------------------------------------------------------
//---------------------------------------------------------------------------------------------------------------------------------------------------------------
//---------------------------------------------------------------------------------------------------------------------------------------------------------------
class AttendaceCalendarView extends StatelessWidget {
  const AttendaceCalendarView({super.key});

  @override
  Widget build(BuildContext context) {
    // Replace with your implementation of AttendaceCalendar
    return Container(color: Colors.red);
  }
}

//---------------------------------------------------------------------------------------------------------------------------------------------------------------
//---------------------------------------------------------------------------------------------------------------------------------------------------------------
//---------------------------------------------------------------------------------------------------------------------------------------------------------------
class AttendaceCalendar extends StatefulWidget {
  @override
  AttendaceCalendarState createState() => AttendaceCalendarState();
}

/// State for MyApp
class AttendaceCalendarState extends State<AttendaceCalendar> {
  DateRangePickerController _datePickerController = DateRangePickerController();
  @override
  void initState() {
    Timer(Duration(seconds: 1), () {
      approvalPopup(context);
    });
    super.initState();
  }

  Future<void> getAttendence() async {
    final http.Response response = await http.get(Uri.parse(
        "${GlobalData.baseUrl}/studentAttandence?authKey=${GlobalData.auth1}&student_id=${GlobalStudent.id}"));
    attendance = json.decode(response.body);
    if (response.statusCode == 200) {
      print(attendance);
    } else {
      print("Unsuccessful");
    }
  }

  Map<String, dynamic> attendance = {};

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        home: FutureBuilder(
          future: getAttendence(),
          builder: (context, snapshot) {
            if (false) {
              return const Center(
                  child: CircularProgressIndicator(color: primary2));
            } else {
              return Scaffold(
                appBar: customAppbar2(context, 'Attendance'),
                body: SingleChildScrollView(
                  scrollDirection: Axis.vertical,
                  child: Column(
                    children: [
                      Container(
                        decoration: k3DboxDecoration(15),
                        margin: EdgeInsets.all(12),
                        height: 45.h,
                        child: SfDateRangePicker(
                            controller: _datePickerController,
                            view: DateRangePickerView.month,
                            monthViewSettings: DateRangePickerMonthViewSettings(
                                firstDayOfWeek: 1),
                            selectionMode:
                                DateRangePickerSelectionMode.multiple,
                            showActionButtons: false,
                            endRangeSelectionColor: Colors.red,
                            selectionColor: Colors.green,
                            rangeSelectionColor: Colors.yellow,
                            todayHighlightColor: Colors.green,
                            onSubmit: (val) {
                              print(val);
                            },
                            onCancel: () {
                              _datePickerController.selectedRanges = null;
                            }),
                      ),
                      addVerticalSpace(1.h),
                      Padding(
                        padding: EdgeInsets.all(2.h),
                        child: Column(
                          children: [
                            Row(
                              children: [
                                Container(
                                  height: 5.h,
                                  width: 13.w,
                                  decoration:
                                      kFillBoxDecoration(0, Colors.yellow, 10),
                                  child: Center(
                                    child: Text('25'),
                                  ),
                                ),
                                addHorizontalySpace(5.w),
                                Text(
                                  'Total classes taken',
                                  style: kBodyText14w500(black),
                                )
                              ],
                            ),
                            addVerticalSpace(1.h),
                            Row(
                              children: [
                                Container(
                                  height: 5.h,
                                  width: 13.w,
                                  decoration:
                                      kFillBoxDecoration(0, Colors.green, 10),
                                  child: Center(
                                    child: Text('21'),
                                  ),
                                ),
                                addHorizontalySpace(5.w),
                                Text(
                                  'Present',
                                  style: kBodyText14w500(black),
                                )
                              ],
                            ),
                            addVerticalSpace(1.h),
                            Row(
                              children: [
                                Container(
                                  height: 5.h,
                                  width: 13.w,
                                  decoration:
                                      kFillBoxDecoration(0, Colors.red, 10),
                                  child: Center(
                                    child: Text('4'),
                                  ),
                                ),
                                addHorizontalySpace(5.w),
                                Text(
                                  'Absent',
                                  style: kBodyText14w500(black),
                                )
                              ],
                            ),
                            addVerticalSpace(1.h),
                            Row(
                              children: [
                                Container(
                                  height: 5.h,
                                  width: 13.w,
                                  decoration:
                                      kFillBoxDecoration(0, boxColor, 10),
                                  child: Center(
                                    child: Text('2'),
                                  ),
                                ),
                                addHorizontalySpace(5.w),
                                Text(
                                  'Class not taken',
                                  style: kBodyText14w500(black),
                                )
                              ],
                            ),
                            addVerticalSpace(3.h),
                            Center(
                              child: CustomButton(
                                  text: 'Send Approval', onTap: () {}),
                            )
                          ],
                        ),
                      )
                    ],
                  ),
                ),
              );
            }
          },
        ));
  }

  Future<dynamic> approvalPopup(BuildContext context) {
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
                      height: height * 0.35,
                      // decoration: kFillBoxDecoration(0, white, 40),
                      padding: EdgeInsets.all(10),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Text(
                            "Accept Approval request from ‘Teacher/Student Name’ for 28/12/2022",
                            style: kBodyText18wBold(black),
                            textAlign: TextAlign.center,
                          ),
                          addVerticalSpace(6.h),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              InkWell(
                                onTap: () {
                                  goBack(context);
                                },
                                child: Container(
                                  height: 5.h,
                                  width: 30.w,
                                  decoration:
                                      kOutlineBoxDecoration(2, green, 18),
                                  child: Center(
                                    child: Text(
                                      'Reject',
                                      style: kBodyText16wBold(green),
                                    ),
                                  ),
                                ),
                              ),
                              SizedBox(
                                  height: 5.h,
                                  width: 30.w,
                                  child: CustomButton(
                                      text: 'Accept',
                                      onTap: () {
                                        goBack(context);
                                      }))
                            ],
                          ),
                          addVerticalSpace(20),
                        ],
                      ));
                },
              ),
            ));
  }
}
