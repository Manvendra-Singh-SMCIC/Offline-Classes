import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:offline_classes/Views/home/home_screen.dart';
import 'package:offline_classes/model/statics_list.dart';
import 'package:offline_classes/utils/constants.dart';
import 'package:offline_classes/utils/my_appbar.dart';
import 'package:offline_classes/widget/custom_button.dart';
import 'package:offline_classes/widget/custom_textfield.dart';
import 'package:sizer/sizer.dart';
import 'package:http/http.dart' as http;
import 'package:get/get.dart';

import '../../global_data/GlobalData.dart';
import 'error_screen.dart';

class TeacherEnquiryForm extends StatefulWidget {
  const TeacherEnquiryForm({super.key});

  @override
  State<TeacherEnquiryForm> createState() => _TeacherEnquiryFormState();
}

class _TeacherEnquiryFormState extends State<TeacherEnquiryForm> {
  String qualification = "Qualification";
  List genderList = ['Male', 'Female'];
  int? selectedIndex;
  String qaulificationValue = 'Qualification';

  String genderValue = "";
  late Map<String, dynamic> mapResponse = {};

  @override
  void initState() {
    GlobalData().getInfoStudentHome(
        "/studentHome", GlobalData.auth1, GlobalData.phoneNumber.substring(1));
    mapResponse = GlobalData.mapResponseStudetHome;
    print(mapResponse.length);
    super.initState();
  }

  TextEditingController tfname = TextEditingController();
  TextEditingController tfcity = TextEditingController();
  TextEditingController tfpincode = TextEditingController();
  TextEditingController tfclass = TextEditingController();

  bool success = false;

