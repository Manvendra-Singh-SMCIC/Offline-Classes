// ignore_for_file: prefer_const_constructors, non_constant_identifier_names, prefer_interpolation_to_compose_strings

import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:offline_classes/utils/my_appbar.dart';
import 'package:offline_classes/widget/custom_button.dart';
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sizer/sizer.dart';
import 'package:path/path.dart' as path;
import 'package:url_launcher/url_launcher.dart';

import '../../../global_data/GlobalData.dart';
import '../../../global_data/student_global_data.dart';
import '../../../utils/constants.dart';
import '../../../widget/custom_textfield.dart';
import '../../../widget/image_opener.dart';

class TestSeriesScreen extends StatefulWidget {
  const TestSeriesScreen({super.key});

  @override
  State<TestSeriesScreen> createState() => _TestSeriesScreenState();
}

class _TestSeriesScreenState extends State<TestSeriesScreen> {
  bool isPaperChecked = false;
  final ImagePicker _picker = ImagePicker();
  bool showSpinner = false;

  File? image;

  Future<void> getTest() async {
    final http.Response response = await http.get(Uri.parse(
        "${GlobalData.baseUrl}/courses?authKey=${GlobalData.auth1}&user_id=${GlobalStudent.id}&class=${GlobalStudent.specificProfile["data"][0]["class"]}&medium=${GlobalStudent.specificProfile["data"][0]["medium"]}"));
    if (response.statusCode == 200) {
      courses = json.decode(response.body);
      // log(courses.toString());
    } else {
      print("Unsuccessful");
    }
  }

  Future<void> getMyTest() async {
    final http.Response response = await http.get(Uri.parse(
        "${GlobalData.baseUrl}/testShow?authKey=${GlobalData.auth1}&student_id=${GlobalStudent.id}"));
    if (response.statusCode == 200) {
      myTest = json.decode(response.body);
      log(myTest.toString());
    } else {
      print("Unsuccessful");
    }
  }

  int touched = 0;

