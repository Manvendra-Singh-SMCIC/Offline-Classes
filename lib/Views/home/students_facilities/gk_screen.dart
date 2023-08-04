import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:offline_classes/model/statics_list.dart';
import 'package:offline_classes/utils/constants.dart';
import 'package:offline_classes/utils/my_appbar.dart';
import 'package:sizer/sizer.dart';

import '../../../global_data/GlobalData.dart';
import '../../../global_data/student_global_data.dart';

class GKScreen extends StatelessWidget {
  GKScreen({super.key});

  // Future<void> getGK() async {
  //   log("${GlobalData.baseUrl}/gk?authKey=${GlobalData.auth1}&student_id=${GlobalStudent.id}");
  //   final http.Response response = await http.get(Uri.parse(
  //       "${GlobalData.baseUrl}/gk?authKey=${GlobalData.auth1}&student_id=${GlobalStudent.id}"));
  //   if (response.statusCode == 200) {
  //     log("Code = " + response.statusCode.toString());
  //     log(json.decode(response.body));
  //     try {
  //       gk = await json.decode(response.body);
  //       if (response.statusCode == 200) {
  //         log(gk.toString());
  //       } else {
  //         print("Unsuccessful");
  //       }
  //     } catch (e) {
  //       print("Unsuccessful");
  //     }
  //   } else {
  //     log(response.statusCode.toString());
  //   }
  // }

  Future<void> getGk() async {
    final http.Response response = await http.get(Uri.parse(
        "${GlobalData.baseUrl}/gk?authKey=${GlobalData.auth1}&student_id=${GlobalStudent.id}"));
    try {
      gk = json.decode(response.body);
      if (response.statusCode == 200) {
        print(gk);
      } else {
        print("Unsuccessful");
      }
    } catch (e) {
      print("Unsuccessful");
    }
  }

  Map<String, dynamic> gk = {};

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: customAppbar2(context, 'General Knowledge'),
      body: FutureBuilder(
        future: getGk(),
        builder: (context, snapshot) {
          if (gk.isEmpty) {
            return const Center(
                child: CircularProgressIndicator(color: primary2));
          } else {
            return Scaffold(
              body: PageView.builder(
                itemCount: 2,
                itemBuilder: (context, index) {
                  var map = index == 0 ? gk["allgk"] : gk["foryou"];
                  return SingleChildScrollView(
                    child: Column(
                      children: [
                        addVerticalSpace(1.h),
                        Center(
                          child: Text(
                            index == 0 ? 'For All Classes' : 'For You',
                            style: kBodyText18wBold(black),
                          ),
                        ),
                        ListView.builder(
                          itemCount: map.length,
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemBuilder: (ctx, i) {
                            return Container(
                              margin: EdgeInsets.all(1.h),
                              width: 93.w,
                              decoration: k3DboxDecoration(42),
                              padding: EdgeInsets.only(
                                  left: 9.w, right: 5.w, top: 2.h, bottom: 2.h),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Text(
                                    map[i]["tittle"],
                                    style: kBodyText18wNormal(black),
                                  ),
                                  Center(
                                    child: map[i]["image"] != null
                                        ? ClipRRect(
                                            borderRadius:
                                                const BorderRadius.all(
                                                    Radius.circular(25)),
                                            child: ClipRRect(
                                              borderRadius:
                                                  const BorderRadius.all(
                                                      Radius.circular(25)),
                                              child: Image.network(
                                                GlobalStudent.urlPrefix +
                                                    map[i]["image"],
                                                fit: BoxFit.cover,
                                              ),
                                            ),
                                          )
                                        : Container(height: 1, width: 1),
                                  ),
                                  addVerticalSpace(1.h),
                                  Text(
                                    map[i]["disc"],
                                    style: kBodyText14w500(black),
                                  )
                                ],
                              ),
                            );
                          },
                        ),
                        Visibility(
                          visible: map.length == 0,
                          child: Container(
                            margin: EdgeInsets.all(1.h),
                            width: 93.w,
                            decoration: k3DboxDecoration(42),
                            padding: EdgeInsets.only(
                                left: 9.w, right: 5.w, top: 2.h, bottom: 2.h),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Text(
                                  "Content will be uploaded soon.",
                                  style: kBodyText18wNormal(black),
                                ),
                              ],
                            ),
                          ),
                        ),
                        addVerticalSpace(2.h),
                      ],
                    ),
                  );
                },
              ),
            );
          }
        },
      ),
    );
  }
}
