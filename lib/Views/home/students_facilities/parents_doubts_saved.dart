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
import '../../../global_data/student_global_data.dart';
import '../../../utils/constants.dart';
import '../../../widget/image_opener.dart';

class ParentsDoubtsSaved extends StatefulWidget {
  const ParentsDoubtsSaved({super.key});

  @override
  State<ParentsDoubtsSaved> createState() => _ParentsDoubtsSavedState();
}

class _ParentsDoubtsSavedState extends State<ParentsDoubtsSaved> {
  Future<void> getDoubts() async {
    log("${GlobalData.baseUrl}/parantsDoubtshow?authKey=${GlobalData.auth1}&student_id=${GlobalStudent.id}");
    final http.Response response = await http.get(Uri.parse(
        "${GlobalData.baseUrl}/parantsDoubtshow?authKey=${GlobalData.auth1}&student_id=${GlobalStudent.id}"));
    parentDoubts = json.decode(response.body);
    if (response.statusCode == 200) {
      print(parentDoubts);
    } else {
      print("Unsuccessful");
    }
  }

  Map<String, dynamic> parentDoubts = {};

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: customAppbar2(context, 'Parents Doubts'),
      body: FutureBuilder(
        future: getDoubts(),
        builder: (context, snapshot) {
          if (parentDoubts.isEmpty) {
            return const Center(
                child: CircularProgressIndicator(color: primary2));
          } else {
            return parentDoubts["data"].length == 0
                ? const Center(
                    child: Text('No Doubts Uploaded'),
                  )
                : SingleChildScrollView(
                    child: Column(
                      children: [
                        ListView.builder(
                          itemCount: parentDoubts["data"].length,
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemBuilder: (ctx, i) {
                            return Container(
                              margin: EdgeInsets.all(1.h),
                              width: 93.w,
                              decoration: k3DboxDecoration(42),
                              padding: EdgeInsets.only(
                                  left: 9.w, right: 2.w, top: 2.h, bottom: 2.h),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    parentDoubts["data"][i]["title"],
                                    style: kBodyText18wNormal(black),
                                  ),
                                  Text(
                                    'Posted On: ${parentDoubts["data"][i]["dt"].substring(0, parentDoubts["data"][i]["dt"].indexOf(' '))}',
                                    style: kBodyText14w500(textColor),
                                  ),
                                  addVerticalSpace(1.h),
                                  Text(
                                    parentDoubts["data"][i]["disc"],
                                    style: kBodyText14w500(black),
                                  ),
                                  addVerticalSpace(1.h),
                                  GestureDetector(
                                    onTap: () async {
                                      if (parentDoubts["data"][i]["file"] !=
                                          null) {
                                        File? image;
                                        var imageUrl = GlobalStudent.urlPrefix +
                                            parentDoubts["data"][i]["file"];
                                        image = await convertImageUrlToFile(
                                            imageUrl);
                                        nextScreen(
                                            context,
                                            ImageOpener(
                                              send: false,
                                              showOnly: true,
                                              baseurl: GlobalStudent.urlPrefix,
                                              imageFile: image,
                                            ));
                                      }
                                    },
                                    child: Text(
                                      parentDoubts["data"][i]["file"] != null
                                          ? "Image"
                                          : "",
                                      style: kBodyText10wNormal(Colors.blue),
                                    ),
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
    );
  }
}
