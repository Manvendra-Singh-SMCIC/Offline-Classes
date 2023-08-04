import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:offline_classes/Views/enquiry_registrations/enquiry_student_or_teachers.dart';
import 'package:offline_classes/utils/constants.dart';

class SuccessfullLogInscreen extends StatefulWidget {
  const SuccessfullLogInscreen({
    super.key,
  });

  @override
  State<SuccessfullLogInscreen> createState() => _SuccessfullLogInscreenState();
}

class _SuccessfullLogInscreenState extends State<SuccessfullLogInscreen> {
  void initState() {
    Timer(Duration(seconds: 1), () {
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (ctx) => EnquirySelectStudentOrTeachers()),
        (route) => false,
      );
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Center(
              child: SizedBox(
                  height: height(context) * 0.25,
                  child: Image.asset('assets/images/successLogo.png')),
            )
          ],
        ),
      ),
      bottomNavigationBar: Container(
        height: height(context) * 0.4,
        width: width(context),
        decoration: BoxDecoration(
            gradient: purpleGradident(),
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(100), topRight: Radius.circular(100))),
        child: Center(
          child: Text(
            'OTP Verified Successfully!!',
            textAlign: TextAlign.center,
            style: kBodyText40wBold(white),
          ),
        ),
      ),
    );
  }
}

class PaymentSuccessFullScreen extends StatelessWidget {
  const PaymentSuccessFullScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Center(
              child: SizedBox(
                  height: height(context) * 0.25,
                  child: Image.asset('assets/images/successLogo.png')),
            )
          ],
        ),
      ),
      bottomNavigationBar: Container(
        height: height(context) * 0.4,
        width: width(context),
        decoration: BoxDecoration(
            gradient: purpleGradident(),
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(100), topRight: Radius.circular(100))),
        child: Center(
          child: Text(
            'Payment Successful',
            textAlign: TextAlign.center,
            style: kBodyText40wBold(white),
          ),
        ),
      ),
    );
  }
}
