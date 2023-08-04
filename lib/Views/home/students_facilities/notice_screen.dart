// ignore_for_file: prefer_const_literals_to_create_immutables

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:offline_classes/model/statics_list.dart';
import 'package:offline_classes/utils/constants.dart';
import 'package:offline_classes/utils/my_appbar.dart';
import 'package:offline_classes/widget/custom_button.dart';
import 'package:offline_classes/widget/custom_textfield.dart';
import 'package:sizer/sizer.dart';

import '../../../global_data/GlobalData.dart';
import '../../../global_data/student_global_data.dart';
import '../../../global_data/teacher_global_data.dart';

class NoticeScreen extends StatelessWidget {
  NoticeScreen({super.key, required this.isVisible, this.type = "all"});
  final bool isVisible;
  final String type;

  Future<void> getNotice() async {
    String url = (GlobalData.role == 'student')
        ? "${GlobalData.baseUrl}/studentnotice?authKey=${GlobalData.auth1}&student_id=${GlobalStudent.id}"
        : "${GlobalData.baseUrl}/studentnotice?authKey=${GlobalData.auth1}&teacher_id=${GlobalTeacher.id}";
    print(url);
    final http.Response response = await http.get(Uri.parse(url));
    notice = json.decode(response.body);
    if (response.statusCode == 200) {
      print("done noice");
      print(notice);
    } else {
      print("Unsuccessful");
    }
  }

  Map<String, dynamic> notice = {};

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: customAppbar2(context, 'Notice'),
      body: FutureBuilder(
        future: getNotice(),
        builder: (context, snapshot) {
          if (notice.isEmpty) {
            return SizedBox(
              width: 0.1,
              height: 0.1,
            );
          } else {
            return Center(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    addVerticalSpace(1.h),
                    Center(
                      child: Text(
                        GlobalData.role == 'student'
                            ? 'Notices From Teachers'
                            : 'Notices',
                        style: kBodyText18wBold(black),
                      ),
                    ),
                    Visibility(
                      visible: false,
                      child: Center(
                        child: Text(
                          'For All Students',
                          style: kBodyText18wBold(black),
                        ),
                      ),
                    ),
                    notice["data"].length == 0
                        ? const Center(
                            child: Text('No notices yet'),
                          )
                        : ListView.builder(
                            itemCount: notice["data"].length,
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            itemBuilder: (ctx, i) {
                              return Container(
                                margin: EdgeInsets.all(1.h),
                                width: 93.w,
                                decoration: k3DboxDecoration(42),
                                padding: EdgeInsets.only(
                                    left: 9.w,
                                    right: 5.w,
                                    top: 2.h,
                                    bottom: 2.h),
                                child: Column(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      notice["data"][i]['title'],
                                      style: kBodyText18wNormal(black),
                                    ),
                                    Text(
                                      notice["data"][i]['dt'],
                                      style: kBodyText14w500(textColor),
                                    ),
                                    addVerticalSpace(1.h),
                                    Text(
                                      notice["data"][i]['noticedesc'],
                                      style: kBodyText14w500(black),
                                    )
                                  ],
                                ),
                              );
                            },
                          ),
                    Visibility(
                      visible: GlobalData.role == 'teacher',
                      child: Column(
                        children: [
                          /* // Center(
                          //   child: Text(
                          //     'For Specific Students',
                          //     style: kBodyText18wBold(black),
                          //   ),
                          // ),
                          notice["foryou"].length == 0
                              ? const Center(
                                  child: Text('No notices yet'),
                                )
                              : ListView.builder(
                                  itemCount: notice["foryou"].length,
                                  shrinkWrap: true,
                                  physics: const NeverScrollableScrollPhysics(),
                                  itemBuilder: (ctx, i) {
                                    return Container(
                                      margin: EdgeInsets.all(1.h),
                                      width: 93.w,
                                      decoration: k3DboxDecoration(42),
                                      padding: EdgeInsets.only(
                                          left: 9.w,
                                          right: 5.w,
                                          top: 2.h,
                                          bottom: 2.h),
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceEvenly,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            notice["foryou"][i]['title'],
                                            style: kBodyText18wNormal(black),
                                          ),
                                          Text(
                                            notice["foryou"][i]['dt'],
                                            style: kBodyText14w500(textColor),
                                          ),
                                          addVerticalSpace(1.h),
                                          Text(
                                            notice["foryou"][i]['noticedesc'],
                                            style: kBodyText14w500(black),
                                          )
                                        ],
                                      ),
                                    );
                                  },
                                ),*/
                        ],
                      ),
                    )
                  ],
                ),
              ),
            );
          }
        },
      ),
      bottomNavigationBar: Visibility(
        visible: isVisible,
        child: Padding(
          padding: const EdgeInsets.all(15.0),
          child: CustomButton(
            text: 'Add Notice',
            onTap: () {
              nextScreen(context, AddNoticeScreen(type: type));
            },
          ),
        ),
      ),
    );
  }
}

class AddNoticeScreen extends StatefulWidget {
  AddNoticeScreen({super.key, required this.type, this.student_id = -1});

  final String type;
  int student_id;

  @override
  State<AddNoticeScreen> createState() => _AddNoticeScreenState();
}

class _AddNoticeScreenState extends State<AddNoticeScreen> {
  bool showSpinner = false;

  Future<void> postNotice() async {
    setState(() {
      showSpinner = false;
    });
    String url = (widget.type == 'foryou')
        ? "${GlobalData.baseUrl}/addnotice?authKey=${GlobalData.auth1}&discription=${description.text}&teacher_id=${GlobalTeacher.id}&title=${title.text}&student_id=${widget.student_id}"
        : "${GlobalData.baseUrl}/addnotice?authKey=${GlobalData.auth1}&discription=${description.text}&teacher_id=${GlobalTeacher.id}&title=${title.text}";
    final http.Response response = await http.get(Uri.parse(url));
    var notice = json.decode(response.body);
    if (response.statusCode == 200) {
      print("done noice");
      if (notice.length != 0) {
        if (notice["Message"] == "Notice added successfully") {
          Get.snackbar(
            "Success",
            "Notice added",
            backgroundColor: Colors.green.withOpacity(0.65),
          );
        }
      }
      print(notice);
    } else {
      Get.snackbar(
        "Error",
        "Try again later",
        backgroundColor: Colors.red.withOpacity(0.65),
      );
      print("Unsuccessful");
    }
    setState(() {
      showSpinner = false;
    });
  }

  TextEditingController title = TextEditingController();

  TextEditingController description = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return ModalProgressHUD(
      inAsyncCall: showSpinner,
      child: Scaffold(
        appBar: customAppbar2(context, 'Add Notice'),
        body: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Column(
            children: [
              addVerticalSpace(2.h),
              CustomTextfield(
                hintext: 'Title',
                controller: title,
              ),
              addVerticalSpace(3.h),
              CustomTextfieldMaxLine(
                hintext: 'Description',
                controller: description,
              ),
              const Spacer(),
              CustomButton(
                text: 'Post',
                onTap: () {
                  if (title.text.isNotEmpty && description.text.isNotEmpty) {
                    postNotice();
                  } else {
                    Get.snackbar(
                      "All fields are mandatory",
                      "",
                      backgroundColor: Colors.red.withOpacity(0.65),
                    );
                  }
                },
              )
            ],
          ),
        ),
      ),
    );
  }
}
