import 'dart:convert';
import 'dart:io';
import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http_parser/http_parser.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:http/http.dart' as http;
import 'package:offline_classes/global_data/student_global_data.dart';
import 'package:offline_classes/utils/my_appbar.dart';
import 'package:offline_classes/widget/custom_textfield.dart';
import 'package:offline_classes/widget/image_opener.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sizer/sizer.dart';
import '../../../global_data/GlobalData.dart';
import '../../../global_data/teacher_global_data.dart';
import '../../../utils/constants.dart';
import '../../../widget/custom_button.dart';
import '../../enquiry_registrations/error_screen.dart';

class AppProgressReport extends StatefulWidget {
  const AppProgressReport(
      {super.key, required this.student_id, required this.test_id});

  // ignore: non_constant_identifier_names
  final int student_id;
  final int test_id;

  @override
  State<AppProgressReport> createState() => _AppProgressReportState();
}

class _AppProgressReportState extends State<AppProgressReport> {
  TextEditingController tfMarks = TextEditingController();
  TextEditingController tfTotalMarks = TextEditingController();

  bool showSpinner = false;

  File? image;

  Future<void> postData() async {
    setState(() {
      showSpinner = true;
    });

    print("Test" + widget.test_id.toString());
    var uri = Uri.parse("${GlobalData.baseUrl}/progressReportpost?");

    var request = http.MultipartRequest('POST', uri);

    request.fields['authKey'] = GlobalData.auth1;
    request.fields['student_id'] = widget.student_id.toString();
    request.fields['test_id'] = widget.test_id.toString();
    request.fields['teacher_id'] = GlobalTeacher.id.toString();
    request.fields['obtainMarks'] = tfMarks.text.toString().trim();
    request.fields['totalMarks'] = tfTotalMarks.text.toString().trim();

    var multiPart;

    if (image != null) {
      var stream = http.ByteStream(image!.openRead());
      stream.cast();
      var len = await image!.length();
      multiPart = http.MultipartFile(
        'image',
        () async* {
          yield* image!.openRead();
        }(),
        len,
        filename: image!.path,
      );
      request.files.add(multiPart);
    }

    try {
      http.StreamedResponse response;

      Future.delayed(Duration(seconds: 6), () async {});
      response = await request.send();

      log(response.toString());

      if (response.statusCode == 200) {
        var httpResponse = await http.Response.fromStream(response);
        Map<String, dynamic> jsonResponse = json.decode(httpResponse.body);
        print(jsonResponse);
        String msg = jsonResponse["Message"].toString();
        if (msg == "Report add successfully") {
          setState(() {
            showSpinner = false;
            Get.snackbar(
              "Done",
              "Report Sent",
              backgroundColor: Colors.green.withOpacity(0.65),
            );
          });
        } else {
          setState(() {
            showSpinner = false;
          });
          nextScreen(context, ErrorScreen(message: msg));
        }
      } else {
        setState(() {
          showSpinner = false;
        });
        Get.snackbar(
          "Error",
          "Try again",
          backgroundColor: Colors.red.withOpacity(0.65),
        );
        print('API request failed with status code ${response.statusCode}');
      }
    } catch (e) {
      Get.snackbar(
        "Error",
        "Try again",
        backgroundColor: Colors.red.withOpacity(0.65),
      );
      setState(() {
        showSpinner = false;
      });
      print('API request failed with exception: $e');
    }
    Get.snackbar(
      "Error",
      "Try again",
      backgroundColor: Colors.red.withOpacity(0.65),
    );
    setState(() {
      showSpinner = false;
    });
  }

  ImagePicker picker = ImagePicker();

