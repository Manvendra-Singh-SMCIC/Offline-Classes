import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:offline_classes/Views/auth/auth_controller.dart';
import 'package:offline_classes/Views/enquiry_registrations/enquiry_screens/enquiry_both.dart';
import 'package:offline_classes/Views/enquiry_registrations/enquiry_screens/enquiry_only_student.dart';
import 'package:offline_classes/Views/enquiry_registrations/enquiry_screens/enquiry_only_teacher.dart';
import 'package:offline_classes/Views/enquiry_registrations/student_enquiry_form.dart';
import 'package:offline_classes/Views/enquiry_registrations/teacher_enquiry_form.dart';
import 'package:offline_classes/buffer_screens/progress_indicator_screen.dart';
import 'package:offline_classes/global_data/GlobalData.dart';
import 'package:offline_classes/utils/constants.dart';
import 'package:offline_classes/widget/my_bottom_navbar.dart';
import 'package:sizer/sizer.dart';

class EnquirySelectStudentOrTeachers extends StatefulWidget {
  const EnquirySelectStudentOrTeachers({super.key});

  @override
  State<EnquirySelectStudentOrTeachers> createState() =>
      _EnquirySelectStudentOrTeachersState();
}

class _EnquirySelectStudentOrTeachersState
    extends State<EnquirySelectStudentOrTeachers> {
  @override
  void initState() {
    GlobalData().getInfoLogin(
        "/login", GlobalData.auth1, GlobalData.phoneNumber.substring(1));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: GlobalData().getInfoLogin(
            "/login", GlobalData.auth1, GlobalData.phoneNumber.substring(1)),
        builder: (context, snapshot) {
          String role = GlobalData.role;
          if (!snapshot.hasData) {
            return Scaffold(body: Center(child: CircularProgressIndicator()));
          } else {
            return (role == 'student' || role == 'teacher')
                ? ProgressIndicatorScreen()
                : EnquiryBoth();
          }
        });
  }
}
