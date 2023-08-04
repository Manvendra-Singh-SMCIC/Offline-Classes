import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:offline_classes/utils/constants.dart';
import 'package:offline_classes/utils/my_appbar.dart';
import 'package:offline_classes/widget/custom_button.dart';
import 'package:offline_classes/widget/custom_textfield.dart';
import 'package:pinput/pin_put/pin_put.dart';
import 'package:sizer/sizer.dart';
import 'package:get/get.dart';

class ChangeMobileNumber extends StatefulWidget {
  const ChangeMobileNumber({super.key});

  @override
  State<ChangeMobileNumber> createState() => _ChangeMobileNumberState();
}

class _ChangeMobileNumberState extends State<ChangeMobileNumber> {
  final FocusNode _pinPutFocusNode = FocusNode();
  final TextEditingController _pinPutController = TextEditingController();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: customAppbar2(context, 'Change Phone Number'),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(4.0),
          child: Column(children: [
            addVerticalSpace(2.h),
            Center(
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Text(
                  'Enter Mobile Number',
                  style: kBodyText25Bold(primary),
                ),
              ),
            ),
            addVerticalSpace(2.h),
            Text("This feature will be available soon.",
                style: TextStyle(color: Colors.red)),
            addVerticalSpace(3.h),
            CustomTextfield(
                keyBoardType: TextInputType.number,
                hintext: 'Enter Mobile Number'),
            addVerticalSpace(5.h),
            SizedBox(
              width: 50.w,
              child: GestureDetector(
                onTap: () {
                  Get.snackbar("Feature currently not available",
                      "This feature will be available soon");
                },
                child: CustomButton(
                  text: 'Send OTP',
                  onTap: () {
                    Get.snackbar("Feature currently not available",
                        "This feature will be available soon");
                  },
                ),
              ),
            ),
            Divider(
              thickness: 1,
              height: 16.h,
              color: black,
            ),
            Text(
              'Enter OTP',
              style: kBodyText27wBold(primary),
            ),
            addVerticalSpace(2.h),
            Padding(
              padding: const EdgeInsets.only(top: 18, bottom: 12),
              child: PinPut(
                animationDuration: const Duration(seconds: 1),
                eachFieldHeight: 60,
                eachFieldWidth: 60,
                fieldsCount: 6,
                autofocus: true,
                submittedFieldDecoration: k3DboxDecoration(30),
                selectedFieldDecoration: k3DboxDecoration(30),
                followingFieldDecoration: k3DboxDecoration(30),
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
            addVerticalSpace(5.h),
            SizedBox(
              width: 50.w,
              child: CustomButton(
                text: 'Verify OTP',
                onTap: () {
                  Get.snackbar("Feature currently not available",
                      "This feature will be available soon");
                },
              ),
            ),
          ]),
        ),
      ),
    );
  }
}
