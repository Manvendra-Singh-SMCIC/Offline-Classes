import 'dart:developer';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/src/snackbar/snackbar.dart';
import 'package:offline_classes/Views/auth/auth_controller.dart';
import 'package:offline_classes/Views/auth/otp_verify_screen.dart';
import 'package:offline_classes/utils/constants.dart';
import 'package:offline_classes/widget/custom_button.dart';
import 'package:sizer/sizer.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class LoginScreen extends StatefulWidget {
  LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  String dropDownValue = 'Language';
  List dropDownList = ['Language', 'English', 'Hindi'];

  List pageviewList = [
    {
      'title': 'Home Tuitions',
      'subtitle': 'Get the tuition from the best teachers at your home '
    },
    {
      'title': 'Special Education',
      'subtitle': 'Education for your child at home with personal attention'
    },
    {
      'title': '100%  Satisfaction',
      'subtitle': '100% student satisfaction and a great learning experience'
    },
    {'title': 'Trusted Teachers', 'subtitle': 'Trusted teachers by Trusir'},
    {
      'title': 'Monthly Test Series',
      'subtitle': 'Test series every month facility to test your kids'
    },
  ];
  final controller = PageController();

  static TextEditingController phNoController = TextEditingController();
  String phno = "";

  @override
  void dispose() {
    controller.dispose();

    super.dispose();
  }

  double? size;
  @override
  Widget build(BuildContext context) {
    double Height = MediaQuery.of(context).size.height;
    double Width = MediaQuery.of(context).size.width;
    size = width(context) * 0.93;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: white,
        elevation: 0,
        foregroundColor: black,
        leadingWidth: width(context) * 0.3,
        leading: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Image.asset("assets/images/logo.png"),
        ),
        actions: [
          Visibility(
            visible: false,
            child: DropdownButton<String>(
              value: dropDownValue,
              hint: const Text(
                'Select',
                style: TextStyle(
                    fontSize: 14,
                    color: Color(0xffB1B1B3),
                    fontWeight: FontWeight.w400),
              ),
              icon: const Icon(
                Icons.keyboard_arrow_down_rounded,
                color: black,
                size: 26,
              ),
              // elevation: 10,
              style: const TextStyle(
                  color: black, fontSize: 18, fontWeight: FontWeight.w500),
              borderRadius: BorderRadius.all(Radius.circular(5)),
              // isExpanded: true,s
              underline: SizedBox(),
              onChanged: (String? newValue) {
                setState(() {
                  dropDownValue = newValue!;
                });
                Get.snackbar(
                  "Feature currently not available",
                  "This feautre will be available soon",
                );
              },
              items: dropDownList.map<DropdownMenuItem<String>>((value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
            ),
          ),
        ],
      ),
      body: SafeArea(
          child: SingleChildScrollView(
        child: Column(
          children: [
            addVerticalSpace(40),
            SizedBox(
              height: 57.h,
              // width: width(context) * 0.93,
              child: PageView.builder(
                  itemCount: pageviewList.length,
                  controller: controller,
                  itemBuilder: (ctx, i) {
                    return Column(
                      children: [
                        Text(
                          pageviewList[i]['title'],
                          style: const TextStyle(
                              color: primary,
                              fontSize: 36,
                              fontWeight: FontWeight.w800),
                        ),
                        addVerticalSpace(0.2.h),
                        SizedBox(
                          width: width(context) * 0.9,
                          child: Text(
                            pageviewList[i]['subtitle'],
                            textAlign: TextAlign.center,
                            style: kBodyText16wBold(primary2),
                          ),
                        ),
                        addVerticalSpace(10),
                        Center(
                          child: Padding(
                            padding: const EdgeInsets.only(right: 16.0),
                            child: Image.asset('assets/images/loginimg.png'),
                          ),
                        ),
                      ],
                    );
                  }),
            ),
            addVerticalSpace(5),
            SmoothPageIndicator(
              count: pageviewList.length,
              controller: controller,
              effect: ExpandingDotsEffect(
                  spacing: width(context) * 0.015,
                  dotWidth: width(context) * 0.02,
                  dotHeight: width(context) * 0.025,
                  dotColor: const Color.fromRGBO(219, 207, 240, 1),
                  activeDotColor: primary), // WormEffect
            ),
            addVerticalSpace(30),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 15, vertical: 0),
              height: height(context) * 0.069,
              width: width(context) * 0.9,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(40),
                boxShadow: [
                  BoxShadow(
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
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  addVerticalSpace(2.0),
                  Center(
                    child: TextFormField(
                      controller: phNoController,
                      onChanged: (value) {
                        phno = value;
                      },
                      keyboardType: TextInputType.number,
                      inputFormatters: [
                        LengthLimitingTextInputFormatter(10),
                        FilteringTextInputFormatter.allow(
                          RegExp(r"[0-9]"),
                        )
                      ],
                      decoration: InputDecoration(
                          prefixIcon: Image.asset('assets/images/ind2.png'),
                          border: InputBorder.none,
                          hintText: '+91 |  Mobile Number'),
                    ),
                  ),
                ],
              ),
            ),
            addVerticalSpace(height(context) * 0.045),
            CustomButton(
                text: 'Send OTP',
                onTap: () {
                  if (phno.length == 10) {
                    try {
                      AuthController.instance.sendOTP("+91${phno.trim()}");
                      Get.to(() => OtpVeryfyScreen(mobno: "+91${phno.trim()}"));
                    } catch (e) {
                      Get.snackbar(
                        "About User",
                        "User message",
                        backgroundColor: Colors.redAccent,
                        snackPosition: SnackPosition.BOTTOM,
                        titleText: const Text(
                          "Enter a valid phone number",
                          style: TextStyle(
                            color: Colors.white,
                          ),
                        ),
                        messageText: Text(
                          e.toString(),
                          style: const TextStyle(
                            color: Colors.white,
                          ),
                        ),
                      );
                    }
                    //nextScreen(context, OtpVeryfyScreen());
                  } else {
                    Get.snackbar(
                      "About User",
                      "User message",
                      backgroundColor: Colors.redAccent,
                      snackPosition: SnackPosition.BOTTOM,
                      titleText: const Text(
                        "Wrong Phone Number",
                        style: TextStyle(
                          color: Colors.white,
                        ),
                      ),
                      messageText: Text(
                        "Enter a valid Phone Number",
                        style: const TextStyle(
                          color: Colors.white,
                        ),
                      ),
                    );
                  }
                })
          ],
        ),
      )),
    );
  }
}
