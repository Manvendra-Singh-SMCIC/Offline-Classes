import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:offline_classes/utils/constants.dart';
import 'package:offline_classes/utils/my_appbar.dart';
import 'package:sizer/sizer.dart';

class AboutUs extends StatelessWidget {
  const AboutUs({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: customAppbar2(context, 'About Us'),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Center(
              child: SizedBox(
                height: 10.h,
                child: Image.asset('assets/images/mainLogo.png'),
              ),
            ),
            addVerticalSpace(1.h),
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Text(
                "Trusir is a registered and trusted Indian company that offers Home to Home tuition service. We have a clear vision of helping students achieve their academic goals through one-to-one teaching. \n\nWe are a small team of educators, parents, and tech experts who are passionate about helping kids learn and grow. Our app is designed to make learning fun and to provide an exciting and engaging experience for kids. We believe that learning should be enjoyable and that kids should be encouraged to explore and play. We hope you enjoy using our app and that it helps your child explore and grow. Thank you for choosing us!",
                style: kBodyText18wNormal(primary),
              ),
            )
          ],
        ),
      ),
    );
  }
}
