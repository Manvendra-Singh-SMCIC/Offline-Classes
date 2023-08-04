import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http_parser/http_parser.dart';
import 'package:image_picker/image_picker.dart';

import 'package:intl/intl.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:http/http.dart' as http;
import 'package:offline_classes/global_data/student_global_data.dart';
import 'package:offline_classes/global_data/teacher_global_data.dart';
import 'package:offline_classes/utils/my_appbar.dart';
import 'package:offline_classes/widget/custom_textfield.dart';
import 'package:offline_classes/widget/image_opener.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sizer/sizer.dart';

import '../../../global_data/GlobalData.dart';
import '../../../utils/constants.dart';
import '../../../widget/custom_button.dart';
import '../../enquiry_registrations/error_screen.dart';

class TeacherProfileEdit extends StatefulWidget {
  const TeacherProfileEdit({super.key});

  @override
  State<TeacherProfileEdit> createState() => _TeacherProfileEditState();
}

class _TeacherProfileEditState extends State<TeacherProfileEdit> {
  TextEditingController datofBirthControler = TextEditingController();
  TextEditingController tfname = TextEditingController();
  TextEditingController tfclass = TextEditingController();
  TextEditingController tfsubject = TextEditingController();
  TextEditingController tfmedium = TextEditingController();
  TextEditingController tfadd = TextEditingController();

  bool showSpinner = false;

  @override
  initState() {
    datofBirthControler.text = GlobalTeacher.profile["data"][0]["dob"];
    tfname.text = GlobalTeacher.profile["data"][0]["name"];
    tfsubject.text = GlobalTeacher.profile["data"][0]["subject"];
    tfclass.text = GlobalTeacher.profile["data"][0]["preferd_class"];
    tfmedium.text = GlobalTeacher.profile["data"][0]["medium"];
    tfadd.text = GlobalTeacher.profile["data"][0]["current_full_address"];
    super.initState();
  }

  String classValue = "Class";
  String subjectValue = "Subject";

  Future<File> convertImageUrlToFile(String imageUrl) async {
    var response = await http.get(Uri.parse(imageUrl));
    var filePath =
        await _localPath(); // Function to get the local directory path
    var fileName = imageUrl.split('/').last;

    File file = File('$filePath/$fileName');
    await file.writeAsBytes(response.bodyBytes);

    return file;
  }

  Future<String> _localPath() async {
    // Function to get the local directory path
    var directory = await getTemporaryDirectory();
    return directory.path;
  }

  Future<void> postData() async {
    setState(() {
      showSpinner = true;
    });

    var uri = Uri.parse("${GlobalData.baseUrl}/editTeacherProfile?");

    var request = http.MultipartRequest('POST', uri);

    request.fields['authKey'] = GlobalData.auth1;
    request.fields['teacher_id'] = GlobalTeacher.id.toString();
    request.fields['teacher_name'] = tfname.text.toString().trim();
    request.fields['dob'] = datofBirthControler.text.toString().trim();
    request.fields['class'] = classValue;
    request.fields['medium'] = tfmedium.text;
    request.fields['subject'] = subjectValue;
    request.fields['address'] = tfadd.text;

    http.MultipartFile multiPart;

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
    } else {
      try {
        var imageUrl =
            GlobalTeacher.urlPrefix + GlobalTeacher.profile["data"][0]["image"];
        File imageFile = await convertImageUrlToFile(imageUrl);
        request.files.add(http.MultipartFile(
          'image',
          imageFile.readAsBytes().asStream(),
          imageFile.lengthSync(),
          filename: imageFile.path.split('/').last,
          contentType: MediaType('image',
              'jpeg'), // Adjust the content type as per your image type
        ));
      } catch (e) {
        print(e);
      }
    }

