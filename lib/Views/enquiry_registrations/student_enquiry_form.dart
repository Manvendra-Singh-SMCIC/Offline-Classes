import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:offline_classes/Views/enquiry_registrations/error_screen.dart';
import 'package:offline_classes/Views/home/home_screen.dart';
import 'package:offline_classes/global_data/GlobalData.dart';
import 'package:offline_classes/utils/constants.dart';
import 'package:offline_classes/utils/my_appbar.dart';
import 'package:offline_classes/widget/custom_button.dart';
import 'package:offline_classes/widget/custom_textfield.dart';
import 'package:sizer/sizer.dart';
import 'package:http/http.dart' as http;

import '../../model/statics_list.dart';

class StudentEnquiryForm extends StatefulWidget {
  const StudentEnquiryForm({super.key});

  @override
  State<StudentEnquiryForm> createState() => _StudentEnquiryFormState();
}

class _StudentEnquiryFormState extends State<StudentEnquiryForm> {
  String classValue = 'Class';
  @override
  void initState() {
    GlobalData().getInfoStudentHome(
        "/studentHome", GlobalData.auth1, GlobalData.phoneNumber.substring(1));
    mapResponse = GlobalData.mapResponseStudetHome;
    print(mapResponse.length);
    super.initState();
  }

  bool success = false;

  late Map<String, dynamic> mapResponse = {};

  gotonextscreen() {
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (context) {
        GlobalData().updateRole('student');
        return HomeScreen(
          whoAreYou: 'student',
          serviceList: studentServiceList,
          sliderList: const [
            'Trusted Teachers',
            'Home to Home tuition service'
          ],
          heading:
              'Trusir is a registered and trusted Indian company that offers Home to Home tuition service. We have a clear vision of helping students achieve their academic goals through one-to-one teaching.',
        );
      }),
      (route) => false, // Condition to stop removing pages
    );
  }

  TextEditingController tfname = TextEditingController();
  TextEditingController tfcity = TextEditingController();
  TextEditingController tfpincode = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: customAppbar2(context, 'Student Enquiry'),
      body: FutureBuilder(
        future: GlobalData().getInfoStudentHome("/studentHome",
            GlobalData.auth1, GlobalData.phoneNumber.substring(1)),
        builder: (context, snapshot) {
          if (!snapshot.hasData || mapResponse.length == 0) {
            return const Center(
              child: CircularProgressIndicator(
                color: primary2,
              ),
            );
          } else {
            List<String> listOfClasses =
                List<String>.filled(mapResponse["classes"].length, '');
            for (int i = 0; i < mapResponse["classes"].length; i++) {
              listOfClasses[i] =
                  (mapResponse["classes"][i]["class_name"].toString());
            }
            List<String> classLists = listOfClasses
                .where((element) => element != null)
                .cast<String>()
                .toList();
            List<String> myclassList = ["Class"];
            myclassList.addAll(classLists);
            print(myclassList);
            return Padding(
              padding: const EdgeInsets.all(12.0),
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    Container(
                      height: 32.h,
                      width: width(context) * 0.95,
                      decoration: kGradientBoxDecoration(42, purpleGradident()),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          SizedBox(
                              height: height(context) * 0.22,
                              child: Image.asset('assets/images/student1.png')),
                          Text(
                            'Student Enquiry',
                            style: kBodyText30wBold(white),
                          )
                        ],
                      ),
                    ),
                    addVerticalSpace(30),
                    CustomTextfield(
                      controller: tfname,
                      hintext: 'Student Name',
                    ),
                    addVerticalSpace(15),
                    Container(
                      height: 8.5.h,
                      width: 95.w,
                      padding: EdgeInsets.only(left: 9.w, top: 6, right: 9.w),
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
                      child: Center(
                        child: DropdownButton<String>(
                          value: classValue,
                          hint:
                              Text('Select', style: kBodyText14w500(textColor)),
                          icon: const Icon(
                            Icons.keyboard_arrow_down_rounded,
                            color: textColor,
                            size: 30,
                          ),
                          // elevation: 10,
                          style: const TextStyle(
                              color: textColor,
                              fontSize: 14,
                              fontWeight: FontWeight.w500),
                          borderRadius: BorderRadius.all(Radius.circular(5)),
                          isExpanded: true,
                          underline: SizedBox(),
                          onChanged: (String? newValue) {
                            setState(() {
                              classValue = newValue!;
                            });
                          },
                          // items: classList.map((String className) {
                          //   return DropdownMenuItem<String>(
                          //     value: className,
                          //     child: Text(className),
                          //   );
                          // }).toList(),
                          items: myclassList
                              .map<DropdownMenuItem<String>>((value) {
                            return DropdownMenuItem<String>(
                              value: value,
                              child: Text(value,
                                  style: kBodyText14w500(textColor)),
                            );
                          }).toList(),
                        ),
                      ),
                    ),
                    addVerticalSpace(15),
                    CustomTextfield(
                      hintext: 'City/Town',
                      controller: tfcity,
                    ),
                    addVerticalSpace(15),
                    CustomTextfield(
                      hintext: 'Pincode',
                      controller: tfpincode,
                      keyBoardType: TextInputType.number,
                    ),
                    addVerticalSpace(height(context) * 0.07),
                    CustomButton(
                      text: 'Enquire',
                      onTap: () async {
                        if (tfcity.text.toString().trim().length != 0 &&
                            tfname.text.toString().trim().length != 0 &&
                            tfpincode.text.toString().trim().length != 0 &&
                            classValue != "Class") {
                          try {
                            var url = Uri.parse(
                                '${GlobalData.baseUrl}/studentEnquiry?');
                            var headers = {'Content-Type': 'application/json'};
                            var response = await http.post(
                              url,
                              body: {
                                'student_name': tfname.text.toString(),
                                'class': classValue,
                                'city': tfcity.text.toString(),
                                'pincode': tfpincode.text.toLowerCase(),
                                'mobile': GlobalData.phoneNumber.substring(1),
                                'authKey': GlobalData.auth1,
                              },
                            );

                            if (response.statusCode == 200) {
                              // Request successful, parse the response
                              print('Response body: ${response.body}');
                              success = true;
                              gotonextscreen();
                            } else {
                              // Request failed
                              print(
                                  'Request failed with status: ${response.statusCode}');
                              print(json.decode(response.body)["Message"]);
                              Get.to(
                                () => ErrorScreen(
                                  message: json
                                      .decode(response.body)["Message"]
                                      .toString(),
                                ),
                              );
                            }
                          } catch (e) {
                            // Error occurred during HTTP request
                            print('Error: $e');
                          }
                        } else {
                          Get.snackbar(
                            "Error",
                            "All fields are mandatory.",
                            backgroundColor: Colors.red.withOpacity(0.65),
                          );
                        }
                      },
                    ),
                  ],
                ),
              ),
            );
          }
        },
      ),
    );
  }
}
