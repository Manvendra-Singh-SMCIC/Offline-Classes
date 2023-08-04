import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:get/get.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:offline_classes/utils/constants.dart';
import 'package:offline_classes/utils/my_appbar.dart';
import 'package:offline_classes/widget/custom_button.dart';
import 'package:offline_classes/widget/custom_textfield.dart';
import 'package:sizer/sizer.dart';
import 'package:http/http.dart' as http;
import '../../../global_data/GlobalData.dart';
import '../../enquiry_registrations/error_screen.dart';

class ContactUs extends StatefulWidget {
  const ContactUs({super.key, this.title = "Contact Us"});

  final String title;

  @override
  State<ContactUs> createState() => _ContactUsState();
}

class _ContactUsState extends State<ContactUs> {
  TextEditingController tfname = TextEditingController();
  TextEditingController tfmail = TextEditingController();
  TextEditingController tfmessage = TextEditingController();

  bool showSpinner = false;

  void sendEmail() async {
    setState(() {
      showSpinner = true;
    });
    try {
      var url = Uri.parse('${GlobalData.baseUrl}/contactUs?');
      print(url);
      var response = await http.post(
        url,
        body: {
          'email': tfmail.text.toString(),
          'name': tfname.text.toString(),
          'message': tfmessage.text.toString(),
          'authKey': GlobalData.auth1,
        },
      );

      Future.delayed(const Duration(seconds: 2), () {
        print('Response body: ${response.body}');
        if (response.statusCode == 200) {
          // Request successfulful, parse the response
          Get.snackbar(
            "Success",
            "Queries sent!!",
            backgroundColor: Colors.green.withOpacity(0.65),
          );
          print('Response body: ${response.body}');
          setState(() {
            showSpinner = false;
          });
        } else {
          // Request failed
          Get.snackbar(
            "Error",
            "Please try again later.",
            backgroundColor: Colors.red.withOpacity(0.65),
          );
          print('Request failed with status: ${response.statusCode}');
          print(json.decode(response.body)["Message"]);
          Get.to(
            () => ErrorScreen(
              message: json.decode(response.body)["Message"].toString(),
            ),
          );
          setState(() {
            showSpinner = false;
          });
        }
      });
    } catch (e) {
      // Error occurred during HTTP request
      print('Error: $e');
      Get.snackbar(
        "Error",
        "Please try again later.",
        backgroundColor: Colors.red.withOpacity(0.65),
      );
      setState(() {
        showSpinner = false;
      });
    }
    // final Uri params = Uri(
    //   scheme: 'mailto',
    //   path:
    //       '12a.manvendrasingh@gmail.com', // Replace with the recipient email address
    //   query:
    //       'subject=From ${tfmail.text}&body=${tfmessage.text}?', // Replace with your email subject and body
    // );

    // final String url = params.toString();

    // if (await canLaunchUrl(Uri.parse(url))) {
    //   await launchUrl((Uri.parse(url)));
    // } else {
    //   throw 'Could not launch $url';
    // }
  }

  @override
  Widget build(BuildContext context) {
    // showSpinner = false;
    return ModalProgressHUD(
      inAsyncCall: showSpinner,
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: customAppbar2(context, widget.title),
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(15.0),
              child: Text(
                'Hello',
                style: kBodyText40wBold(primary),
              ),
            ),
            addVerticalSpace(2.h),
            Center(
              child: CustomTextfield(
                hintext: 'Name',
                controller: tfname,
              ),
            ),
            addVerticalSpace(2.h),
            Center(
              child: CustomTextfield(
                hintext: 'Email ID',
                controller: tfmail,
              ),
            ),
            addVerticalSpace(2.h),
            Center(
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: CustomTextfieldMaxLine(
                  hintext: 'Message',
                  controller: tfmessage,
                ),
              ),
            ),
            Spacer(),
            Center(
                child: CustomButton(
              text: 'Submit',
              onTap: () {
                if (tfname.text.isNotEmpty &&
                    tfmail.text.isNotEmpty &&
                    tfmessage.text.isNotEmpty) {
                  sendEmail();
                } else {
                  Get.snackbar(
                    "Please fill all the fields",
                    "All fields are mandatory",
                    backgroundColor: Colors.red.withOpacity(0.65),
                  );
                }
              },
            )),
            addVerticalSpace(4.h),
          ],
        ),
      ),
    );
  }
}
