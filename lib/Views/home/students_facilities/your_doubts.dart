// ignore_for_file: use_build_context_synchronously, prefer_interpolation_to_compose_strings

import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:get/get.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:offline_classes/utils/constants.dart';
import 'package:offline_classes/utils/my_appbar.dart';
import 'package:offline_classes/widget/image_opener.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sizer/sizer.dart';
import 'package:http/http.dart' as http;
import '../../../global_data/GlobalData.dart';
import '../../../global_data/student_global_data.dart';

class YourDoubts extends StatelessWidget {
  YourDoubts({super.key, required this.teacher_id});
  final int teacher_id;

  Future<void> getDoubts() async {
    log("${GlobalData.baseUrl}/studentDoubt?authKey=${GlobalData.auth1}&student_id=${GlobalStudent.id}&teacher_id=$teacher_id");
    final http.Response response = await http.get(Uri.parse(
        "${GlobalData.baseUrl}/studentDoubt?authKey=${GlobalData.auth1}&student_id=${GlobalStudent.id}&teacher_id=$teacher_id"));
    mydoubts = json.decode(response.body);
    if (response.statusCode == 200) {
      print(mydoubts);
    } else {
      print("Unsuccessful");
    }
  }

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

  Map<String, dynamic> mydoubts = {};

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: customAppbar2(context, 'Your Doubts'),
      body: FutureBuilder(
        future: getDoubts(),
        builder: (context, snapshot) {
          if (mydoubts.isEmpty) {
            return Center(child: CircularProgressIndicator(color: primary2));
          } else {
            return mydoubts["data"].length == 0
                ? const Center(
                    child: Text('No Doubts Yet'),
                  )
                : Column(
                    children: [
                      Expanded(
                        child: ListView.builder(
                            itemCount: mydoubts["data"].length,
                            itemBuilder: (ctx, i) {
                              return InkWell(
                                onTap: () async {
                                  Get.snackbar(
                                    "Opening Image",
                                    "Please wait",
                                    backgroundColor:
                                        Colors.white.withOpacity(0.65),
                                  );
                                  var imageUrl = GlobalStudent.urlPrefix +
                                      mydoubts["data"][i]["file"];
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
                                  margin: EdgeInsets.all(10),
                                  padding: EdgeInsets.all(8),
                                  decoration: k3DboxDecoration(32),
                                  child: ListTile(
                                    leading: SizedBox(
                                      height: 4.h,
                                      child: imageNetwork(
                                        '${GlobalStudent.urlPrefix}${mydoubts["data"][i]["file"]}',
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                    title: Text(
                                      "Doubt ${i + 1}",
                                      style: kBodyText18wNormal(black),
                                    ),
                                    subtitle: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(mydoubts["data"][i]["dt"]),
                                        Text("Title: " +
                                            mydoubts["data"][i]["tittle"]),
                                        Text("Desc: " +
                                            mydoubts["data"][i]["desc"]),
                                      ],
                                    ),
                                  ),
                                ),
                              );
                            }),
                      )
                    ],
                  );
          }
        },
      ),
    );
  }
}

class SelectTeacherForDoubtShow extends StatefulWidget {
  const SelectTeacherForDoubtShow({super.key});

  @override
  State<SelectTeacherForDoubtShow> createState() =>
      _SelectTeacherForDoubtShowState();
}

class _SelectTeacherForDoubtShowState extends State<SelectTeacherForDoubtShow> {
  bool showSpinner = false;

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
      appBar: customAppbar2(context, 'Select Teachers'),
      body: FutureBuilder(
        future: getTeacherList(),
        builder: (context, snapshot) {
          if (teacherList.isEmpty) {
            return Center(child: CircularProgressIndicator(color: primary2));
          } else {
            return teacherList["data"].length == 0
                ? const Center(
                    child: Text('Teachers will be assigned soon'),
                  )
                : Column(
                    children: [
                      addVerticalSpace(10),
                      Expanded(
                        child: ListView.builder(
                          itemCount: teacherList["data"].length,
                          itemBuilder: (ctx, i) {
                            return InkWell(
                              onTap: () {
                                nextScreen(
                                    context,
                                    YourDoubts(
                                        teacher_id: teacherList["data"][i]
                                            ["id"]));
                              },
                              child: Container(
                                margin: EdgeInsets.all(10),
                                padding: EdgeInsets.all(12),
                                // height: 12.h,
                                width: 93.w,
                                decoration: kGradientBoxDecoration(
                                    35, purpleGradident()),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Container(
                                      height: 11.h,
                                      width: 25.w,
                                      decoration: kGradientBoxDecoration(
                                          18, orangeGradient()),
                                      child: ClipRRect(
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(12)),
                                        child: imageNetwork(
                                          GlobalStudent.urlPrefix +
                                              teacherList["data"][i]["image"],
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                    ),
                                    addHorizontalySpace(width(context) * 0.06),
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceEvenly,
                                      children: [
                                        SingleChildScrollView(
                                          scrollDirection: Axis.horizontal,
                                          child: Text(
                                            teacherList["data"][i]["name"],
                                            style: kBodyText22bold(white),
                                          ),
                                        ),
                                        addVerticalSpace(10),
                                        Text(
                                          teacherList["data"][i]["subject"],
                                          style: kBodyText18wNormal(white),
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