  gotonextscreen() {
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (context) {
        GlobalData().updateRole('teacher');
        return HomeScreen(
          whoAreYou: 'teacher',
          serviceList: teacherServiceList,
          sliderList: const [
            'Trusted Teachers',
            'Home to Home tuition service',
          ],
          heading:
              'Trusir is a registered and trusted Indian company that offers Home to Home tuition service. We have a clear vision of helping students achieve their academic goals through one-to-one teaching.',
        );
      }),
      (route) => false, // Condition to stop removing pages
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: customAppbar2(context, 'Teacher Enquiry'),
      body: FutureBuilder(
          future: GlobalData().getInfoStudentHome("/studentHome",
              GlobalData.auth1, GlobalData.phoneNumber.substring(1)),
          builder: (context, snapshot) {
            if (!snapshot.hasData || mapResponse.length == 0) {
              return Center(
                child: CircularProgressIndicator(),
              );
            } else {
              return SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Column(
                    children: [
                      Container(
                        height: 30.h,
                        width: width(context) * 0.95,
                        decoration:
                            kGradientBoxDecoration(42, purpleGradident()),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            SizedBox(
                                height: 20.h,
                                child:
                                    Image.asset('assets/images/teacher1.png')),
                            // addVerticalSpace(4),
                            Text(
                              'Teacher Enquiry',
                              style: kBodyText30wBold(white),
                            )
                          ],
                        ),
                      ),
                      addVerticalSpace(30),
                      CustomTextfield(
                        hintext: 'Teacher Name',
                        controller: tfname,
                      ),
                      addVerticalSpace(10),
                      SizedBox(
                        height: 60,
                        child: ListView.builder(
                            itemCount: genderList.length,
                            scrollDirection: Axis.horizontal,
                            itemBuilder: (ctx, i) {
                              return Row(
                                children: [
                                  addHorizontalySpace(10),
                                  InkWell(
                                    onTap: () {
                                      selectedIndex = i;
                                      setState(() {
                                        genderValue = genderList[i];
                                      });
                                    },
                                    child: Container(
                                      height: 45,
                                      width: 45,
                                      decoration: selectedIndex == i
                                          ? kGradientBoxDecoration2(
                                              10, greenGradient())
                                          : k3DboxDecoration(10),
                                      child: selectedIndex == i
                                          ? const Icon(
                                              Icons.check,
                                              color: white,
                                              size: 40,
                                            )
                                          : SizedBox(),
                                    ),
                                  ),
                                  addHorizontalySpace(10),
                                  Text(
                                    genderList[i],
                                    style: kBodyText16wNormal(textColor),
                                  ),
                                  addHorizontalySpace(15)
                                ],
                              );
                            }),
                      ),
                      addVerticalSpace(10),
                      Container(
                        height: 8.5.h,
                        width: 95.w,
                        padding: EdgeInsets.only(left: 9.w, top: 7, right: 9.w),
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
                            value: qaulificationValue,
                            hint: Text('Select',
                                style: kBodyText14w500(textColor)),
                            icon: const Icon(
                              Icons.keyboard_arrow_down_rounded,
                              color: textColor,
                              size: 30,
                            ),
                            // elevation: 10,
                            style: kBodyText14w500(Color(0xffA4A4A4)),

                            borderRadius: BorderRadius.all(Radius.circular(5)),
                            isExpanded: true,
                            underline: SizedBox(),
                            onChanged: (String? newValue) {
                              setState(() {
                                qaulificationValue = newValue!;
                                qualification = newValue;
                              });
                            },
                            items: [
                              'Qualification',
                              'Non-Matric',
                              'Matric',
                              'Intermidiate',
                              'Graduated',
                              'Under-graduated',
                              'Post-graduated'
                            ].map<DropdownMenuItem<String>>((value) {
                              return DropdownMenuItem<String>(
                                value: value,
                                child: Text(
                                  value,
                                  style: kBodyText14w500(textColor),
                                ),
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
                      addVerticalSpace(height(context) * 0.04),
                      CustomTextfield(
                        hintext: 'Class',
                        controller: tfclass,
                        keyBoardType: TextInputType.number,
                      ),
                      addVerticalSpace(height(context) * 0.04),
                      CustomButton(
                          text: 'Enquire',
                          onTap: () async {
                            // nextScreen(
                            //     context,
                            //     HomeScreen(
                            //       whoAreYou: 'Teacher',
                            //       serviceList: teacherServiceList,
                            //       sliderList: const [
                            //         'Annual Gift Hamper',
                            //         '100% Trusted & Satisfied'
                            //       ],
                            //       heading:
                            //           'Trusir is a registered and trusted Indian company that offers Home to Home tuition service. We have a clear vision of helping male and female teaching service.',
                            //     ));
                            if (tfcity.text.toString().trim().length != 0 &&
                                tfname.text.toString().trim().length != 0 &&
                                tfpincode.text.toString().trim().length != 0 &&
                                tfclass.text.toString().trim().length != 0 &&
                                qualification != "Qualification" &&
                                genderValue != "") {
                              try {
                                // var url = Uri.parse(
                                //     '${GlobalData.baseUrl}/teacherEnquiry?mobile=${GlobalData.phoneNumber}&authKey=${GlobalData.auth1}&teacher_name=${tfname.text.toString()}&city=${tfcity.text}&pincode=${tfpincode.text.toString()}&gender=${genderValue}&qualification=${qualification}');
                                // var response = await http.get(url);
                                // print(url);
                                // print(response.statusCode);

                                var url = Uri.parse(
                                    '${GlobalData.baseUrl}/teacherEnquiry?');
                                var headers = {
                                  'Content-Type': 'application/json'
                                };
                                var response = await http.post(
                                  url,
                                  body: {
                                    'teacher_name': tfname.text.toString(),
                                    'qualification': qualification,
                                    'city': tfcity.text.toString(),
                                    'pincode': tfpincode.text.toString(),
                                    'gender': genderValue,
                                    'mobile':
                                        GlobalData.phoneNumber.substring(1),
                                    'authKey': GlobalData.auth1,
                                    'class': int.parse(tfclass.text.trim().toString()),
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
                                      'Request failed with status: ${response.statusCode} ${response.body}');
                                  print(json.decode(response.body)["Message"]);
                                  Get.to(() => ErrorScreen(
                                      message: json
                                          .decode(response.body)["Message"]
                                          .toString()));
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
                          })
                    ],
                  ),
                ),
              );
            }
          }),
    );
  }
}
