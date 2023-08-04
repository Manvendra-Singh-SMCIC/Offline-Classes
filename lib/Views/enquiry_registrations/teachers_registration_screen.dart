import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:http/http.dart' as http;
import 'package:offline_classes/Views/enquiry_registrations/error_screen.dart';
import 'package:offline_classes/global_data/GlobalData.dart';
import 'package:offline_classes/razorpay_payments/razorpay_screen.dart';
import 'package:offline_classes/utils/my_appbar.dart';
import 'package:offline_classes/widget/custom_textfield.dart';
import 'package:sizer/sizer.dart';

import '../../model/statics_list.dart';
import '../../utils/constants.dart';
import '../../widget/custom_button.dart';
import '../../widget/custom_item_seleted_field.dart';

class TeacherRegistration extends StatefulWidget {
  const TeacherRegistration({super.key});

  @override
  State<TeacherRegistration> createState() => _TeacherRegistrationState();
}

class _TeacherRegistrationState extends State<TeacherRegistration> {
  final TextEditingController datofBirthControler = TextEditingController();
  String drodownValue = 'Gender';
  String classValue = 'Class';
  String stateValue = 'State';
  String cityValue = 'City/Town';
  String qaulificationValue = 'Qualification';
  String expValue = 'Experience';
  List genderList = ['Gender', 'Male', 'Female', 'Others'];
  bool isSelect = false;
  bool isMedium = false;
  bool isSubject = false;
  bool isPrefferedClass = false;
  bool isAgree = false;
  int? selectStudent;
  int? selectMedium;
  int? selectedSubject;
  int? selectedClass;

  ImagePicker picker = ImagePicker();
  bool showSpinner = false;

  @override
  void initState() {
    getAllImages();
    super.initState();
  }

  TextEditingController tfname = TextEditingController();
  TextEditingController tffname = TextEditingController();
  TextEditingController tfmname = TextEditingController();
  TextEditingController tfphno = TextEditingController();
  TextEditingController tfschool = TextEditingController();
  TextEditingController tfcity = TextEditingController();
  TextEditingController tfpin = TextEditingController();
  TextEditingController tfarea = TextEditingController();
  TextEditingController tfcadd = TextEditingController();
  TextEditingController tfpadd = TextEditingController();

  List<String> imageText = ["Photo", "Aadhar Card", "Signatures"];

  List<String> preferredClass = [];
  String medium = "";
  String subject = "";
  int pf = 0;
  String prefClass = "LKG - UKG";

  File? photo, aadhar;

  List<File?> allImages = List<File?>.filled(2, null);

  getAllImages() {
    allImages = [photo, aadhar];
  }

