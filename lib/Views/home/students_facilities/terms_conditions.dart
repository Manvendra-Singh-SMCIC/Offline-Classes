import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:offline_classes/utils/constants.dart';
import 'package:offline_classes/utils/my_appbar.dart';
import 'package:sizer/sizer.dart';

class TermsAndConditions extends StatelessWidget {
  const TermsAndConditions({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: customAppbar2(context, 'Terms & Conditions'),
      body: Padding(
        padding: const EdgeInsets.all(18.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '1. Acceptance of Terms:',
                style: kBodyText14wBold(black),
              ),
              Text(
                  'By accessing or using the Trusir app, you agree to be legally bound by these Terms and Conditions. If you do not agree to these Terms and Conditions, you must not access or use the Trusir.'),
              addVerticalSpace(2.h),
              Text(
                '2. License:',
                style: kBodyText14wBold(black),
              ),
              Text(
                  'Trusir grants you a limited, non-exclusive, non-transferable license to use the Trusir app. This license gives you the right to access and use the Trusir app for your personal, non-commercial purposes.'),
              addVerticalSpace(2.h),
              Text(
                '3. Disclaimer:',
                style: kBodyText14wBold(black),
              ),
              Text(
                  'The Trusir app and all content and services provided on the app are provided on an “as is” basis.  Trusir does not warrant or guarantee the accuracy or completeness of any content or services provided on the app. Trusir is not responsible for any errors or omissions in the content or services provided on the app'),
              addVerticalSpace(2.h),
              Text(
                '4. User Content:',
                style: kBodyText14wBold(black),
              ),
              Text(
                  'You understand that any content that you post or submit to the Trusir app may be viewed by other users. You are solely responsible for all the content that you post or submit to the Trusir app and any consequences arising out of such content. You agree to not post or submit any content that is defamatory, offensive, pornographic, or otherwise inappropriate.'),
              addVerticalSpace(2.h),
              Text(
                '5. Limitation of Liability:',
                style: kBodyText14wBold(black),
              ),
              Text(
                  'Trusir is not liable for any direct, indirect, incidental, punitive, or consequential damages arising out of the use of the Trusir app. This includes, but is not limited to, damages resulting from errors or omissions in the content or services provided on the app'),
              addVerticalSpace(2.h),
              Text(
                '6. Indemnification',
                style: kBodyText14wBold(black),
              ),
              Text(
                  'You agree to indemnify and hold harmless Trusir Farm from and against all claims, damages, losses, and expenses (including legal fees) arising out of or related to your use of the Trusir'),
              addVerticalSpace(2.h),
              Text(
                '7. Termination:',
                style: kBodyText14wBold(black),
              ),
              Text(
                  'Trusir may terminate your access to the Trusir app at any time for any reason. Upon termination, you must immediately cease using the Trusir app.')
            ],
          ),
        ),
      ),
    );
  }
}
