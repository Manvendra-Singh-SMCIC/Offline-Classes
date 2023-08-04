import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:offline_classes/Views/home/students_facilities/teachers_list.dart';
import 'package:offline_classes/global_data/student_global_data.dart';
import 'package:offline_classes/utils/constants.dart';
import 'package:offline_classes/widget/custom_button.dart';
import 'package:offline_classes/widget/custom_textfield.dart';
import 'package:offline_classes/widget/image_opener.dart';
import 'package:sizer/sizer.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../global_data/GlobalData.dart';
import '../../../utils/my_appbar.dart';
import '../../enquiry_registrations/error_screen.dart';

class ParentsDoubts extends StatefulWidget {
  const ParentsDoubts({super.key});

  @override
  State<ParentsDoubts> createState() => _ParentsDoubtsState();
}

class _ParentsDoubtsState extends State<ParentsDoubts> {
  ImagePicker _picker = ImagePicker();

  bool showSpinner = false;

  File? image;

  TextEditingController tfTitle = TextEditingController();
  TextEditingController tfDescription = TextEditingController();
  TextEditingController tfEmail = TextEditingController();

  void _launchPhone(String phoneNumber) async {
    final Uri phoneUri = Uri(scheme: 'tel', path: phoneNumber);
    if (await canLaunchUrl(phoneUri)) {
      await launchUrl(phoneUri);
    } else {
      Get.snackbar(
        "Error",
        "Call Could not be sent",
        backgroundColor: Colors.red.withOpacity(0.65),
      );
    }
  }

  Future<void> submit() async {
    setState(() {
      showSpinner = true;
    });

    var uri = Uri.parse("${GlobalData.baseUrl}/parantsDoubt?");

    var request = http.MultipartRequest('POST', uri);

    request.fields['authKey'] = GlobalData.auth1;
    request.fields['title'] = tfTitle.text.toString().trim();
    request.fields['disc'] = tfDescription.text.toString().trim();
    request.fields['email'] = tfEmail.text.toString().trim();
    request.fields['student_id'] = GlobalStudent.id.toString();

    var multiPart;

    if (image != null) {
      var stream = http.ByteStream(image!.openRead());
      stream.cast();
      var len = await image!.length();
      multiPart = http.MultipartFile(
        'image',
        () async* {
          yield* image!.openRead();
        }(),
        len,
        filename: image!.path,
      );
      request.files.add(multiPart);
    }

    try {
      var response = await request.send();

      if (response.statusCode == 200) {
        var httpResponse = await http.Response.fromStream(response);
        var jsonResponse = json.decode(httpResponse.body);
        print(jsonResponse);
        String msg = jsonResponse["Message"].toString();
        if (msg == "Doubt sent successfully") {
          setState(() {
            showSpinner = false;
          });
          Get.snackbar(
            "Success",
            'Sent',
            backgroundColor: Colors.green.withOpacity(0.65),
          );
        } else {
          setState(() {
            showSpinner = false;
          });
          nextScreen(context, ErrorScreen(message: msg));
        }
      } else {
        setState(() {
          showSpinner = false;
        });
        Get.snackbar(
          "Error",
          "Try again later",
          backgroundColor: Colors.red.withOpacity(0.65),
        );
        print('API request failed with status code ${response.statusCode}');
      }
    } catch (e) {
      Get.snackbar(
        "Error",
        "Try again",
        backgroundColor: Colors.red.withOpacity(0.65),
      );
      setState(() {
        showSpinner = false;
      });
      print('API request failed with exception: $e');
    }
    setState(() {
      showSpinner = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return ModalProgressHUD(
      inAsyncCall: showSpinner,
      child: Scaffold(
        appBar: customAppbar2(context, 'Parents Doubts'),
        body: Padding(
          padding: const EdgeInsets.all(12.0),
          child: SingleChildScrollView(
            child: Column(
              children: [
                addVerticalSpace(2.h),
                CustomTextfield(
                  hintext: 'Title',
                  controller: tfTitle,
                ),
                addVerticalSpace(4.h),
                CustomTextfield(
                  hintext: 'Email',
                  controller: tfEmail,
                ),
                addVerticalSpace(4.h),
                CustomTextfieldMaxLine(
                  hintext: 'Description',
                  controller: tfDescription,
                ),
                addVerticalSpace(6.h),
                SizedBox(
                  width: 50.w,
                  child: CustomButton(
                    text: 'Submit',
                    onTap: () {
                      if (tfDescription.text.isNotEmpty &&
                          tfTitle.text.isNotEmpty) {
                        submit();
                      } else {
                        Get.snackbar(
                          "Error",
                          "Fill the text fields",
                          backgroundColor: Colors.red.withOpacity(0.65),
                        );
                      }
                    },
                  ),
                ),
                addVerticalSpace(6.5.h),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    InkWell(
                      onTap: () async {
                        final pickedFile = await _picker.pickImage(
                          source: ImageSource.gallery,
                          imageQuality: 80,
                        );

                        if (pickedFile != null) {
                          image = File(pickedFile.path);
                          Get.snackbar(
                            "Success",
                            "Image Selected Successfully",
                            backgroundColor: Colors.green.withOpacity(0.65),
                          );
                          setState(() {
                            showSpinner = false;
                            nextScreen(
                              context,
                              ImageOpener(
                                send: false,
                                imageFile: image,
                                showOnly: false,
                                baseurl: "/jns",
                              ),
                            );
                          });
                        } else {
                          Get.snackbar(
                            "Error",
                            "Image Not Uploaded",
                            backgroundColor: Colors.red.withOpacity(0.65),
                          );
                          print("No image selected");
                        }
                      },
                      child: Container(
                        height: 16.h,
                        width: 42.w,
                        decoration:
                            kGradientBoxDecoration(30, purpleGradident()),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            SizedBox(
                                height: 7.h,
                                child: Image.asset('assets/images/camera.png')),
                            Text(
                              'Attache File',
                              style: kBodyText16wBold(white),
                            )
                          ],
                        ),
                      ),
                    ),
                    InkWell(
                      onTap: () {
                        // _launchPhone('8577098983');
                        nextScreen(context, TeachersListScreen());
                      },
                      child: Container(
                        height: 16.h,
                        width: 42.w,
                        decoration:
                            kGradientBoxDecoration(30, purpleGradident()),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            SizedBox(
                                height: 7.h,
                                child: Image.asset('assets/images/phone1.png')),
                            Text(
                              'Call',
                              style: kBodyText16wBold(white),
                            )
                          ],
                        ),
                      ),
                    ),
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
