// ignore_for_file: use_build_context_synchronously

import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:offline_classes/utils/my_appbar.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sizer/sizer.dart';
import 'package:http/http.dart' as http;
import '../../../global_data/GlobalData.dart';
import '../../../global_data/teacher_global_data.dart';
import '../../../utils/constants.dart';
import '../../../widget/image_opener.dart';

class ViewStudentDoubts extends StatelessWidget {
  ViewStudentDoubts({super.key, required this.title, required this.student_id});
  final String title;
  final int student_id;

  Future<void> getDoubts() async {
    final http.Response response = await http.get(Uri.parse(
        "${GlobalData.baseUrl}/studentDoubt?authKey=${GlobalData.auth1}&teacher_id=${GlobalTeacher.id}&student_id=${student_id}"));
    doubts = json.decode(response.body);
    if (response.statusCode == 200) {
      log(doubts.toString());
      log(student_id.toString());
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

  Map<String, dynamic> doubts = {};

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: customAppbar2(context, title),
      body: FutureBuilder(
        future: getDoubts(),
        builder: (context, snapshot) {
          if (doubts.isEmpty) {
            return const Center(
                child: CircularProgressIndicator(color: primary2));
          } else {
            return Column(
              children: [
                Expanded(
                  child: ListView.builder(
                      itemCount: doubts["data"].length,
                      itemBuilder: (ctx, i) {
                        return Container(
                          margin: EdgeInsets.all(10),
                          padding: EdgeInsets.all(8),
                          decoration: k3DboxDecoration(32),
                          child: ListTile(
                            leading: InkWell(
                              onTap: () async {
                                var imageUrl = GlobalTeacher.urlPrefix +
                                    doubts["data"][i]["file"];
                                File imageFile =
                                    await convertImageUrlToFile(imageUrl);
                                nextScreen(
                                    context,
                                    ImageOpener(
                                      imageFile: imageFile,
                                      showOnly: true,
                                      send: false,
                                    ));
                              },
                              child: SizedBox(
                                height: 4.h,
                                child: imageNetwork(
                                  "${GlobalTeacher.urlPrefix}${doubts["data"][i]["file"]}",
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                            title: Text(
                              "Doubt ${i + 1}",
                            ),
                            subtitle: Text(doubts["data"][i]["dt"].substring(
                                0, doubts["data"][i]["dt"].indexOf(' '))),
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
