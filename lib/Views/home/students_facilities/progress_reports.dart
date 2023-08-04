// ignore_for_file: use_build_context_synchronously

import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:offline_classes/Views/home/students_facilities/view_progress_report.dart';
import 'package:offline_classes/utils/my_appbar.dart';
import 'package:offline_classes/widget/custom_button.dart';
import 'package:offline_classes/widget/image_opener.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sizer/sizer.dart';

import '../../../global_data/GlobalData.dart';
import '../../../global_data/student_global_data.dart';
import '../../../utils/constants.dart';

class ProgressReports extends StatelessWidget {
  ProgressReports({super.key});

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

  Future<void> getProgress() async {
    final http.Response response = await http.get(Uri.parse(
        "${GlobalData.baseUrl}/progressReport?authKey=${GlobalData.auth1}&student_id=${GlobalStudent.id}"));
    try {
      progress = json.decode(response.body);
      if (response.statusCode == 200) {
        print(progress);
      } else {
        print("Unsuccessful");
      }
    } catch (e) {
      print("Unsuccessful");
    }
  }

  Map<String, dynamic> progress = {};

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: customAppbar2(context, 'Progress Report'),
      body: FutureBuilder(
        future: getProgress(),
        builder: (context, snapshot) {
          if (progress.isEmpty) {
            return const Center(
                child: CircularProgressIndicator(color: primary2));
          } else {
            return SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  InkWell(
                    onTap: () {},
                    child: Container(
                      margin: EdgeInsets.all(10),
                      padding: EdgeInsets.all(12),
                      // height: 12.h,
                      width: 93.w,
                      decoration: kGradientBoxDecoration(35, purpleGradident()),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'View Your Report',
                                style: kBodyText16wBold(white),
                              ),
                              Text(
                                'See your Progress',
                                style: kBodyText14wNormal(white),
                              ),
                              addVerticalSpace(10),
                            ],
                          ),
                          Spacer(),
                          Container(
                            height: 13.h,
                            child: Image.asset('assets/images/report.png'),
                          )
                        ],
                      ),
                    ),
                  ),
                  addVerticalSpace(3.h),
                  Text(
                    'My Reports',
                    style: kBodyText18wBold(black),
                  ),
                  addVerticalSpace(1.h),
                  progress["data"].length == 0
                      ? Column(
                          children: [
                            addVerticalSpace(20),
                            Text(
                              'No reports to show',
                              style: kBodyText12wBold(black),
                            ),
                          ],
                        )
                      : ListView.builder(
                          shrinkWrap: true,
                          itemCount: progress["data"].length,
                          physics: const NeverScrollableScrollPhysics(),
                          itemBuilder: (ctx, i) {
                            return Container(
                              margin: EdgeInsets.all(10),
                              padding: EdgeInsets.only(
                                  left: 8.w, right: 12, top: 2.h, bottom: 2.h),
                              // height: 16.h,
                              width: width(context) * 0.93,
                              decoration: k3DboxDecoration(35),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        progress["data"][i]["course_name"],
                                        style: kBodyText18wNormal(black),
                                      ),
                                      Text(
                                        progress["data"][i]["dt"].substring(
                                            0,
                                            progress["data"][i]["dt"]
                                                .indexOf(' ')),
                                        style: kBodyText12wBold(textColor),
                                      ),
                                      addVerticalSpace(1.2.h),
                                      SizedBox(
                                        width: width(context) * 0.55,
                                        child: Text(
                                          'Total Marks Obtained: ${progress["data"][i]["obtain_marks"]}/${progress["data"][i]["total_marks"]}',
                                          style: kBodyText12wNormal(black),
                                        ),
                                      ),
                                    ],
                                  ),
                                  Spacer(),
                                  InkWell(
                                    onTap: () async {
                                      var imageUrl = GlobalStudent.urlPrefix +
                                          progress["data"][i]["file"];
                                      File imageFile =
                                          await convertImageUrlToFile(imageUrl);
                                      nextScreen(
                                        context,
                                        ImageOpener(
                                          imageFile: imageFile,
                                          showOnly: true,
                                          send: false,
                                        ),
                                      );
                                    },
                                    child: Container(
                                      width: width(context) * 0.26,
                                      height: 4.h,
                                      decoration: kGradientBoxDecoration(
                                          40, greenGradient()),
                                      child: Center(
                                        child: Text(
                                          'View Report',
                                          style: kBodyText10wBold(white),
                                        ),
                                      ),
                                    ),
                                  )
                                ],
                              ),
                            );
                          },
                        )
                ],
              ),
            );
          }
        },
      ),
    );
  }
}