  Future<void> postData(
      int course_id, String title, File ques, File ans) async {
    setState(() {
      showSpinner = true;
    });

    if (ques != null && ans != null) {
      log("Yeah");
    }

    // var uri = Uri.parse("${GlobalData.baseUrl}/uploadTest?");
    var uri = Uri.parse("https://trusir.com/api/uploadTest");

    var request = http.MultipartRequest('POST', uri);
    var stream1 = http.ByteStream(ques.openRead());
    var stream2 = http.ByteStream(ans.openRead());
    stream1.cast();
    stream2.cast();
    var len1 = await ques.length();
    var len2 = await ans.length();

    request.fields['authKey'] = GlobalData.auth1;
    request.fields['student_id'] = GlobalStudent.id.toString();
    request.fields['title'] = title.toString();
    request.fields['course'] = course_id.toString();

    var multiPart1 = http.MultipartFile(
      'questions',
      () async* {
        yield* ques.openRead();
      }(),
      len1,
      filename: ques.path,
    );
    var multiPart2 = http.MultipartFile(
      'answers',
      () async* {
        yield* ans.openRead();
      }(),
      len2,
      filename: ans.path,
    );
    request.files.add(multiPart1);
    request.files.add(multiPart2);

    try {
      Future.delayed(Duration(seconds: 0), () async {});
      var response = await request.send();

      log('${response.statusCode}');

      if (response.statusCode == 200) {
        var httpResponse = await http.Response.fromStream(response);
        Map<String, dynamic> jsonResponse = json.decode(httpResponse.body);
        print(jsonResponse);
        String msg = jsonResponse["Message"].toString();
        if (msg == "Success") {
          setState(() {
            showSpinner = false;
            Get.snackbar(
              "Done",
              "Test Uploaded",
              backgroundColor: Colors.green.withOpacity(0.65),
            );
          });
        } else {
          setState(() {
            showSpinner = false;
          });
          // nextScreen(context, ErrorScreen(message: msg));
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
        String responseBody =
            await response.stream.transform(utf8.decoder).join();

        print('API request failed with status code ${response.statusCode}');
        print('API request failed with status code ${responseBody}');
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
    setState(() {
      showSpinner = false;
    });
  }

  Map<String, dynamic> courses = {};
  Map<String, dynamic> myTest = {};

  int ind = -1;
  String test_id = "-1";

  _getFilePath(String fileName) async {
    final dir = await getApplicationDocumentsDirectory();
    return "${dir.path}/$fileName";
  }

  @override
  Widget build(BuildContext context) {
    return ModalProgressHUD(
      inAsyncCall: showSpinner,
      child: Scaffold(
        appBar: customAppbar2(context, 'Test Series'),
        body: SingleChildScrollView(
          child: Column(
            children: [
              FutureBuilder(
                future: getTest(),
                builder: (context, snapshot) {
                  if (courses.isEmpty) {
                    return const Center(
                        child: CircularProgressIndicator(color: primary2));
                  } else {
                    return courses["data"].length == 0
                        ? const Center(
                            child: Text('Tests will soon be uploaded'),
                          )
                        : SingleChildScrollView(
                            child: Column(
                              children: [
                                addVerticalSpace(1.h),
                                ListView.builder(
                                  // itemCount: tests["data"].length,
                                  itemCount: 1,
                                  shrinkWrap: true,
                                  physics: const NeverScrollableScrollPhysics(),
                                  itemBuilder: (ctx, i) {
                                    File? ques;
                                    File? ans;
                                    TextEditingController title =
                                        TextEditingController();
                                    return Container(
                                      margin: EdgeInsets.only(bottom: 10),
                                      child: Column(
                                        children: [
                                          GestureDetector(
                                            onTap: () async {
                                              // FilePickerResult? result =
                                              //     await FilePicker.platform.pickFiles(
                                              //   allowMultiple: false,
                                              //   type: FileType.custom,
                                              //   allowedExtensions: [
                                              //     'pdf',
                                              //     'doc',
                                              //     'docx',
                                              //     'zip'
                                              //   ],
                                              // );

                                              // if (result != null &&
                                              //     result.files.isNotEmpty) {
                                              //   image =
                                              //       File(result.files.single.path!);
                                              //   // postData(
                                              //   //     courses["mycourse"][i]["course_name"]);

                                              //   // Do something with the picked document
                                              //   // For example, print the file path
                                              //   print(image!.path);
                                              // } else {}
                                            },
                                            child: Container(
                                              margin: EdgeInsets.all(10),
                                              padding: EdgeInsets.symmetric(
                                                  horizontal: 10.w,
                                                  vertical: 1.5.h),
                                              // height: 11.h,
                                              width: 93.w,
                                              decoration:
                                                  kGradientBoxDecoration(
                                                      35, purpleGradident()),
                                              // decoration: kFillBoxDecoration(0, Color(0xff48116a), 35),

                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceEvenly,
                                                children: [
                                                  Row(
                                                    children: [
                                                      SizedBox(
                                                        width: 60.w,
                                                        child:
                                                            SingleChildScrollView(
                                                          scrollDirection:
                                                              Axis.horizontal,
                                                          child: Text(
                                                            courses["mycourse"]
                                                                    [i]
                                                                ["course_name"],
                                                            style:
                                                                kBodyText24wBold(
                                                                    white),
                                                          ),
                                                        ),
                                                      ),
                                                      Spacer(),
                                                      addHorizontalySpace(5.w),
                                                    ],
                                                  ),
                                                  Text(
                                                    'Course started on: ${courses["mycourse"][i]["dt"].toString().substring(0, courses["mycourse"][i]["dt"].indexOf(" "))}',
                                                    style: kBodyText15wNormal(
                                                        white),
                                                  )
                                                ],
                                              ),
                                            ),
                                          ),
                                          addVerticalSpace(10),
                                          CustomTextfield(
                                              controller: title,
                                              hintext: 'Enter title'),
                                          addVerticalSpace(15),
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: List.generate(3, (ind) {
                                              return Container(
                                                margin: EdgeInsets.symmetric(
                                                    horizontal: 15),
                                                child: GestureDetector(
                                                  onTap: () async {
                                                    if (ind == 0 || ind == 1) {
                                                      FilePickerResult? result =
                                                          await FilePicker
                                                              .platform
                                                              .pickFiles(
                                                        allowMultiple: false,
                                                        type: FileType.custom,
                                                        allowedExtensions: [
                                                          'pdf',
                                                          'doc',
                                                          'docx',
                                                          'zip'
                                                        ],
                                                      );

                                                      if (result != null &&
                                                          result.files
                                                              .isNotEmpty) {
                                                        image = File(result
                                                            .files
                                                            .single
                                                            .path!);
                                                        if (ind == 0) {
                                                          ques = image;
                                                        } else {
                                                          ans = image;
                                                        }
                                                        image = null;
                                                      } else {
                                                        image = null;
                                                      }
                                                    } else {
                                                      if (ques != null &&
                                                          ans != null &&
                                                          title.text
                                                              .trim()
                                                              .isNotEmpty) {
                                                        log("44444");
                                                        print("IIIIIIIIIIIIIIDDDDDDDDDD" +
                                                            courses["mycourse"]
                                                                        [i][
                                                                    "course_id"]
                                                                .toString());
                                                        postData(
                                                            courses["mycourse"]
                                                                    [i]
                                                                ["course_id"],
                                                            title.text.trim(),
                                                            ques!,
                                                            ans!);
                                                      }
                                                      if (ques == null) {
                                                        Get.snackbar(
                                                          "Question not selected",
                                                          "Select a question to upload",
                                                          backgroundColor:
                                                              Colors.red
                                                                  .withOpacity(
                                                                      0.65),
                                                        );
                                                      }
                                                      if (ans == null) {
                                                        Get.snackbar(
                                                          "Answer not selected",
                                                          "Select answer to upload",
                                                          backgroundColor:
                                                              Colors.red
                                                                  .withOpacity(
                                                                      0.65),
                                                        );
                                                      }
                                                      if (title.text
                                                          .trim()
                                                          .isEmpty) {
                                                        Get.snackbar(
                                                          "Title not filled",
                                                          "Fill answer to upload",
                                                          backgroundColor:
                                                              Colors.red
                                                                  .withOpacity(
                                                                      0.65),
                                                        );
                                                      }
                                                    }
                                                  },
                                                  child: Container(
                                                    margin: EdgeInsets.all(3),
                                                    padding:
                                                        EdgeInsets.symmetric(
                                                            horizontal: 8),
                                                    height: 50,
                                                    width: 50,
                                                    decoration: BoxDecoration(
                                                      gradient:
                                                          orangeGradient(),
                                                      borderRadius:
                                                          BorderRadius.all(
                                                        Radius.circular(
                                                          15,
                                                        ),
                                                      ),
                                                    ),
                                                    child: Center(
                                                      child: Icon(
                                                        ind == 0
                                                            ? Icons
                                                                .question_mark_outlined
                                                            : ind == 1
                                                                ? Icons
                                                                    .assignment
                                                                : Icons.upload,
                                                        color: white,
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              );
                                            }),
                                          )
                                        ],
                                      ),
                                    );
                                  },
                                ),
                              ],
                            ),
                          );
                  }
                },
              ),
              addVerticalSpace(10),
              Text(
                "My Tests",
                style: kBodyText20wBold(black),
              ),
              addVerticalSpace(10),
              FutureBuilder(
                future: getMyTest(),
                builder: (context, snapshot) {
                  if (myTest.isEmpty) {
                    return const Center(
                      child: CircularProgressIndicator(
                        color: Colors.transparent,
                      ),
                    );
                  } else {
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: List.generate(myTest["test"].length, (index) {
                        return Container(
                          margin: EdgeInsets.all(10),
                          padding: EdgeInsets.symmetric(
                              horizontal: 10.w, vertical: 1.5.h),
                          // height: 11.h,
                          width: 93.w,
                          decoration:
                              kGradientBoxDecoration(35, purpleGradident()),
                          // decoration: kFillBoxDecoration(0, Color(0xff48116a), 35),

                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Row(
                                children: [
                                  SizedBox(
                                    width: 60.w,
                                    child: SingleChildScrollView(
                                      scrollDirection: Axis.horizontal,
                                      child: Text(
                                        myTest["test"][index]["title"],
                                        style: kBodyText20wBold(white),
                                      ),
                                    ),
                                  ),
                                  Spacer(),
                                  addHorizontalySpace(5.w),
                                ],
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: List.generate(2, (indexs) {
                                  return GestureDetector(
                                    onTap: () async {
                                      Get.snackbar(
                                        "Ddownloading Document",
                                        "Please wait",
                                        backgroundColor:
                                            Colors.white.withOpacity(0.65),
                                      );

                                      try {
                                        Dio dio = Dio();
                                        String fileName = (indexs == 1
                                                ? myTest["test"][index]
                                                    ["answer"]
                                                : myTest["test"][index]
                                                    ["questions"])
                                            .toString();
                                        String url = "https://trusir.com/" +
                                            (indexs == 1
                                                ? myTest["test"][index]
                                                    ["answer"]
                                                : myTest["test"][index]
                                                    ["questions"]);

                                        String path =
                                            await _getFilePath(fileName);

                                        await dio
                                            .download(
                                          url,
                                          path,
                                          deleteOnError: true,
                                        )
                                            .then((_) {
                                          Get.snackbar(
                                            "Downloaded",
                                            "Success",
                                            backgroundColor:
                                                Colors.green.withOpacity(0.65),
                                          );
                                          print("Done");
                                        }).catchError((err) {
                                          Get.snackbar(
                                            "Could not download file",
                                            "Error",
                                            backgroundColor:
                                                Colors.red.withOpacity(0.65),
                                          );
                                          print("Error");
                                        });
                                      } catch (e) {
                                        print('Error downloading file: $e');
                                      }
                                    },
                                    child: Container(
                                      margin:
                                          EdgeInsets.only(right: 10, top: 3),
                                      padding:
                                          EdgeInsets.symmetric(horizontal: 8),
                                      height: 50,
                                      width: 50,
                                      decoration: BoxDecoration(
                                        gradient: orangeGradient(),
                                        borderRadius: BorderRadius.all(
                                          Radius.circular(
                                            15,
                                          ),
                                        ),
                                      ),
                                      child: Center(
                                        child: Icon(
                                          indexs == 0
                                              ? Icons.question_mark_outlined
                                              : Icons.assignment,
                                          color: white,
                                        ),
                                      ),
                                    ),
                                  );
                                }),
                              )
                            ],
                          ),
                        );
                      }),
                    );
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  openFile(String url, String? fileName) async {
    File file = await downloadFile(url, fileName!);

    if (file == null) return;

    print("Path: ${file.path}");

    OpenFile.open(file.path);
  }

  downloadFile(String url, String name) async {
    final appStorage = await getApplicationDocumentsDirectory();
    final file = File('${appStorage.path}/$name');

    try {
      final response = await Dio().get(url,
          options: Options(
            responseType: ResponseType.bytes,
            followRedirects: false,
            receiveTimeout: Duration(seconds: 3),
          ));

      final raf = file.openSync(mode: FileMode.write);
      raf.writeFromSync(response.data);
      await raf.close();
      return file;
    } catch (e) {
      return null;
    }
  }
}
