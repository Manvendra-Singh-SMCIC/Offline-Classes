import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:offline_classes/Views/home/students_facilities/select_student_profile.dart';
import 'package:offline_classes/utils/constants.dart';
import 'package:offline_classes/widget/my_bottom_navbar.dart';
import 'package:sizer/sizer.dart';

class RegistrationSuccessfull extends StatefulWidget {
  const RegistrationSuccessfull({super.key, required this.whoareYou});
  final String whoareYou;

  @override
  State<RegistrationSuccessfull> createState() =>
      _RegistrationSuccessfullState();
}

class _RegistrationSuccessfullState extends State<RegistrationSuccessfull> {
  @override
  void initState() {
    Timer(Duration(seconds: 3), () {
      if (widget.whoareYou == 'teacher') {
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(
            builder: (context) => MyBottomBar(
              whoRYou: widget.whoareYou,
            ),
          ),
          (route) => false, // Condition to stop removing pages
        );
      } else {
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(
            builder: (context) => SelectStudentProfile(),
          ),
          (route) => false, // Condition to stop removing pages
        );
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        height: 100.h,
        width: width(context),
        decoration: kGradientBoxDecoration(0, purpleGradident()),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Thanks for\nRegistration!',
              style: kBodyText32wBold(white),
              textAlign: TextAlign.center,
            ),
            addVerticalSpace(5.h),
            SizedBox(
                height: 26.h,
                child: Image.asset('assets/images/reg_success.png')),
            addVerticalSpace(6.h),
            // Text(
            //   'We will be assigning you a ${widget.whoareYou} shortly',
            //   style: kBodyText18wNormal(white),
            //   textAlign: TextAlign.center,
            // )
          ],
        ),
      ),
    );
  }
}

class OfflinePayment extends StatelessWidget {
  const OfflinePayment({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            'For Offline Payment Contact to Our Offline Payment Collection Team On',
            style: kBodyText20wBold(black),
            textAlign: TextAlign.center,
          ),
          addVerticalSpace(5.h),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Column(
                children: [
                  SizedBox(
                      height: height(context) * 0.09,
                      child: Image.asset('assets/images/wp.png')),
                  addVerticalSpace(10),
                  Text(
                    'Whatsapp',
                    style: kBodyText16wNormal(primary),
                  )
                ],
              ),
              Column(
                children: [
                  SizedBox(
                      height: height(context) * 0.1,
                      child: Image.asset('assets/images/phone.png')),
                  addVerticalSpace(10),
                  Text(
                    'Call',
                    style: kBodyText16wNormal(primary),
                  )
                ],
              ),
              // Image.asset('assets/images/phone.png'),
            ],
          )
        ],
      ),
    );
  }
}
