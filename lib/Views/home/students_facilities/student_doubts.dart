import 'dart:convert';
import 'dart:io';
import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:offline_classes/Views/home/students_facilities/select_teacher_for_call.dart';
import 'package:offline_classes/utils/constants.dart';
import 'package:offline_classes/utils/my_appbar.dart';
import 'package:photo_view/photo_view.dart';
import 'package:sizer/sizer.dart';

import '../../../global_data/GlobalData.dart';
import '../../../global_data/student_global_data.dart';
import '../../../widget/custom_button.dart';
import '../../../widget/custom_textfield.dart';
import '../../../widget/image_opener.dart';
import '../../enquiry_registrations/error_screen.dart';

class StudentsDoubts extends StatefulWidget {
  const StudentsDoubts({super.key});

  @override
  State<StudentsDoubts> createState() => _StudentsDoubtsState();
}

class _StudentsDoubtsState extends State<StudentsDoubts> {
  File? image;
  bool showSpinner = false;
  ImagePicker picker = ImagePicker();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: customAppbar2(context, 'Student Doubts'),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Center(
            child: InkWell(
              onTap: () async {
                final pickedFile = await picker.pickImage(
                  source: ImageSource.gallery,
                  imageQuality: 80,
                );

                if (pickedFile != null) {
                  image = File(pickedFile.path);
                  Get.snackbar(
                    "Success",
                    "Image Selected Successflly",
                    backgroundColor: Colors.green.withOpacity(0.65),
                  );
                  setState(() {
                    showSpinner = false;
                  });
                  nextScreen(
                      context,
                      MyImageOpener(
                        imageFile: image,
                        showOnly: false,
                        send: true,
                      ));
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
                height: 25.h,
                width: 90.w,
                decoration: kGradientBoxDecoration(60, purpleGradident()),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    SizedBox(
                        height: 12.h,
                        child: Image.asset('assets/images/camera.png')),
                    Text(
                      'Upload From Gallery',
                      style: kBodyText20wBold(white),
                    )
                  ],
                ),
              ),
            ),
          ),
          addVerticalSpace(4.h),
          Center(
            child: InkWell(
              onTap: () {
                nextScreen(context, SelectTeacherForCall());
              },
              child: Container(
                height: 25.h,
                width: 90.w,
                decoration: kGradientBoxDecoration(60, purpleGradident()),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    SizedBox(
                        height: 12.h,
                        child: Image.asset('assets/images/phone1.png')),
                    Text(
                      'Call Teacher',
                      style: kBodyText20wBold(white),
                    )
                  ],
                ),
              ),
            ),
          ),
          addVerticalSpace(5.h)
        ],
      ),
    );
  }
}

class MyImageOpener extends StatelessWidget {
  final File? imageFile;
  final String? baseurl;
  final bool showOnly;
  final bool send;

  const MyImageOpener({
    super.key,
    required this.imageFile,
    this.baseurl = "",
    required this.showOnly,
    required this.send,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: customAppbar2(context, "Send Doubt"),
      body: Center(
        child: imageFile != null
            ? PhotoView(
                imageProvider: FileImage(imageFile!),
                minScale: PhotoViewComputedScale.contained,
                maxScale: PhotoViewComputedScale.covered * 2.0,
              )
            : Text('No Image Selected'),
      ),
      bottomNavigationBar: showOnly
          ? null
          : Container(
              padding: EdgeInsets.only(left: 30, right: 30, bottom: 5, top: 5),
              color: Colors.transparent,
              width: 25.w,
              child: CustomButton(
                text: send ? 'Send' : 'Done',
                onTap: () {
                  !send
                      ? goBack(context)
                      : (imageFile != null
                          ? nextScreen(context, SelectTeacher(image: imageFile))
                          : Get.snackbar(
                              "Error",
                              "No image selected",
                              backgroundColor: Colors.red.withOpacity(0.65),
                            ));
                },
              ),
            ),
    );
  }
}

class SelectTeacher extends StatefulWidget {
  const SelectTeacher({super.key, required this.image});
  final File? image;

  @override
  State<SelectTeacher> createState() => _SelectTeacherState();
}

class _SelectTeacherState extends State<SelectTeacher> {
  bool showSpinner = false;

