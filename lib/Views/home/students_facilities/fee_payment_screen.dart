import 'dart:async';
import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';

import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;
import 'package:offline_classes/razorpay_payments/razorpay_screen.dart';
import 'package:offline_classes/utils/my_appbar.dart';
import 'package:offline_classes/widget/custom_button.dart';
import 'package:sizer/sizer.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';
import 'package:table_calendar/table_calendar.dart';
// import 'package:syncfusion_flutter_datepicker/datepicker.dart';

import '../../../global_data/GlobalData.dart';
import '../../../global_data/student_global_data.dart';
import '../../../utils/constants.dart';

class AttendaceCalendarView extends StatefulWidget {
  const AttendaceCalendarView(
      {super.key, required this.map, required this.name, required this.amount});

  final Map<String, dynamic> map;
  final String name;
  final double amount;

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
    log(map.toString());
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

    print(map);

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
                allowViewNavigation: false,
                enableMultiView: false,
                enablePastDates: false,
                selectionTextStyle: const TextStyle(color: black),
                monthViewSettings: DateRangePickerMonthViewSettings(
                  firstDayOfWeek: 1,
                  enableSwipeSelection: false,
                  weekendDays: weekend,
                  blackoutDates: abs,
                  specialDates: spl,
                ),
                selectionMode: DateRangePickerSelectionMode.multiple,
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
                    text: widget.amount != 0.0
                        ? 'Pay: Rs ${widget.amount.toString()}'
                        : 'Fee Paid',
                    onTap: () {
                      nextScreen(
                        context,
                        RazorpayScreen(
                          amount: widget.amount.toInt() * 1.0,
                          role: 'student',
                          payment_type: 'renew course',
                          courseid: map[name][0]["course_id"],
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

//---------------------------------------------------------------------------------------------------------------------------------------------------------------
//---------------------------------------------------------------------------------------------------------------------------------------------------------------
//---------------------------------------------------------------------------------------------------------------------------------------------------------------
}

class FeePaymentScreen extends StatefulWidget {
  const FeePaymentScreen({Key? key}) : super(key: key);
  @override
  FeePaymentScreenState createState() => FeePaymentScreenState();
}

/// State for MyApp
class FeePaymentScreenState extends State<FeePaymentScreen>
    with TickerProviderStateMixin {
  Future<void> getAttendence() async {
    final http.Response response = await http.get(Uri.parse(
        "${GlobalData.baseUrl}/studentAttandence?authKey=${GlobalData.auth1}&student_id=${GlobalStudent.id}"));
    attendance = json.decode(response.body);
    if (response.statusCode == 200) {
    } else {
      print("Unsuccessful");
    }
    List<String> subjectName = [];
    try {
      if (attendance["data"].length != 0) {
        subjectName = attendance["data"].keys.toList();
      } else {
        subjectName = [];
      }
    } on Exception catch (e) {
      subjectName = [];
    }
    doit(subjectName.isNotEmpty ? subjectName.length : 1);
  }

  Future<void> getAmount() async {
    log("${GlobalData.baseUrl}/feeCalculation?authKey=${GlobalData.auth1}&student_id=${GlobalStudent.id}");
    final http.Response res = await http.get(Uri.parse(
        "${GlobalData.baseUrl}/feeCalculation?authKey=${GlobalData.auth1}&student_id=${GlobalStudent.id}"));
    if (res.statusCode == 200) {
      if (res.body.isNotEmpty) {
        rate = json.decode(res.body);
        if (res.statusCode == 200) {
          log(rate.toString());
        } else {
          print("Unsuccessful");
        }
      }
    }
  }

  late TabController _tabController = TabController(length: 3, vsync: this);

  doit(int length) {
    _tabController = TabController(length: length, vsync: this);
  }

  Map<String, dynamic> attendance = {};
  Map<String, dynamic> rate = {};

  int i = 0;

  @override
  Widget build(BuildContext context) {
    try {
      return Scaffold(
        appBar: customAppbar2(context, "Fee Payment"),
        body: FutureBuilder(
          future: getAmount(),
          builder: (context, snapshot) {
            if (rate.isEmpty) {
              return Center(
                  child: Text(
                "No data yet",
                style: kBodyText18wBold(black),
              ));
            } else {
              return FutureBuilder(
                future: getAttendence(),
                builder: (context, snapshot) {
                  if (attendance.isEmpty) {
                    return const Center(
                        child: CircularProgressIndicator(color: primary2));
                  } else {
                    log(3.toString());
                    List<String> subjectName = [];
                    try {
                      if (attendance["data"].length != 0) {
                        subjectName = attendance["data"].keys.toList();
                      } else {
                        subjectName = [];
                      }
                    } on Exception catch (e) {
                      subjectName = [];
                    }
                    doit(subjectName.length != 0 ? subjectName.length : 1);
                    _tabController.index = i;
                    return subjectName.length == 0
                        ? Center(
                            child: Text(
                              "No data yet",
                              style: kBodyText18wBold(black),
                            ),
                          )
                        : Column(
                            children: [
                              Container(
                                margin: EdgeInsets.all(4),

                                padding: EdgeInsets.only(
                                    left: 9.w,
                                    right: 3.w,
                                    top: 2.h,
                                    bottom: 2.h),
                                // height: 12.h,
                                width: 93.w,
                                decoration: kGradientBoxDecoration(
                                    35, purpleGradident()),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          'Current Month',
                                          style: kBodyText20wBold(white),
                                        ),
                                        Text(
                                          'Reward your teachers',
                                          style: kBodyText14wNormal(white),
                                        ),
                                        addVerticalSpace(10),
                                        Text(
                                          'with what they deserve',
                                          style: kBodyText14wNormal(white),
                                        ),
                                        addVerticalSpace(1.3.h),
                                        Visibility(
                                          visible: false,
                                          child: InkWell(
                                            child: Container(
                                              height: 4.h,
                                              width: 30.w,
                                              decoration:
                                                  kGradientBoxDecoration(
                                                      30, greenGradient()),
                                              child: Center(
                                                child: Text(
                                                  'Pay Fee',
                                                  style:
                                                      kBodyText12wBold(white),
                                                ),
                                              ),
                                            ),
                                          ),
                                        )
                                      ],
                                    ),
                                    Column(
                                      children: [
                                        SizedBox(
                                          height: 9.h,
                                          child: Image.asset(
                                              'assets/images/fee.png'),
                                        ),
                                      ],
                                    )
                                  ],
                                ),
                              ),
                              addVerticalSpace(4.h),
                              PreferredSize(
                                preferredSize: Size.fromHeight(60),
                                child: TabBar(
                                    onTap: (value) {
                                      setState(() {
                                        i = value;
                                      });
                                    },
                                    indicator: BoxDecoration(
                                      gradient: purpleGradident(),
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    controller: _tabController,
                                    isScrollable: true,
                                    tabs: List.generate(
                                      attendance["data"].length,
                                      (index) => Container(
                                        height: 30,
                                        child: Center(
                                          child: Text(
                                            subjectName[index],
                                            style: TextStyle(
                                                color: i == index
                                                    ? Colors.white
                                                    : black),
                                          ),
                                        ),
                                      ),
                                    )),
                              ),
                              Expanded(
                                child: TabBarView(
                                  controller: _tabController,
                                  children: List.generate(
                                    rate["data"].length,
                                    (index) => AttendaceCalendarView(
                                      map: attendance["data"],
                                      name: subjectName[index],
                                      amount: rate["data"][subjectName[index]] *
                                              1.0 ??
                                          0 * 1.0,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          );
                  }
                },
              );
            }
          },
        ),
      );
    } catch (e) {
      return Center(
        child: Text(
          "Please try again later",
          style: kBodyText18wBold(black),
        ),
      );
    }
  }
}
