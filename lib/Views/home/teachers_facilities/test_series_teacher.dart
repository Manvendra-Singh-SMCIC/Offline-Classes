// ignore_for_file: prefer_const_constructors

import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:get/get.dart';
import 'package:offline_classes/utils/my_appbar.dart';
import 'package:offline_classes/widget/custom_back_button.dart';
import 'package:offline_classes/widget/image_opener.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sizer/sizer.dart';
import 'package:dio/dio.dart';
import 'package:http/http.dart' as http;
import 'package:url_launcher/url_launcher.dart';
import '../../../global_data/GlobalData.dart';
import '../../../global_data/teacher_global_data.dart';
import '../../../utils/constants.dart';

class TestSeriesForTeacher extends StatelessWidget {
  TestSeriesForTeacher(
      {super.key, required this.title, required this.student_id});
  final String title;
  final int student_id;

  Future<File> convertImageUrlToFile(String imageUrl) async {
    var response = await http.get(Uri.parse(imageUrl));
    var filePath =
        await _localPath(); // Function to get the local directory path
    var fileName = imageUrl.split('/').last;

    File file = File('$filePath/$fileName');
    await file.writeAsBytes(response.bodyBytes);

    return file;
  }

  Future<String> _localPath() async {
    // Function to get the local directory path
    var directory = await getTemporaryDirectory();
    return directory.path;
  }

  _getFilePath(String fileName) async {
    final dir = await getApplicationDocumentsDirectory();
    return "${dir.path}/$fileName";
  }

  Future<void> getTests() async {
    log("${GlobalData.baseUrl}/teacherTestShow?authKey=${GlobalData.auth1}&teacher_id=${GlobalTeacher.id}&student_id=${student_id}");
    final http.Response response = await http.get(Uri.parse(
        "${GlobalData.baseUrl}/teacherTestShow?authKey=${GlobalData.auth1}&teacher_id=${GlobalTeacher.id}&student_id=${student_id}"));
    myTest = json.decode(response.body);
    log(response.statusCode.toString());
    if (response.statusCode == 200) {
      log(myTest.toString());
    } else {
      print("Unsuccessful");
    }
  }

  Map<String, dynamic> myTest = {};

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: customAppbar2(context, title),
      body: FutureBuilder(
        future: getTests(),
        builder: (context, snapshot) {
          if (myTest.isEmpty) {
            return Center(child: nullWidget());
          } else {
            return Column(
              children: [
                Visibility(
                  visible: myTest["data"].length == 0,
                  child: Text(
                    "No tests uploaded yet.",
                    style: kBodyText16wBold(primary2),
                  ),
                ),
                Expanded(
                  child: ListView.builder(
                    itemCount: myTest["data"].length,
                    itemBuilder: (ctx, index) {
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
                                      myTest["data"][index]["title"],
                                      style: kBodyText20wBold(white),
                                    ),
                                  ),
                                ),
                                Spacer(),
                                addHorizontalySpace(5.w),
                              ],
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: List.generate(2, (indexs) {
                                return GestureDetector(
                                  onTap: () async {
                                    Get.snackbar(
                                      "Downloading Document",
                                      "Please wait",
                                      backgroundColor:
                                          Colors.white.withOpacity(0.65),
                                    );

                                    try {
                                      Dio dio = Dio();
                                      String fileName = (indexs == 1
                                              ? myTest["data"][index]["answer"]
                                              : myTest["data"][index]
                                                  ["questions"])
                                          .toString();
                                      String url = "https://trusir.com/" +
                                          (indexs == 1
                                              ? myTest["data"][index]["answer"]
                                              : myTest["data"][index]
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

                                      // var response = await http.get(Uri.parse(
                                      // "https://trusir.com/" +
                                      //     (indexs == 1
                                      //         ? myTest["data"][index]
                                      //             ["answer"]
                                      //         : myTest["data"][index]
                                      //             ["questions"])));
                                    } catch (e) {
                                      print('Error downloading file: $e');
                                    }
                                    // try {
                                    //   var response = await http.get(Uri.parse(
                                    // "https://trusir.com/" +
                                    //     (indexs == 1
                                    //         ? myTest["data"][index]
                                    //             ["answer"]
                                    //         : myTest["data"][index]
                                    //             ["questions"])));
                                    //   var directory =
                                    //       await getApplicationDocumentsDirectory();
                                    //   var savePath =
                                    //       '${directory.path}/${(indexs == 1 ? myTest["data"][index]["answer"] : myTest["data"][index]["questions"])}';
                                    //   var file = File(savePath);
                                    //   await file
                                    //       .writeAsBytes(response.bodyBytes);
                                    //   print(
                                    //       'File downloaded and saved to: $savePath');
                                    // } catch (e) {
                                    //   print('Error downloading file: $e');
                                    // }

                                    // openFile(
                                    //   "https://trusir.com/" +
                                    //       (indexs == 1
                                    //           ? myTest["data"][index]
                                    //               ["answer"]
                                    //           : myTest["data"][index]
                                    //               ["questions"]),
                                    //   (indexs == 1
                                    //       ? myTest["data"][index]["answer"]
                                    //       : myTest["data"][index]
                                    //           ["questions"]),
                                    // );
                                  },
                                  child: Container(
                                    margin: EdgeInsets.only(right: 10, top: 3),
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
                    },
                  ),
                )
              ],
            );
          }
        },
      ),
    );
  }
}
