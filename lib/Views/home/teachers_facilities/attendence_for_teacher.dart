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
import '../../../global_data/teacher_global_data.dart';
import '../../../utils/constants.dart';

class AttendaceCalendarView extends StatefulWidget {
  const AttendaceCalendarView(
      {super.key, required this.map, required this.name});

  final Map<String, dynamic> map;
  final String name;

  @override
  State<AttendaceCalendarView> createState() => _AttendaceCalendarViewState();
}

class _AttendaceCalendarViewState extends State<AttendaceCalendarView> {
  DateRangePickerController _datePickerController = DateRangePickerController();

  late Map<String, dynamic> map;
  late String name;

  @override
  initState() {
    super.initState();
  }

  void markAbsent() {}

  @override
  Widget build(BuildContext context) {
    var now = DateTime.now();
    var formatter1 = DateFormat('MM');
    String month = formatter1.format(now);
    var formatter2 = DateFormat('yyyy');
    String year = formatter2.format(now);
    var formatter3 = DateFormat('d');
    String day = formatter3.format(now);
    map = widget.map;
    name = widget.name;
    int d = int.parse(day);
    int m = int.parse(month);
    int y = int.parse(year);

    int totalClassesTaken = 0;
    int present = 0;
    int absent = 0;
    int holidays = 0;

    List<DateTime> abs = [];
    List<DateTime> spl = [];
    List<int> weekend = [];

    print(map[name]);

    for (int i = 0; i < map[name].length; i++) {
      Map temp = map[name][i];
      print(temp);
      if (temp["isHolyday"] == 'yes' ||
          temp["isSunday"] == 'yes' ||
          temp["isSecondSaturday"] == 'yes' ||
          temp["isFourtSaturday"] == 'yes') {
        weekend.add(int.parse(temp["dt"].trim().substring(8, 10)));
        holidays++;
      } else {
        if (temp["student_attend"].toString().trim() == "yes" &&
            temp["techer_attend"].toString().trim() == "yes") {
          totalClassesTaken++;
          spl.add(
              DateTime(y, m, int.parse(temp["dt"].trim().substring(8, 10))));
          present++;
        } else {
          abs.add(
              DateTime(y, m, int.parse(temp["dt"].trim().substring(8, 10))));
          absent++;
        }
      }
    }
    print(abs);
    return SingleChildScrollView(
      child: Column(
        children: [
          Container(
            decoration: k3DboxDecoration(15),
            margin: EdgeInsets.all(12),
            height: 45.h,
            child: SfDateRangePicker(
                controller: _datePickerController,
                view: DateRangePickerView.month,
                selectionTextStyle: const TextStyle(color: black),
                monthViewSettings: DateRangePickerMonthViewSettings(
                  firstDayOfWeek: 1,
                  weekendDays: weekend,
                  blackoutDates: abs,
                  specialDates: spl,
                ),
                allowViewNavigation: false,
                enableMultiView: false,
                enablePastDates: false,
                showActionButtons: false,
                monthCellStyle: DateRangePickerMonthCellStyle(
                  specialDatesDecoration: BoxDecoration(
                    color: const Color.fromARGB(255, 133, 239, 137),
                    border: Border.all(
                      color: const Color.fromARGB(255, 54, 244, 130),
                      width: 1,
                    ),
                    shape: BoxShape.circle,
                  ),
                  weekendDatesDecoration: BoxDecoration(
                    color: Colors.grey.withOpacity(0.4),
                    border: Border.all(
                      color: Colors.grey.withOpacity(0.6),
                      width: 1,
                    ),
                    shape: BoxShape.circle,
                  ),
                  blackoutDatesDecoration: BoxDecoration(
                    color: Colors.red,
                    border: Border.all(
                      color: const Color(0xFFF44436),
                      width: 1,
                    ),
                    shape: BoxShape.circle,
                  ),
                ),
                endRangeSelectionColor: Colors.red,
                selectionColor: Colors.transparent,
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
                      decoration: kFillBoxDecoration(0, Colors.yellow, 10),
                      child: Center(
                        child: Text(totalClassesTaken.toString()),
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
                      decoration: kFillBoxDecoration(0, Colors.green, 10),
                      child: Center(
                        child: Text(present.toString()),
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
                      decoration: kFillBoxDecoration(0, Colors.red, 10),
                      child: Center(
                        child: Text(absent.toString()),
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
                      decoration: kFillBoxDecoration(0, boxColor, 10),
                      child: Center(
                        child: Text(holidays.toString()),
                      ),
                    ),
                    addHorizontalySpace(5.w),
                    Text(
                      'Holidays till now',
                      style: kBodyText14w500(black),
                    )
                  ],
                ),
                addVerticalSpace(3.h),
                Center(
                  child: CustomButton(
                      text: 'Send Approval',
                      onTap: () {
                        Timer(const Duration(seconds: 1), () {
                          approvalPopup(
                              context, day, month, year, map[name][0]);
                        });
                      }),
                )
              ],
            ),
          )
        ],
      ),
    );
  }