  Future<void> getTeacherList() async {
    final http.Response response = await http.get(Uri.parse(
        "${GlobalData.baseUrl}/teacherAssign?authKey=${GlobalData.auth1}&student_id=${GlobalStudent.id}"));
    teacherList = json.decode(response.body);
    if (response.statusCode == 200) {
      print(teacherList);
    } else {
      print("Unsuccessful");
    }
  }

  Map<String, dynamic> teacherList = {};

  Future<void> submit(int id, String title, String desc) async {
    setState(() {
      showSpinner = true;
    });

    var uri = Uri.parse("${GlobalData.baseUrl}/addstudentDoubt?");

    var request = http.MultipartRequest('POST', uri);
    print(id);
    request.fields['authKey'] = GlobalData.auth1;
    request.fields['student_id'] = GlobalStudent.id.toString();
    request.fields['teacher_id'] = id.toString();
    request.fields['title'] = title.toString();
    request.fields['desc'] = desc.toString();

    var multiPart;

    if (widget.image != null) {
      var stream = http.ByteStream(widget.image!.openRead());
      stream.cast();
      var len = await widget.image!.length();
      multiPart = http.MultipartFile(
        'image',
        () async* {
          yield* widget.image!.openRead();
        }(),
        len,
        filename: widget.image!.path,
      );
      request.files.add(multiPart);
    }

    try {
      var response = await request.send();
      log(response.statusCode.toString());
      if (response.statusCode == 200) {
        log(response.statusCode.toString());
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
      child: FutureBuilder(
        future: getTeacherList(),
        builder: (context, snapshot) {
          if (teacherList.isEmpty) {
            return Center(child: CircularProgressIndicator(color: primary2));
          } else {
            return Scaffold(
              appBar: customAppbar2(context, 'Select Teachers'),
              body: Column(
                children: [
                  addVerticalSpace(10),
                  Expanded(
                    child: ListView.builder(
                      itemCount: teacherList["data"].length,
                      itemBuilder: (ctx, i) {
                        TextEditingController title = TextEditingController();
                        TextEditingController desc = TextEditingController();
                        return InkWell(
                          onTap: () {
                            if (title.text.trim().toString().isNotEmpty &&
                                desc.text.trim().toString().isNotEmpty) {
                              submit(
                                  teacherList["data"][i]["id"],
                                  title.text.trim().toString(),
                                  desc.text.trim().toString());
                            } else {
                              Get.snackbar(
                                "Error",
                                "Enter title and description",
                                backgroundColor: Colors.red.withOpacity(0.65),
                              );
                            }
                          },
                          child: Container(
                            margin: EdgeInsets.only(bottom: 10),
                            child: Column(
                              children: [
                                Container(
                                  margin: EdgeInsets.all(10),
                                  padding: EdgeInsets.all(12),
                                  // height: 12.h,
                                  width: 93.w,
                                  decoration: kGradientBoxDecoration(
                                      35, purpleGradident()),
                                  child: Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      Container(
                                        height: 11.h,
                                        width: 25.w,
                                        decoration: kGradientBoxDecoration(
                                            18, orangeGradient()),
                                        child: ClipRRect(
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(12)),
                                          child: Image.network(
                                            GlobalStudent.urlPrefix +
                                                teacherList["data"][i]["image"],
                                            fit: BoxFit.cover,
                                          ),
                                        ),
                                      ),
                                      addHorizontalySpace(
                                          width(context) * 0.06),
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceEvenly,
                                        children: [
                                          SingleChildScrollView(
                                            scrollDirection: Axis.horizontal,
                                            child: Text(
                                              teacherList["data"][i]["name"],
                                              style: kBodyText22bold(white),
                                            ),
                                          ),
                                          addVerticalSpace(10),
                                          Text(
                                            teacherList["data"][i]["subject"],
                                            style: kBodyText18wNormal(white),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                                addVerticalSpace(5),
                                CustomTextfield(
                                  controller: title,
                                  hintext: 'Title',
                                ),
                                addVerticalSpace(5),
                                CustomTextfield(
                                  controller: desc,
                                  hintext: 'Description',
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            );
          }
        },
      ),
    );
  }
}
