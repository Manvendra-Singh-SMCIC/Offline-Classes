import 'dart:developer';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:get/get.dart';
import 'package:offline_classes/Views/auth/auth_controller.dart';
import 'package:offline_classes/Views/auth/otp_controller.dart';
import 'package:offline_classes/Views/auth/succesfull_login_screen.dart';
import 'package:offline_classes/widget/custom_button.dart';
import 'package:pinput/pin_put/pin_put.dart';
import 'package:sizer/sizer.dart';

import '../../utils/constants.dart';
import 'login_screen.dart';

class OtpVeryfyScreen extends StatefulWidget {
  static String verify = "";
  set setVerify(String ver) {
    verify = ver;
  }

  String mobno;

  OtpVeryfyScreen({super.key, required this.mobno});

  @override
  State<OtpVeryfyScreen> createState() => _OtpVeryfyScreenState();
}

class _OtpVeryfyScreenState extends State<OtpVeryfyScreen> {
  final FocusNode _pinPutFocusNode = FocusNode();
  final TextEditingController _pinPutController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    var code = "";
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: SafeArea(
          child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          addVerticalSpace(height(context) * 0.12),
          Text(
            'Enter OTP',
            style: const TextStyle(
                color: primary, fontSize: 36, fontWeight: FontWeight.w800),
          ),
          addVerticalSpace(height(context) * 0.02),
          SizedBox(
            width: width(context) * 0.75,
            child: Text(
              'Enter the verification code we just sent on your phone number.',
              textAlign: TextAlign.center,
              style: kBodyText16wBold(primary2),
            ),
          ),
          addVerticalSpace(height(context) * 0.04),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: PinPut(
              animationDuration: const Duration(seconds: 0),
              eachFieldHeight: 8.h,
              eachFieldWidth: 15.w,
              fieldsCount: 6,
              autofocus: true,
              onChanged: (value) {
                code = value;
              },
              submittedFieldDecoration: k3DboxDecoration(20),
              selectedFieldDecoration: k3DboxDecoration(20),
              followingFieldDecoration: k3DboxDecoration(20),
              textStyle: TextStyle(
                  fontSize: 24, fontWeight: FontWeight.w400, color: primary),
              focusNode: _pinPutFocusNode,
              controller: _pinPutController,
              pinAnimationType: PinAnimationType.fade,
              onTap: () {
                // setState(() {
                //   isTapped = true;
                // });
              },
            ),
          ),
          addVerticalSpace(height(context) * 0.03),
          TextButton(
              onPressed: () async {
                // PhoneAuthCredential credential = PhoneAuthProvider.credential(
                //     verificationId: OtpVeryfyScreen.verify,
                //     smsCode: code.toString().trim());
                // await AuthController.instance.auth
                //     .signInWithCredential(credential);
                log(widget.mobno.trim());
                AuthController.instance.sendOTP(widget.mobno.trim());
              },
              child: Text(
                'Resend OTP',
                style: kBodyText18wBold(primary),
              )),
          Spacer(),
          CustomButton(
              text: 'Verify',
              onTap: () async {
                print(_pinPutController.text);
                try {
                  if (_pinPutController.text.toString().length == 6) {
                    OtpController.instace
                        .verifyOTP(_pinPutController.text.toString());
                  } else {
                    Get.snackbar(
                      "Error",
                      "You need to enter the full otp",
                      backgroundColor: Colors.red.withOpacity(0.65),
                    );
                  }
                } catch (e) {
                  Get.snackbar(
                    "Wrong OTP",
                    "Try Again",
                    backgroundColor: Colors.red.withOpacity(0.65),
                  );
                }
                // try {
                //   print(_pinPutController.text);
                //   OtpController.instace
                //       .verifyOTP(_pinPutController.text.toString());
                // } catch (e) {
                //   Get.snackbar(
                //     "About User",
                //     "User message",
                //     backgroundColor: Colors.redAccent,
                //     snackPosition: SnackPosition.BOTTOM,
                //     titleText: const Text(
                //       "Wrong OTP",
                //       style: TextStyle(
                //         color: Colors.white,
                //       ),
                //     ),
                //     messageText: Text(
                //       "Try Again",
                //       style: const TextStyle(
                //         color: Colors.white,
                //       ),
                //     ),
                //   );
                //   //nextScreen(context, SuccessfullLogInscreen());
                //}
              }),
          addVerticalSpace(20)
        ],
      )),
    );
  }
}
