import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:offline_classes/Views/enquiry_registrations/student_enquiry_form.dart';
import 'package:offline_classes/Views/enquiry_registrations/teacher_enquiry_form.dart';
import 'package:offline_classes/global_data/GlobalData.dart';
import 'package:offline_classes/global_data/student_global_data.dart';
import 'package:offline_classes/utils/constants.dart';
import 'package:offline_classes/utils/my_appbar.dart';
import 'package:offline_classes/widget/my_bottom_navbar.dart';
import 'package:sizer/sizer.dart';

import '../../../widget/image_opener.dart';

class SelectStudentProfile extends StatefulWidget {
  SelectStudentProfile({super.key});

  static int? id;

  getId() {
    return id;
  }

  @override
  State<SelectStudentProfile> createState() => _SelectStudentProfileState();
}

class _SelectStudentProfileState extends State<SelectStudentProfile> {
  Future<void> checkProfiles() async {
    final http.Response response = await http.get(Uri.parse(
        "${GlobalData.baseUrl}/studentProfiles?authKey=${GlobalData.auth1}&mobile=${GlobalData.phoneNumber.substring(1)}"));
    profiles = json.decode(response.body);
    if (response.statusCode == 200) {
      print(profiles);
    } else {
      return;
    }
  }

  String urlPrefix = "https://trusir.com/";

  static Map<String, dynamic> profiles = {};

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: customAppbar2(context, "All Profiles"),
      body: FutureBuilder(
        future: checkProfiles(),
        builder: (context, snapshot) {
          if (profiles.isEmpty) {
            return const Center(child: CircularProgressIndicator());
          } else {
            return SafeArea(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: List.generate(
                    profiles["data"].length,
                    (index) {
                      return Column(
                        children: <Widget>[
                          addVerticalSpace(1.h),
                          Center(
                            child: InkWell(
                              onTap: () {
                                SelectStudentProfile.id =
                                    profiles["data"][index]["id"];
                                GlobalStudent()
                                    .updateId(profiles["data"][index]["id"]);
                                GlobalStudent().updateProfiles(profiles);
                                Navigator.pushAndRemoveUntil(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            MyBottomBar(whoRYou: 'student')),
                                    (route) => false);
                                nextScreen(context,
                                    MyBottomBar(whoRYou: GlobalData.role));
                              },
                              child: Container(
                                height: 25.h,
                                // width: 95.w,
                                margin: EdgeInsets.all(14),
                                decoration: kGradientBoxDecoration(
                                    42, purpleGradident()),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: [
                                    Container(
                                      // height: height(context) * 0.22,
                                      height: 32.w,
                                      width: 32.w,
                                      padding: EdgeInsets.only(left: 5),
                                      child: ClipRRect(
                                        borderRadius:
                                            BorderRadius.circular(20.w),
                                        child: Image.network(
                                          '${urlPrefix}${profiles["data"][index]["image"]}',
                                          fit: BoxFit.fill,
                                        ),
                                      ),
                                    ),
                                    Container(
                                      color: black,
                                      width: 0.3.w,
                                    ),
                                    // addHorizontalySpace(10),
                                    Container(
                                      width: 50.w,
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          addVerticalSpace(10),
                                          Text(
                                            profiles["data"][index]["name"],
                                            style: kBodyText16wBold(white),
                                          ),
                                          addVerticalSpace(3),
                                          Text(
                                            "Gender: ${profiles["data"][index]["gender"]}",
                                            style: kBodyText16wBold(white),
                                          ),
                                          addVerticalSpace(3),
                                          Text(
                                            "Medium: ${profiles["data"][index]["medium"]}",
                                            style: kBodyText16wBold(white),
                                          ),
                                          addVerticalSpace(3),
                                          Text(
                                            "Class: ${profiles["data"][index]["class"]}",
                                            style: kBodyText16wBold(white),
                                          ),
                                          addVerticalSpace(3),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                          addVerticalSpace(2.h),
                        ],
                      );
                    },
                  ),
                ),
              ),
            );
          }
        },
      ),
    );
  }
}