    try {
      var response = await request.send();

      if (response.statusCode == 200) {
        var httpResponse = await http.Response.fromStream(response);
        var jsonResponse = json.decode(httpResponse.body);
        String msg = jsonResponse["Message"].toString();
        print(jsonResponse);
        if (msg == "Teacher Updated successfully") {
          setState(() {
            showSpinner = false;
          });
          Get.snackbar(
            "Done",
            "Updation successful",
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
          "Request Sent",
          "Changes may take some time to implement",
          backgroundColor: Colors.yellow.withOpacity(0.65),
        );
        print('API request failed with status code ${response.statusCode}');
      }
    } catch (e) {
      Get.snackbar(
        "Error",
        "Try again",
        backgroundColor: Colors.green.withOpacity(0.65),
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

  File? image;
  ImagePicker picker = ImagePicker();

  @override
  Widget build(BuildContext context) {
    return ModalProgressHUD(
      inAsyncCall: showSpinner,
      child: Scaffold(
        appBar: PreferredSize(
          preferredSize: const Size.fromHeight(60),
          child: AppBar(
            backgroundColor: white,
            foregroundColor: black,
            elevation: 0,
            leading: Container(
              margin: EdgeInsets.all(3),
              padding: EdgeInsets.symmetric(horizontal: 8),
              height: 50,
              width: 50,
              decoration: BoxDecoration(
                gradient: orangeGradient(),
                borderRadius: BorderRadius.all(Radius.circular(15)),
              ),
              child: Center(
                child: IconButton(
                    onPressed: () {
                      goBack(context);
                    },
                    icon: const Icon(
                      Icons.arrow_back_ios,
                      color: white,
                    )),
              ),
            ),
            title: Text(
              "Edit",
              style: kBodyText20wBold(primary),
            ),
          ),
        ),
        body: SingleChildScrollView(
          child: Center(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                addVerticalSpace(20),
                Center(
                  child: Container(
                    width: 40.w,
                    height: 40.w,
                    child: GestureDetector(
                      onTap: () async {
                        final pickedFile = await picker.pickImage(
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
                        } else {
                          Get.snackbar(
                            "Error",
                            "Image Not Selected",
                            backgroundColor: Colors.red.withOpacity(0.65),
                          );
                          print("No image selected");
                        }
                      },
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(20.w),
                        child: Image.network(
                          "${GlobalTeacher.urlPrefix}${GlobalTeacher.profile["data"][0]["image"]}",
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  ),
                ),
                addVerticalSpace(20),
                CustomTextfield(
                  hintext: 'Name',
                  controller: tfname,
                ),
                addVerticalSpace(20),
                CustomTextfield(
                  hintext: 'DOB',
                  controller: datofBirthControler,
                  onTap: () {
                    pickDate();
                  },
                  sufixIcon: Icons.calendar_month,
                ),
                addVerticalSpace(20),
                CustomTextfield(
                  hintext: 'Medium (English or Hindi)',
                  controller: tfmedium,
                ),
                addVerticalSpace(20),
                Container(
                  height: 8.5.h,
                  width: 95.w,
                  padding: EdgeInsets.only(left: 9.w, top: 7, right: 9.w),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(40),
                    boxShadow: [
                      const BoxShadow(
                        color: textColor,
                        offset: Offset(0, 3),
                      ),
                      BoxShadow(
                        color: white.withOpacity(0.95),
                        // spreadRadius: -2.0,
                        blurRadius: 7.0,
                      ),
                    ],
                  ),
                  child: Center(
                    child: DropdownButton<String>(
                      value: classValue,
                      hint: const Text(
                        'Select',
                        style: TextStyle(
                          fontSize: 14,
                          color: black,
                        ),
                      ),
                      icon: const Icon(
                        Icons.keyboard_arrow_down_rounded,
                        color: textColor,
                        size: 30,
                      ),
                      // elevation: 10,
                      style: const TextStyle(
                          color: textColor,
                          fontSize: 14,
                          fontWeight: FontWeight.w500),
                      borderRadius: BorderRadius.all(Radius.circular(5)),
                      isExpanded: true,
                      underline: SizedBox(),
                      onChanged: (String? newValue) {
                        setState(() {
                          tfclass.text = newValue!;
                          classValue = newValue;
                        });
                      },
                      items: GlobalTeacher.classes
                          .map<DropdownMenuItem<String>>((value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(
                            value,
                            style: kBodyText14wNormal(black),
                          ),
                        );
                      }).toList(),
                    ),
                  ),
                ),
                addVerticalSpace(20),
                Container(
                  height: 8.5.h,
                  width: 95.w,
                  padding: EdgeInsets.only(left: 9.w, top: 7, right: 9.w),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(40),
                    boxShadow: [
                      const BoxShadow(
                        color: textColor,
                        offset: Offset(0, 3),
                      ),
                      BoxShadow(
                        color: white.withOpacity(0.95),
                        // spreadRadius: -2.0,
                        blurRadius: 7.0,
                      ),
                    ],
                  ),
                  child: Center(
                    child: DropdownButton<String>(
                      value: subjectValue,
                      hint: const Text(
                        'Select',
                        style: TextStyle(
                          fontSize: 14,
                          color: black,
                        ),
                      ),
                      icon: const Icon(
                        Icons.keyboard_arrow_down_rounded,
                        color: textColor,
                        size: 30,
                      ),
                      // elevation: 10,
                      style: const TextStyle(
                          color: textColor,
                          fontSize: 14,
                          fontWeight: FontWeight.w500),
                      borderRadius: BorderRadius.all(Radius.circular(5)),
                      isExpanded: true,
                      underline: SizedBox(),
                      onChanged: (String? newValue) {
                        setState(() {
                          tfsubject.text = newValue!;
                          subjectValue = newValue;
                        });
                      },
                      items: GlobalTeacher.subjects
                          .map<DropdownMenuItem<String>>((value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(
                            value,
                            style: kBodyText14wNormal(black),
                          ),
                        );
                      }).toList(),
                    ),
                  ),
                ),
                addVerticalSpace(20),
                CustomTextfield(
                  hintext: 'Address',
                  controller: tfadd,
                ),
                addVerticalSpace(40),
                CustomButton(
                  text: 'Done',
                  onTap: () {
                    if (classValue != "Class" && subjectValue != "Subject") {
                      postData();
                    } else {
                      Get.snackbar(
                        "Error",
                        "Enter a valid value for Class/Subject",
                        backgroundColor: Colors.red.withOpacity(0.65),
                      );
                    }
                  },
                ),
                addVerticalSpace(40),
              ],
            ),
          ),
        ),
      ),
    );
  }

  pickDate() async {
    var pickedDate = await showDatePicker(
        context: context,
        initialDate: DateTime.now(),
        firstDate: DateTime(1947),
        lastDate: DateTime.now());
    if (pickedDate != null) {
      print(pickedDate);
      String formattedDate = DateFormat('dd-MM-yyyy').format(pickedDate);

      setState(() {
        datofBirthControler.text = formattedDate;
      });
    } else {
      print("Date is not selected");
    }
  }
}