  Future<void> postData() async {
    setState(() {
      showSpinner = true;
    });

    var stream1 = http.ByteStream(allImages[0]!.openRead());
    var stream2 = http.ByteStream(allImages[1]!.openRead());
    stream1.cast();
    stream2.cast();
    var len1 = await allImages[0]!.length();
    var len2 = await allImages[1]!.length();

    var uri = Uri.parse("https://trusir.com/api/teacherRegister");

    var request = http.MultipartRequest('POST', uri);

    request.fields['authKey'] = GlobalData.auth1;
    request.fields['teachername'] = tfname.text.toString();
    request.fields['gender'] = drodownValue;
    request.fields['dob'] = datofBirthControler.text.toString();
    request.fields['father'] = tffname.text;
    request.fields['mother'] = tfmname.text;
    request.fields['state'] = stateValue;
    request.fields['city'] = cityValue;
    request.fields['area'] = tfarea.text;
    request.fields['fulladd'] = tfcadd.text;
    request.fields['school'] = tfschool.text;
    request.fields['medium'] = medium;
    request.fields['class'] = classValue;
    request.fields['subject'] = subject;
    request.fields['pincode'] = tfpin.text;
    request.fields['exp'] = expValue.trim()[0];
    request.fields['qualification'] = qaulificationValue;
    request.fields['mobile'] = GlobalData.phoneNumber.substring(1);

    var multiPart1 = http.MultipartFile(
      'image',
      () async* {
        yield* allImages[0]!.openRead();
      }(),
      len1,
      filename: allImages[0]!.path,
    );

    var multiPart2 = http.MultipartFile(
      'aadhar',
      () async* {
        yield* allImages[1]!.openRead();
      }(),
      len2,
      filename: allImages[1]!.path,
    );

    request.files.add(multiPart1);
    request.files.add(multiPart2);

    try {
      var response = await request.send();

      print("Code" + response.statusCode.toString());

      if (response.statusCode == 200) {
        print(expValue);
        var httpResponse = await http.Response.fromStream(response);
        var jsonResponse = json.decode(httpResponse.body);
        String msg = jsonResponse["message"].toString();
        if (msg == "Registrtion successfull") {
          setState(() {
            showSpinner = false;
          });
          nextScreen(
              context,
              RazorpayScreen(
                amount: 299.00,
                role: 'teacher',
                payment_type: "teacher registration",
              ));
        } else {
          setState(() {
            showSpinner = false;
          });
          nextScreen(context, ErrorScreen(message: msg));
        }
      } else {
        var httpResponse = await http.Response.fromStream(response);
        var jsonResponse = json.decode(httpResponse.body);
        print(jsonResponse);
        print(GlobalData.phoneNumber);
        setState(() {
          showSpinner = false;
        });
        Get.snackbar(
          "Error",
          "Try again",
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
    tfphno.text = GlobalData.phoneNumber.substring(1);
    return ModalProgressHUD(
      inAsyncCall: showSpinner,
      child: Scaffold(
        appBar: customAppbar2(context, ''),
        body: Padding(
          padding: const EdgeInsets.all(12.0),
          child: SingleChildScrollView(
            child: Column(
              children: [
                Stack(
                  children: [
                    Container(
                      height: 33.h,
                      width: 95.w,
                      margin: EdgeInsets.only(bottom: 20),
                      decoration: kGradientBoxDecoration(42, purpleGradident()),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          SizedBox(
                              height: 18.h,
                              child: Image.asset('assets/images/teacher2.png')),
                        ],
                      ),
                    ),
                    Container(
                      height: 33.h,
                      width: 95.w,
                      color: Colors.transparent,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Container(
                            height: 18.h,
                          ),
                          Container(
                            child: Text(
                              "   Teacher \nRegistration",
                              style: kBodyText25Bold(white),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                addVerticalSpace(30),
                CustomTextfield(
                  hintext: "Teacher Name",
                  controller: tfname,
                ),
                addVerticalSpace(15),
                CustomTextfield(
                  hintext: "Father's Name",
                  controller: tffname,
                ),
                addVerticalSpace(15),
                CustomTextfield(
                  hintext: "Mother's Name",
                  controller: tfmname,
                ),
                addVerticalSpace(15),
                Row(
                  children: [
                    Container(
                      height: 8.5.h,
                      width: 45.w,
                      padding: EdgeInsets.symmetric(
                        horizontal: 9.w,
                      ),
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
                          value: drodownValue,
                          hint: const Text(
                            'Select',
                            style: TextStyle(
                                fontSize: 14,
                                color: Color(0xffB1B1B3),
                                fontWeight: FontWeight.w400),
                          ),
                          icon: const Icon(
                            Icons.keyboard_arrow_down_rounded,
                            color: textColor,
                            size: 30,
                          ),
                          // elevation: 10,
                          style: kBodyText14w500(Color(0xffA4A4A4)),

                          borderRadius: BorderRadius.all(Radius.circular(5)),
                          isExpanded: true,
                          underline: SizedBox(),
                          onChanged: (String? newValue) {
                            setState(() {
                              drodownValue = newValue!;
                            });
                          },
                          items:
                              genderList.map<DropdownMenuItem<String>>((value) {
                            return DropdownMenuItem<String>(
                              value: value,
                              child: Text(
                                value,
                                style: kBodyText14w500(Color(0xffA4A4A4)),
                              ),
                            );
                          }).toList(),
                        ),
                      ),
                    ),
                    Spacer(),
                    SizedBox(
                      height: 8.5.h,
                      width: 46.w,
                      child: CustomTextfield(
                        controller: datofBirthControler,
                        onTap: () {
                          pickDate();
                        },
                        hintext: 'DOB',
                        sufixIcon: Icons.calendar_month,
                      ),
                    )
                  ],
                ),
                addVerticalSpace(15),
                CustomTextfield(
                  controller: tfphno,
                  readOnly: true,
                  hintext: "Phone Number",
                  keyBoardType: TextInputType.number,
                ),
                addVerticalSpace(15),
                CustomTextfield(
                  controller: tfschool,
                  hintext: "School",
                ),
                addVerticalSpace(15),
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
                      value: qaulificationValue,
                      hint: const Text(
                        'Select',
                        style: TextStyle(
                            fontSize: 14,
                            color: Color(0xffB1B1B3),
                            fontWeight: FontWeight.w500),
                      ),
                      icon: const Icon(
                        Icons.keyboard_arrow_down_rounded,
                        color: textColor,
                        size: 30,
                      ),
                      // elevation: 10,
                      style: kBodyText14w500(Color(0xffA4A4A4)),

                      borderRadius: BorderRadius.all(Radius.circular(5)),
                      isExpanded: true,
                      underline: SizedBox(),
                      onChanged: (String? newValue) {
                        setState(() {
                          qaulificationValue = newValue!;
                        });
                      },
                      items: [
                        'Qualification',
                        'Non-Matric',
                        'Matric',
                        'Intermidiate',
                        'Graduated',
                        'Under-graduated',
                        'Post-graduated'
                      ].map<DropdownMenuItem<String>>((value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(
                            value,
                            style: kBodyText14w500(Color(0xffA4A4A4)),
                          ),
                        );
                      }).toList(),
                    ),
                  ),
                ),
                addVerticalSpace(15),
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
                      value: expValue,
                      hint: Text(
                        'Select',
                        style: kBodyText14w500(Color(0xffA4A4A4)),
                      ),
                      icon: const Icon(
                        Icons.keyboard_arrow_down_rounded,
                        color: textColor,
                        size: 30,
                      ),
                      // elevation: 10,
                      style: kBodyText14w500(Color(0xffA4A4A4)),

                      borderRadius: BorderRadius.all(Radius.circular(5)),
                      isExpanded: true,
                      underline: SizedBox(),
                      onChanged: (String? newValue) {
                        setState(() {
                          expValue = newValue!;
                        });
                      },
                      items: [
                        'Experience',
                        '1 Year',
                        '2 Year',
                        '3 Year',
                        '4 Year',
                        '5 Year',
                      ].map<DropdownMenuItem<String>>((value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(
                            value,
                            style: kBodyText14w500(Color(0xffA4A4A4)),
                          ),
                        );
                      }).toList(),
                    ),
                  ),
                ),
                addVerticalSpace(15),
                CustomItemSelectedField(
                  onTap: () {
                    isPrefferedClass = !isPrefferedClass;
                    setState(() {});
                  },
                  title: 'Preferred Class',
                  isChanged: isPrefferedClass,
                ),
                if (isPrefferedClass)
                  Column(
                    children: [
                      addVerticalSpace(10),
                      Padding(
                        padding: const EdgeInsets.only(left: 12.0),
                        child: SizedBox(
                          // height: height(context) * 0.2,
                          width: width(context) * 0.99,
                          child: GridView.builder(
                              shrinkWrap: true,
                              physics: NeverScrollableScrollPhysics(),
                              gridDelegate:
                                  SliverGridDelegateWithFixedCrossAxisCount(
                                      crossAxisCount: 2,
                                      childAspectRatio: 2.8,
                                      crossAxisSpacing: 8),
                              itemCount: classList.length,

                              // scrollDirection: Axis.horizontal,
                              itemBuilder: (ctx, i) {
                                return Row(
                                  children: [
                                    // addHorizontalySpace(10),
                                    InkWell(
                                      onTap: () {
                                        setState(() {
                                          pf = i;
                                          classList[i]['select'] =
                                              !classList[i]['select'];
                                          classValue = classList[i]['title'];
                                        });
                                      },
                                      child: Container(
                                        height: 45,
                                        width: 45,
                                        decoration:
                                            // classList[i]['select'] == true
                                            pf == i
                                                ? kGradientBoxDecoration2(
                                                    10, greenGradient())
                                                : k3DboxDecoration(10),
                                        child: pf == i
                                            // classList[i]['select'] == true
                                            ? const Icon(
                                                Icons.check,
                                                color: white,
                                                size: 40,
                                              )
                                            : SizedBox(),
                                      ),
                                    ),
                                    addHorizontalySpace(10),
                                    Text(
                                      classList[i]['title'],
                                      style: kBodyText14wBold(textColor),
                                    ),
                                    // addHorizontalySpace(15)
                                  ],
                                );
                              }),
                        ),
                      ),
                    ],
                  ),
                addVerticalSpace(10),
                CustomItemSelectedField(
                  onTap: () {
                    isMedium = !isMedium;
                    setState(() {});
                  },
                  title: 'Medium',
                  isChanged: isMedium,
                ),
                if (isMedium)
                  Column(
                    children: [
                      addVerticalSpace(10),
                      SizedBox(
                        height: 60,
                        child: ListView.builder(
                            itemCount: mediumList.length,
                            scrollDirection: Axis.horizontal,
                            itemBuilder: (ctx, i) {
                              return Row(
                                children: [
                                  addHorizontalySpace(10),
                                  InkWell(
                                    onTap: () {
                                      selectMedium = i;
                                      setState(() {
                                        medium = mediumList[i];
                                      });
                                    },
                                    child: Container(
                                      height: 45,
                                      width: 45,
                                      decoration: selectMedium == i
                                          ? kGradientBoxDecoration2(
                                              10, greenGradient())
                                          : k3DboxDecoration(10),
                                      child: selectMedium == i
                                          ? const Icon(
                                              Icons.check,
                                              color: white,
                                              size: 40,
                                            )
                                          : SizedBox(),
                                    ),
                                  ),
                                  addHorizontalySpace(10),
                                  Text(
                                    mediumList[i],
                                    style: kBodyText16wNormal(textColor),
                                  ),
                                  addHorizontalySpace(15)
                                ],
                              );
                            }),
                      ),
                    ],
                  ),
                addVerticalSpace(10),
                CustomItemSelectedField(
                  onTap: () {
                    isSubject = !isSubject;
                    setState(() {});
                  },
                  title: 'Subject',
                  isChanged: isSubject,
                ),
                if (isSubject)
                  Column(
                    children: [
                      addVerticalSpace(10),
                      SizedBox(
                        // height: height(context) * 0.2,
                        width: width(context) * 0.99,
                        child: GridView.builder(
                            shrinkWrap: true,
                            physics: NeverScrollableScrollPhysics(),
                            gridDelegate:
                                SliverGridDelegateWithFixedCrossAxisCount(
                                    crossAxisCount: 3,
                                    childAspectRatio: 1.8,
                                    crossAxisSpacing: 8),
                            itemCount: subjectList2.length,

                            // scrollDirection: Axis.horizontal,
                            itemBuilder: (ctx, i) {
                              return Row(
                                children: [
                                  // addHorizontalySpace(10),
                                  InkWell(
                                    onTap: () {
                                      selectedSubject = i;
                                      setState(() {
                                        subject = subjectList2[i];
                                      });
                                    },
                                    child: Container(
                                      height: 45,
                                      width: 45,
                                      decoration: selectedSubject == i
                                          ? kGradientBoxDecoration2(
                                              10, greenGradient())
                                          : k3DboxDecoration(10),
                                      child: selectedSubject == i
                                          ? const Icon(
                                              Icons.check,
                                              color: white,
                                              size: 40,
                                            )
                                          : SizedBox(),
                                    ),
                                  ),
                                  addHorizontalySpace(6),
                                  SizedBox(
                                    width: width(context) * 0.15,
                                    child: Text(
                                      subjectList2[i],
                                      style: kBodyText10wBold(textColor),
                                    ),
                                  ),
                                  // addHorizontalySpace(15)
                                ],
                              );
                            }),
                      ),
                    ],
                  ),
                addVerticalSpace(10),
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
                      value: stateValue,
                      hint: Text(
                        'Select',
                        style: kBodyText14w500(Color(0xffA4A4A4)),
                      ),
                      icon: const Icon(
                        Icons.keyboard_arrow_down_rounded,
                        color: textColor,
                        size: 30,
                      ),
                      // elevation: 10,
                      style: kBodyText14w500(Color(0xffA4A4A4)),

                      borderRadius: BorderRadius.all(Radius.circular(5)),
                      isExpanded: true,
                      underline: SizedBox(),
                      onChanged: (String? newValue) {
                        setState(() {
                          stateValue = newValue!;
                        });
                      },
                      items:
                          indianStates.map<DropdownMenuItem<String>>((value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(
                            value,
                            style: kBodyText14w500(Color(0xffA4A4A4)),
                          ),
                        );
                      }).toList(),
                    ),
                  ),
                ),
                addVerticalSpace(15),
                CustomTextfield(
                  controller: tfcity,
                  hintext: "City",
                ),
                addVerticalSpace(15),
                CustomTextfield(
                  controller: tfarea,
                  hintext: "Mohalla/Area",
                ),
                addVerticalSpace(15),
                CustomTextfield(
                  hintext: "Pincode",
                  controller: tfpin,
                  keyBoardType: TextInputType.number,
                ),
                addVerticalSpace(15),
                CustomTextfieldMaxLine(
                  hintext: 'Current Full Address',
                  controller: tfcadd,
                ),
                addVerticalSpace(15),
                CustomTextfieldMaxLine(
                  hintext: 'Permanent Full Address',
                  controller: tfpadd,
                ),
                addVerticalSpace(25),
                Column(
                  children: List.generate(2, (index) {
                    return Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text(
                              imageText[index],
                              style: kBodyText16wBold(black),
                            ),
                            GestureDetector(
                              onTap: () async {
                                final pickedFile = await picker.pickImage(
                                  source: ImageSource.gallery,
                                  imageQuality: 80,
                                );

                                if (pickedFile != null) {
                                  File image = File(pickedFile.path);
                                  allImages[index] = image;
                                  Get.snackbar(
                                    "Success",
                                    "Image Uploaded",
                                    backgroundColor:
                                        Colors.green.withOpacity(0.65),
                                  );
                                  setState(() {
                                    showSpinner = false;
                                  });
                                } else {
                                  Get.snackbar(
                                    "Error",
                                    "Image Not Uploaded",
                                    backgroundColor:
                                        Colors.red.withOpacity(0.65),
                                  );
                                  print("No image selected");
                                }
                              },
                              child: Container(
                                height: 7.h,
                                width: 55.w,
                                decoration: k3DboxDecoration(14),
                                child: Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceEvenly,
                                    children: [
                                      Icon(
                                        Icons.upload,
                                        size: 30,
                                        color: allImages[index] == null
                                            ? Color(0xffA4A4A4)
                                            : Colors.transparent,
                                      ),
                                      Text(
                                        allImages[index] == null
                                            ? 'Upload Image'
                                            : 'Uploaded',
                                        style:
                                            kBodyText14w500(Color(0xffA4A4A4)),
                                      )
                                    ]),
                              ),
                            )
                          ],
                        ),
                        addVerticalSpace(20),
                      ],
                    );
                  }),
                ),
                addVerticalSpace(5.h),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    InkWell(
                      onTap: () {
                        isAgree = !isAgree;
                        setState(() {});
                      },
                      child: Container(
                        height: 45,
                        width: 45,
                        decoration: isAgree
                            ? kGradientBoxDecoration2(10, greenGradient())
                            : k3DboxDecoration(10),
                        child: isAgree
                            ? const Icon(
                                Icons.check,
                                color: white,
                                size: 40,
                              )
                            : SizedBox(),
                      ),
                    ),
                    SizedBox(
                      width: 76.w,
                      child: RichText(
                          text: TextSpan(children: [
                        TextSpan(
                            text: 'I agree with the ',
                            style: kBodyText15wNormal(black)),
                        TextSpan(
                            text: 'terms and conditions',
                            style: TextStyle(
                                fontSize: 15.sp,
                                color: black,
                                decoration: TextDecoration.underline))
                      ])),
                    )
                  ],
                ),
                addVerticalSpace(3.h),
                Text(
                  '299/- Registration Fee',
                  style: kBodyText20wBold(green),
                ),
                addVerticalSpace(5.h),
                CustomButton(
                    text: 'Register',
                    onTap: () {
                      if (isAgree == true) {
                        try {
                          String text = "";
                          for (var j = 0; j < 2; j++) {
                            text += "${allImages[j]!.path}\n\n";
                          }
                          if (tfname.text.isNotEmpty &&
                              tffname.text.isNotEmpty &&
                              tfmname.text.isNotEmpty &&
                              datofBirthControler.text.isNotEmpty &&
                              drodownValue != 'Gender' &&
                              tfphno.text.isNotEmpty &&
                              qaulificationValue != 'Qualification' &&
                              expValue != 'Experience' &&
                              classValue != "Class" &&
                              stateValue != "State" &&
                              medium != "Medium" &&
                              tfcity.text.isNotEmpty &&
                              tfarea.text.isNotEmpty &&
                              tfpin.text.isNotEmpty &&
                              tfcadd.text.isNotEmpty &&
                              tfpadd.text.isNotEmpty &&
                              allImages[0] != null &&
                              allImages[1] != null) {
                            print("Yah");
                            print(classValue);
                            postData();
                          } else {
                            Get.snackbar(
                              "Error",
                              "All Fields Mandatory",
                              backgroundColor: Colors.red.withOpacity(0.65),
                            );
                          }
                          //Get.to(() => Ztest(message: text));
                        } catch (e) {
                          Get.snackbar(
                            "Error",
                            "Select Images",
                            backgroundColor: Colors.red.withOpacity(0.65),
                          );
                        }
                        // nextScreen(
                        //     context,
                        //     RazorpayScreen(
                        //       amount: 299.00,
                        //       role: 'teacher',
                        //     ));
                      } else {
                        Get.snackbar(
                          "Error",
                          "Agree to the terms and conditions",
                          backgroundColor: Colors.red.withOpacity(0.65),
                        );
                      }
                    }),
                addVerticalSpace(20),
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