  @override
  Widget build(BuildContext context) {
    return ModalProgressHUD(
      inAsyncCall: showSpinner,
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: PreferredSize(
          preferredSize: const Size.fromHeight(60),
          child: AppBar(
            backgroundColor: white,
            foregroundColor: black,
            elevation: 0,
            leading: Container(
              margin: EdgeInsets.all(3),
              padding: EdgeInsets.symmetric(horizontal: 8),
              height: 50,
              width: 50,
              decoration: BoxDecoration(
                gradient: orangeGradient(),
                borderRadius: BorderRadius.all(Radius.circular(15)),
              ),
              child: Center(
                child: IconButton(
                    onPressed: () {
                      goBack(context);
                    },
                    icon: const Icon(
                      Icons.arrow_back_ios,
                      color: white,
                    )),
              ),
            ),
            title: Text(
              "Post a Report",
              style: kBodyText20wBold(primary),
            ),
          ),
        ),
        body: SingleChildScrollView(
          child: Center(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                addVerticalSpace(20),
                CustomTextfield(
                  hintext: 'Marks Obtained',
                  controller: tfMarks,
                  keyBoardType: TextInputType.number,
                ),
                addVerticalSpace(20),
                CustomTextfield(
                  hintext: 'Total Marks',
                  controller: tfTotalMarks,
                  keyBoardType: TextInputType.number,
                ),
                addVerticalSpace(20),
                InkWell(
                  onTap: () async {
                    final pickedFile = await picker.pickImage(
                      source: ImageSource.gallery,
                      imageQuality: 80,
                    );

                    if (pickedFile != null) {
                      File img = File(pickedFile.path);
                      image = img;
                      Get.snackbar(
                        "Success",
                        "Image Selected",
                        backgroundColor: Colors.green.withOpacity(0.65),
                      );
                    } else {
                      Get.snackbar(
                        "Error",
                        "Image Not Selected",
                        backgroundColor: Colors.red.withOpacity(0.65),
                      );
                      print("No image selected");
                    }
                    setState(() {});
                  },
                  child: Container(
                    padding: EdgeInsets.only(left: 33, top: 5),
                    height: 9.h,
                    width: width(context) * 0.93,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(40),
                      boxShadow: [
                        const BoxShadow(
                          color: textColor,
                          offset: Offset(0, 3),
                        ),
                        BoxShadow(
                          color: white.withOpacity(0.95),
                          // spreadRadius: -2.0,
                          blurRadius: 7.0,
                        ),
                      ],
                    ),
                    child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Icon(
                            Icons.upload,
                            size: 30,
                            color: image == null
                                ? Color(0xffA4A4A4)
                                : Colors.transparent,
                          ),
                          Text(
                            image == null ? 'Upload Image' : 'Uploaded',
                            style: kBodyText14w500(Color(0xffA4A4A4)),
                          )
                        ]),
                  ),
                ),
                addVerticalSpace(40),
              ],
            ),
          ),
        ),
        bottomNavigationBar: Visibility(
          visible: true,
          child: Padding(
            padding: const EdgeInsets.all(15.0),
            child: CustomButton(
                text: 'Send Report',
                onTap: () {
                  if (tfMarks.text.isNotEmpty &&
                      tfTotalMarks.text.isNotEmpty &&
                      image != null) {
                    postData();
                  } else {
                    if (tfMarks.text.isEmpty &&
                        tfTotalMarks.text.isEmail &&
                        image == null) {
                      Get.snackbar(
                        "All fields are mandatory",
                        "Please fill all the fields",
                        backgroundColor: Colors.red.withOpacity(0.65),
                      );
                    } else if (tfMarks.text.isEmpty ||
                        tfTotalMarks.text.isEmail) {
                      Get.snackbar(
                        "All fields are mandatory",
                        "Please fill marks details",
                        backgroundColor: Colors.red.withOpacity(0.65),
                      );
                    } else {
                      Get.snackbar(
                        "Image is required",
                        "Please upload report image",
                        backgroundColor: Colors.red.withOpacity(0.65),
                      );
                    }
                  }
                }),
          ),
        ),
      ),
    );
  }
}

class AppProgressReportList extends StatelessWidget {
  AppProgressReportList({super.key, required this.student_id});

  final int student_id;

  Future<void> getStudents() async {
    final http.Response response = await http.get(Uri.parse(
        "${GlobalData.baseUrl}/CourseTests?authKey=${GlobalData.auth1}&teacher_id=${GlobalTeacher.id}"));
    courseTests = json.decode(response.body);
    if (response.statusCode == 200) {
      print(courseTests);
    } else {
      print("Unsuccessful");
    }
  }

  Map<String, dynamic> courseTests = {};

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: getStudents(),
      builder: (context, snapshot) {
        if (courseTests.isEmpty) {
          return const Center(
              child: CircularProgressIndicator(color: primary2));
        } else {
          return Scaffold(
            appBar: customAppbar2(context, 'Course List'),
            body: Column(
              children: [
                Expanded(
                  child: ListView.builder(
                    itemCount: courseTests["test"].length,
                    itemBuilder: (ctx, i) {
                      return InkWell(
                        onTap: () {
                          nextScreen(
                            context,
                            AppProgressReport(
                              student_id: student_id,
                              test_id: courseTests["test"][i]["id"],
                            ),
                          );
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
                                child: Image.asset('assets/images/test.png'),
                              ),
                              addHorizontalySpace(width(context) * 0.06),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    courseTests["test"][i]["chapter"],
                                    style: kBodyText20wBold(white),
                                  ),
                                  addVerticalSpace(10),
                                  SingleChildScrollView(
                                    scrollDirection: Axis.horizontal,
                                    child: Text(
                                      "Scheduled: ${courseTests["test"][i]["shadule_date"]}",
                                      style: kBodyText12wNormal(grey),
                                    ),
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
            ),
          );
        }
      },
    );
  }
}
