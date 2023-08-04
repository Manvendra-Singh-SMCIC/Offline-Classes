import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:offline_classes/Views/auth/auth_controller.dart';
import 'package:offline_classes/Views/enquiry_registrations/student_enquiry_form.dart';
import 'package:offline_classes/Views/enquiry_registrations/teacher_enquiry_form.dart';
import 'package:offline_classes/global_data/GlobalData.dart';
import 'package:offline_classes/utils/constants.dart';
import 'package:sizer/sizer.dart';

class EnquiryOnlyTeacher extends StatelessWidget {
  const EnquiryOnlyTeacher({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
          child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            addVerticalSpace(2.h),
            Center(
              child: InkWell(
                onTap: () {
                  nextScreen(context, TeacherEnquiryForm());
                },
                child: Container(
                  height: 25.h,
                  // width: width(context) * 0.95,
                  margin: EdgeInsets.all(14),
                  decoration: kGradientBoxDecoration(42, purpleGradident()),
                  // decoration: kFillBoxDecoration(0, Color(0xff48116a), 42),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      SizedBox(
                          // height: height(context) * 0.18,
                          width: 40.w,
                          child: Image.asset('assets/images/teacher1.png')),
                      Text(
                        'Teacher \nEnquiry',
                        style: kBodyText32wBold(white),
                      )
                    ],
                  ),
                ),
              ),
            ),
            addVerticalSpace(3.h),
            Text(
              'Or Enquire On',
              style: kBodyText18wBold(primary),
            ),
            addVerticalSpace(height(context) * 0.03),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                GestureDetector(
                  onTap: () => AuthController.instance.logout(),
                  child: Column(
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
      )),
    );
  }
}
