import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:offline_classes/Views/auth/auth_controller.dart';
import 'package:offline_classes/global_data/GlobalData.dart';
import 'package:offline_classes/global_data/student_global_data.dart';
import 'package:offline_classes/global_data/teacher_global_data.dart';
import 'package:offline_classes/utils/my_appbar.dart';
import 'package:offline_classes/widget/custom_button.dart';
import 'package:sizer/sizer.dart';

import '../../../utils/constants.dart';

class LogoutScreen extends StatelessWidget {
  const LogoutScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: customAppbar2(context, ''),
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            addVerticalSpace(12.h),
            Center(
              child: Container(
                height: 22.h,
                width: 22.h,
                decoration: kGradientBoxDecoration(40, orangeGradient()),
                child: ClipRRect(
                  borderRadius: BorderRadius.all(Radius.circular(40)),
                  child: Image.network(
                    GlobalStudent.urlPrefix +
                        (GlobalData.role == 'student'
                            ? GlobalStudent.specificProfile['data'][0]["image"]
                            : GlobalTeacher.profile["data"][0]["image"]),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),
            addVerticalSpace(6.h),
            Text(
              'Are you sure you want to Logout?',
              style: kBodyText20wBold(black),
              textAlign: TextAlign.center,
            ),
            Spacer(),
            CustomButtonOutline(
                textWidget: Text(
                  'Cancel',
                  style: kBodyText18wBold(green),
                ),
                ontap: () {
                  goBack(context);
                },
                width: 90.w,
                height: 6.5.h),
            addVerticalSpace(2.h),
            CustomButton(
              text: 'Logout',
              onTap: () {
                GlobalStudent().destroy();
                AuthController.instance.logout();
              },
            ),
            addVerticalSpace(1.h)
          ],
        ),
      ),
    );
  }
}