//---------------------------------------------------------------------------------------------------------------------------------------------------------------
//---------------------------------------------------------------------------------------------------------------------------------------------------------------
//---------------------------------------------------------------------------------------------------------------------------------------------------------------
}

class AttendaceForTeacher extends StatefulWidget {
  const AttendaceForTeacher({Key? key, required this.student_id})
      : super(key: key);
  @override
  final int student_id;
  AttendaceForTeacherState createState() => AttendaceForTeacherState();
}

/// State for MyApp
class AttendaceForTeacherState extends State<AttendaceForTeacher>
    with TickerProviderStateMixin {
  Future<void> getAttendence() async {
    final http.Response response = await http.get(Uri.parse(
        "${GlobalData.baseUrl}/teacherAttandence?authKey=${GlobalData.auth1}&student_id=${widget.student_id}&teacher_id=${GlobalTeacher.id}"));
    attendance = json.decode(response.body);
    if (response.statusCode == 200) {
      print("");
    } else {
      print("Unsuccessful");
    }
    List<String> subjectName = attendance["data"].keys.toList();
    doit(subjectName.length);
  }

  late TabController _tabController = TabController(length: 3, vsync: this);

  doit(int length) {
    _tabController = TabController(length: length, vsync: this);
  }

  int i = 0;

  Map<String, dynamic> attendance = {};

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: getAttendence(),
      builder: (context, snapshot) {
        if (attendance.isEmpty) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator(color: primary2)),
          );
        } else {
          List<String> subjectName = attendance["data"].keys.toList();
          doit(subjectName.length);
          _tabController.index = i;
          return Scaffold(
            appBar: customAppbar2(context, 'Attendance'),
            body: Column(
              children: [
                PreferredSize(
                  preferredSize: Size.fromHeight(60),
                  child: TabBar(
                      onTap: (value) {
                        setState(() {
                          i = value;
                        });
                      },
                      isScrollable: true,
                      indicator: BoxDecoration(
                        gradient: purpleGradident(),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      controller: _tabController,
                      tabs: List.generate(
                        attendance["data"].length,
                        (index) => Container(
                          height: 30,
                          child: Center(
                            child: Text(
                              subjectName[index],
                              style: TextStyle(
                                  color: i == index ? Colors.white : black),
                            ),
                          ),
                        ),
                      )),
                ),
                Expanded(
                  child: TabBarView(
                    controller: _tabController,
                    children: List.generate(
                      attendance["data"].length,
                      (index) => AttendaceCalendarView(
                        map: attendance["data"],
                        name: subjectName[index],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          );
        }
      },
    );
  }
}

Future<dynamic> approvalPopup(BuildContext context, String day, String month,
    String year, Map<String, dynamic> map) {
  return showDialog(
    context: context,
    builder: (BuildContext context) {
      return Builder(builder: ((BuildContext context) {
        return AlertDialog(
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
                      "Are you sure to mark the student absent for ${day}/${month}/${year}?",
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
                            decoration: kOutlineBoxDecoration(2, green, 18),
                            child: Center(
                              child: Text(
                                'Cancel',
                                style: kBodyText16wBold(green),
                              ),
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 5.h,
                          width: 30.w,
                          child: CustomButton(
                            text: 'Absent',
                            onTap: () async {
                              Map<String, dynamic> jsonresponse = {};
                              final http.Response response = await http.get(
                                  Uri.parse(
                                      "${GlobalData.baseUrl}/studentAbsent?authKey=${GlobalData.auth1}&teacher_id=${GlobalTeacher.id}&student_id=${map["student_id"]}&course_id=${map["course_id"]}"));
                              try {
                                jsonresponse = json.decode(response.body);
                                if (response.statusCode == 200) {
                                  print(jsonresponse);
                                } else {
                                  print("Unsuccessful");
                                }
                              } catch (e) {
                                print("Unsuccessful");
                              }
                              goBack(context);
                            },
                          ),
                        ),
                      ],
                    ),
                    addVerticalSpace(20),
                  ],
                ),
              );
            },
          ),
        );
      }));
    },
  );
}
