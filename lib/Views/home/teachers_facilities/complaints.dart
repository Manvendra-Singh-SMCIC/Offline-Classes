import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../utils/constants.dart';
import '../../../utils/my_appbar.dart';
import '../../../widget/custom_button.dart';
import '../../../widget/custom_textfield.dart';

class ComplaintsScreen extends StatefulWidget {
  const ComplaintsScreen({super.key});

  @override
  State<ComplaintsScreen> createState() => _ComplaintsScreenState();
}

class _ComplaintsScreenState extends State<ComplaintsScreen> {
  TextEditingController title = TextEditingController();
  TextEditingController description = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: customAppbar2(context, 'Complaints'),
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          children: [
            addVerticalSpace(2.h),
            CustomTextfield(
              hintext: 'Title',
              controller: title,
            ),
            addVerticalSpace(3.h),
            CustomTextfieldMaxLine(
              hintext: 'Description',
              controller: description,
            ),
            const Spacer(),
            CustomButton(text: 'Submit', onTap: () {}),
            addVerticalSpace(2.h)
          ],
        ),
      ),
    );
  }
}
