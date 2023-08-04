import 'dart:async';
import 'dart:convert';
import 'dart:developer';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:get/get.dart';
import 'package:offline_classes/Views/enquiry_registrations/student_registration.dart';
import 'package:offline_classes/Views/enquiry_registrations/teachers_registration_screen.dart';
import 'package:offline_classes/global_data/GlobalData.dart';
import 'package:offline_classes/global_data/student_global_data.dart';
import 'package:offline_classes/language/localizations.dart';
import 'package:http/http.dart' as http;
import 'package:offline_classes/model/statics_list.dart';
import 'package:offline_classes/utils/constants.dart';
import 'package:offline_classes/widget/custom_button.dart';
import 'package:offline_classes/widget/my_bottom_navbar.dart';
import 'package:sizer/sizer.dart';

import '../../global_data/teacher_global_data.dart';

class HomeScreenForRegisterUser extends StatefulWidget {
  const HomeScreenForRegisterUser({
    super.key,
    required this.whoAreYou,
    required this.serviceList,
    required this.sliderList,
  });
  final String whoAreYou;

  final List serviceList;
  final List sliderList;

  @override
  State<HomeScreenForRegisterUser> createState() =>
      _HomeScreenForRegisterUserState();
}

class _HomeScreenForRegisterUserState extends State<HomeScreenForRegisterUser> {
  String dropDownValue = 'Language';
  List dropDownList = ['Language', 'English', 'Hindi'];
  List cityList = [
    'Motihari',
    'Patna',
    'Tiruhat',
    'Saranj',
    'Gopaganj',
    'Dhardanga',
    'Siwan',
    'Bhojpur'
  ];
  final LocalizationController localizationController =
      Get.put(LocalizationController());

  List imgList2 = [
    'assets/images/banner.jpg',
    'assets/images/banner.jpg',
  ];

  int? selectedIndex;
  int? selectedIndex2;
  int? selectedIndex3;

  Future<void> getTestimonials() async {
    // log("${GlobalData.baseUrl}/studentHome?authKey=${GlobalData.auth1}&mobile=${GlobalData.phoneNumber.substring(1)}");
    final http.Response response = await http.get(Uri.parse(
        "${GlobalData.baseUrl}/studentHome?authKey=${GlobalData.auth1}&mobile=${GlobalData.phoneNumber.substring(1)}"));
    Homescr = json.decode(response.body);
    if (response.statusCode == 200) {
      // print(Homescr);
    } else {
      print("Unsuccessful");
    }
  }

  Map<String, dynamic> Homescr = {};

  @override
  Widget build(BuildContext context) {
    log(widget.whoAreYou);
    return FutureBuilder(
      future: getTestimonials(),
      builder: (context, snapshot) {
        if (Homescr.isEmpty) {
          return const Center(
              child: CircularProgressIndicator(color: primary2));
        } else {
          GlobalStudent.classes.clear();
          GlobalStudent.subjects.clear();
          GlobalStudent.classes.add("Class");
          GlobalStudent.subjects.add("Subject");
          for (Map<String, dynamic> map in Homescr["classes"]) {
            GlobalStudent.classes.add(map["class_name"]);
          }
          for (Map<String, dynamic> map in Homescr["subjects"]) {
            GlobalStudent.subjects.add(map["subject_name"]);
          }
          GlobalTeacher.classes.clear();
          GlobalTeacher.subjects.clear();
          GlobalTeacher.classes.add("Class");
          GlobalTeacher.subjects.add("Subject");
          for (Map<String, dynamic> map in Homescr["classes"]) {
            GlobalTeacher.classes.add(map["class_name"]);
          }
          for (Map<String, dynamic> map in Homescr["subjects"]) {
            GlobalTeacher.subjects.add(map["subject_name"]);
          }
          return Scaffold(
            appBar: AppBar(
              backgroundColor: Color(0xff48116a),
              elevation: 0,
              foregroundColor: white,
              leadingWidth: width(context) * 0.3,
              leading: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Image.asset("assets/images/logo.png"),
              ),
              actions: [
                Visibility(
                  visible: false,
                  child: DropdownButton<String>(
                    dropdownColor: Color(0xff48116a),
                    value: dropDownValue,
                    hint: const Text(
                      'Select',
                      style: TextStyle(
                          fontSize: 14,
                          color: Color(0xffB1B1B3),
                          fontWeight: FontWeight.w400),
                    ),
                    icon: const Icon(
                      Icons.keyboard_arrow_down_rounded,
                      color: white,
                      size: 26,
                    ),
                    // elevation: 10,
                    style: const TextStyle(
                        color: white,
                        fontSize: 18,
                        fontWeight: FontWeight.w500),
                    borderRadius: BorderRadius.all(Radius.circular(5)),
                    // isExpanded: true,s
                    underline: SizedBox(),
                    onChanged: (String? newValue) {
                      setState(() {
                        //localizationController.changeLanguage('hi');
                        dropDownValue = newValue!;
                      });
                      Get.snackbar(
                        "Feature currently not available",
                        "This feautre will be available soon",
                      );
                    },
                    items: dropDownList.map<DropdownMenuItem<String>>((value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(
                          value,
                          style: kBodyText14w500(white),
                        ),
                      );
                    }).toList(),
                  ),
                ),
              ],
            ),
            body: SingleChildScrollView(
              physics: BouncingScrollPhysics(),
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          GlobalData.role == 'student'
                              ? 'Hi ${GlobalStudent.specificProfile["data"][0]["name"]}'
                              : 'Hi ${GlobalTeacher.profile["data"][0]["name"]}',
                          style: TextStyle(
                              color: blue,
                              fontSize: 30.sp,
                              height: 1.1,
                              fontWeight: FontWeight.w800),
                        ),
                        addVerticalSpace(15),
                        StatefulBuilder(
                          builder: (context, setState) => CarouselSlider(
                            // carouselController: _carouselController,
                            options: CarouselOptions(
                                viewportFraction: 1,
                                enlargeCenterPage: true,
                                autoPlay: true,
                                // enlargeCenterPage: true,
                                height:
                                    MediaQuery.of(context).size.height * 0.2,
                                onPageChanged: (index, reason) {
                                  setState(() {
                                    // _current = index;
                                  });
                                }),
                            items: imgList2.map((i) {
                              return Builder(
                                builder: (BuildContext context) {
                                  return Container(
                                      height: height(context) * 0.2,
                                      width: width(context) * 0.9,
                                      // decoration: kFillBoxDecoration(0, textColor, 10),
                                      child: ClipRRect(
                                        borderRadius: BorderRadius.circular(10),
                                        child: Image.asset(
                                          i,
                                          fit: BoxFit.fill,
                                        ),
                                      ));
                                },
                              );
                            }).toList(),
                          ),
                        ),
                        addVerticalSpace(20),
                        Text(
                          'Why Home Tuition?',
                          style: kBodyText24wBold(primary),
                        ),
                        addVerticalSpace(10),
                        Container(
                          padding: EdgeInsets.all(2.h),
                          decoration: kOutlineBoxDecoration(0, textColor, 8),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Expert Teachers',
                                style: kBodyText20wBold(Color(0xff48116a)),
                              ),
                              addVerticalSpace(1.5.h),
                              Text(
                                'Highly specialized, experienced teachers that make learning fun.',
                                style: kBodyText16wNormal(black),
                              )
                            ],
                          ),
                        ),
                        addVerticalSpace(2.3.h),
                        Container(
                          padding: EdgeInsets.all(2.h),
                          decoration: kOutlineBoxDecoration(0, textColor, 8),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Personalised Learning',
                                style: kBodyText20wBold(Color(0xff48116a)),
                              ),
                              addVerticalSpace(1.5.h),
                              Text(
                                'Personalised education,tailored to the grasping power of the student.',
                                style: kBodyText16wNormal(black),
                              )
                            ],
                          ),
                        ),
                        addVerticalSpace(2.3.h),
                        Container(
                          padding: EdgeInsets.all(2.h),
                          decoration: kOutlineBoxDecoration(0, textColor, 8),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Monthly Tests',
                                style: kBodyText20wBold(Color(0xff48116a)),
                              ),
                              addVerticalSpace(1.5.h),
                              Text(
                                'Monthly tests for the student to ensure a complete understanding of the subject.',
                                style: kBodyText16wNormal(black),
                              )
                            ],
                          ),
                        ),
                        addVerticalSpace(2.3.h),
                        Container(
                          padding: EdgeInsets.all(2.h),
                          decoration: kOutlineBoxDecoration(0, textColor, 8),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Student Review',
                                style: kBodyText20wBold(Color(0xff48116a)),
                              ),
                              addVerticalSpace(1.5.h),
                              Text(
                                'Feedback about the student’s performance delivered to parents.',
                                style: kBodyText16wNormal(black),
                              )
                            ],
                          ),
                        ),
                        addVerticalSpace(15),
                        Container(
                          height: 31.h,
                          child: ListView.builder(
                              itemCount: widget.sliderList.length,
                              scrollDirection: Axis.horizontal,
                              itemBuilder: (ctx, i) {
                                return Container(
                                  margin: EdgeInsets.symmetric(horizontal: 8),
                                  // height: height(context) * 0.3,
                                  width: width(context) * 0.6,
                                  decoration: kFillBoxDecoration(
                                      0,
                                      i % 2 == 0
                                          ? Color.fromRGBO(255, 28, 246, 0.15)
                                          : Color.fromRGBO(255, 28, 246, 0.1),
                                      0),
                                  child: Column(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceEvenly,
                                    children: [
                                      SizedBox(
                                        height: 20.h,
                                        child: Image.asset(
                                            'assets/images/loginimg.png'),
                                      ),
                                      addVerticalSpace(6),
                                      Text(
                                        widget.sliderList[i],
                                        style: kBodyText18wBold(primary2),
                                        textAlign: TextAlign.center,
                                      )
                                    ],
                                  ),
                                );
                              }),
                        ),

                        // Center(
                        //   child: TextButton(
                        //       onPressed: () {
                        //         widget.whoAreYou == 'Student'
                        //             ? nextScreen(context, StudentRegistration())
                        //             : nextScreen(context, TeacherRegistration());
                        //       },
                        //       child: Text(
                        //         'Click here for registration',
                        //         style: kBodyText20wBold(primary2),
                        //       )),
                        // ),
                        addVerticalSpace(15),
                        Text(
                          'Our Services',
                          style: kBodyText24wBold(primary),
                        ),
                        addVerticalSpace(10),
                        ListView.builder(
                            shrinkWrap: true,
                            physics: NeverScrollableScrollPhysics(),
                            itemCount: widget.serviceList.length,
                            itemBuilder: (ctx, i) {
                              return Container(
                                margin: EdgeInsets.symmetric(
                                    vertical: 8, horizontal: 2),
                                // height: height(context) * 0.29,
                                width: width(context) * 0.95,
                                decoration: kFillBoxDecoration(
                                    0,
                                    i % 2 == 0
                                        ? Color.fromRGBO(12, 131, 218, 0.16)
                                        : Color.fromRGBO(255, 28, 246, 0.1),
                                    0),
                                child: i % 2 == 0
                                    ? Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceEvenly,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: [
                                          SizedBox(
                                            width: 48.w,
                                            child: Image.asset(
                                                'assets/images/loginimg.png'),
                                          ),
                                          Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              // addVerticalSpace(15),
                                              SizedBox(
                                                width: 40.w,
                                                child: SingleChildScrollView(
                                                  scrollDirection:
                                                      Axis.vertical,
                                                  child: Text(
                                                    widget.serviceList[i]
                                                        ['title'],
                                                    style: kbodyText18W600(i %
                                                                2 ==
                                                            0
                                                        ? Color(0xff0C3D45)
                                                        : Color(0xff620085)),
                                                    textAlign: TextAlign.center,
                                                  ),
                                                ),
                                              ),
                                              addVerticalSpace(10),
                                              SizedBox(
                                                width: 40.w,
                                                child: SingleChildScrollView(
                                                  scrollDirection:
                                                      Axis.vertical,
                                                  child: Text(
                                                    widget.serviceList[i]
                                                        ['subtitle'],
                                                    style: kBodyText14wNormal(
                                                        i % 2 == 0
                                                            ? Color(0xff0A595B)
                                                            : Color(
                                                                0xffA400DE)),
                                                    textAlign: TextAlign.center,
                                                  ),
                                                ),
                                              )
                                            ],
                                          ),
                                          addHorizontalySpace(0)
                                        ],
                                      )
                                    : Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceEvenly,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: [
                                          Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              // addVerticalSpace(15),
                                              SizedBox(
                                                width: 40.w,
                                                child: SingleChildScrollView(
                                                  scrollDirection:
                                                      Axis.vertical,
                                                  child: Text(
                                                    widget.serviceList[i]
                                                        ['title'],
                                                    style: kbodyText18W600(i %
                                                                2 ==
                                                            0
                                                        ? Color(0xff0C3D45)
                                                        : Color(0xff620085)),
                                                    textAlign: TextAlign.center,
                                                  ),
                                                ),
                                              ),
                                              addVerticalSpace(10),
                                              SizedBox(
                                                width: 40.w,
                                                child: SingleChildScrollView(
                                                  scrollDirection:
                                                      Axis.vertical,
                                                  child: Text(
                                                    widget.serviceList[i]
                                                        ['subtitle'],
                                                    style: kBodyText14wNormal(
                                                        i % 2 == 0
                                                            ? Color(0xff0A595B)
                                                            : Color(
                                                                0xffA400DE)),
                                                    textAlign: TextAlign.center,
                                                  ),
                                                ),
                                              )
                                            ],
                                          ),
                                          SizedBox(
                                            // height: height(context) * 0.19,
                                            width: 48.w,
                                            child: Image.asset(
                                                'assets/images/loginimg.png'),
                                          ),
                                        ],
                                      ),
                              );
                            }),
                        addVerticalSpace(13),
                        Text(
                          'Know our offerings',
                          style: kBodyText24wBold(primary),
                        ),
                        addVerticalSpace(10),
                        Text(
                          'With our help, you can learn more. For all classes, boards, and subjects, we offer academic tutoring. So allow your child to fully grasp the fundamentals of the courses, develop conceptual clarity, and achieve a high rate of retention.',
                          style: kBodyText20wNormal(black),
                        ),

                        addVerticalSpace(2.h),
                        Image.asset('assets/images/best1.png'),
                        addVerticalSpace(15),
                        Image.asset('assets/images/best2.png'),
                        addVerticalSpace(2.h),
                        Text(
                          'Explore our offerings',
                          style: kBodyText24wBold(primary),
                        ),
                        addVerticalSpace(10),
                        Wrap(
                          runSpacing: 10,
                          spacing: 10,
                          children:
                              List.generate(Homescr["classes"].length, (i) {
                            return InkWell(
                              onTap: () {
                                selectedIndex = i;
                                setState(() {});
                              },
                              child: Container(
                                padding: EdgeInsets.symmetric(
                                    vertical: 5, horizontal: 10),
                                decoration: selectedIndex == i
                                    ? kFillBoxDecoration(
                                        0, Color(0xff793EFF), 30)
                                    : kOutlineBoxDecoration(
                                        1, Color(0xff793EFF), 30),
                                child: Text(
                                  Homescr["classes"][i]['class_name'],
                                  style: kBodyText15wNormal(
                                      selectedIndex == i ? white : black),
                                ),
                              ),
                            );
                          }),
                        ),
                        addVerticalSpace(15),
                        Text(
                          'Explore Subjects',
                          style: kBodyText24wBold(primary),
                        ),
                        addVerticalSpace(2.h),
                        Wrap(
                          runSpacing: 10,
                          spacing: 10,
                          children:
                              List.generate(Homescr["subjects"].length, (i) {
                            return InkWell(
                              onTap: () {
                                selectedIndex2 = i;
                                setState(() {});
                              },
                              child: Container(
                                padding: EdgeInsets.symmetric(
                                    vertical: 5, horizontal: 10),
                                decoration: selectedIndex2 == i
                                    ? kFillBoxDecoration(
                                        0, Color(0xff793EFF), 30)
                                    : kOutlineBoxDecoration(
                                        1, Color(0xff793EFF), 30),
                                child: Text(
                                  Homescr["subjects"][i]['subject_name'],
                                  style: kBodyText15wNormal(
                                      selectedIndex2 == i ? white : black),
                                ),
                              ),
                            );
                          }),
                        ),

                        addVerticalSpace(2.h),

                        Text(
                          'Find Us in your City',
                          style: kBodyText24wBold(primary),
                        ),
                        addVerticalSpace(1.5.h),

                        Wrap(
                          runSpacing: 10,
                          spacing: 10,
                          children: List.generate(cityList.length, (i) {
                            return InkWell(
                              onTap: () {
                                selectedIndex3 = i;
                                setState(() {});
                              },
                              child: Container(
                                padding: EdgeInsets.symmetric(
                                    vertical: 5, horizontal: 10),
                                decoration: selectedIndex3 == i
                                    ? kFillBoxDecoration(
                                        0, Color(0xff793EFF), 30)
                                    : kOutlineBoxDecoration(
                                        1, Color(0xff793EFF), 30),
                                child: Text(
                                  cityList[i],
                                  style: kBodyText15wNormal(
                                      selectedIndex3 == i ? white : black),
                                ),
                              ),
                            );
                          }),
                        ),
                        addVerticalSpace(2.h),
                        Image.asset('assets/images/banner2.png'),
                        addVerticalSpace(2.h),
                        Text(
                          'Testimonials',
                          style: kBodyText24wBold(primary),
                        ),
                        addVerticalSpace(2.h),
                        ListView.builder(
                            itemCount: Homescr["testimonials"].length,
                            shrinkWrap: true,
                            physics: NeverScrollableScrollPhysics(),
                            itemBuilder: (ctx, i) {
                              return Column(
                                children: [
                                  SizedBox(
                                    height: 38.h,
                                    child: Stack(
                                      children: [
                                        Container(
                                          height: 13.h,
                                          width: 90.w,
                                          decoration: kFillBoxDecoration(
                                              0, Color(0xff48116a), 8),
                                        ),
                                        Positioned(
                                            top: 8.h,
                                            left: 35.w,
                                            child: Row(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.end,
                                              children: [
                                                SizedBox(
                                                  height: 9.h,
                                                  width: 20.w,
                                                  child: Image.asset(
                                                    'assets/images/affairs1.png',
                                                    fit: BoxFit.fill,
                                                  ),
                                                ),
                                                addHorizontalySpace(6),
                                                Text(
                                                  Homescr["testimonials"][i]
                                                      ["name"],
                                                  style: kBodyText18w500(black),
                                                )
                                              ],
                                            )),
                                        Positioned(
                                          top: 19.h,
                                          // left: 3.w,
                                          child: SizedBox(
                                            width: 90.w,
                                            child: Text(
                                              Homescr["testimonials"][i]
                                                  ["description"],
                                              style: kBodyText14wNormal(black),
                                              textAlign: TextAlign.center,
                                            ),
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                                  addVerticalSpace(4.h)
                                ],
                              );
                            }),

                        Center(
                          child: Text(
                            'Boards',
                            style: kBodyText20wBold(primary),
                          ),
                        ),
                        addVerticalSpace(1.h),
                        Center(
                          child: Text(
                            'State Board Tuition \nCBSE Board Tuition \nICSE Board Tuition \nIGCSE Board Tuition \nIB Board Tuition',
                            style: kBodyText15wNormal(black),
                            textAlign: TextAlign.center,
                          ),
                        ),
                        addVerticalSpace(2.h),
                        Center(
                          child: Text(
                            'Subjects',
                            style: kBodyText20wBold(primary),
                          ),
                        ),
                        addVerticalSpace(1.h),
                        Center(
                          child: Text(
                            'Maths Tuition\nScience Tuition\nEnglish Tuition\nHindi Tuition\nSocial Science Tuition',
                            style: kBodyText15wNormal(black),
                            textAlign: TextAlign.center,
                          ),
                        ),
                        addVerticalSpace(2.h),
                        Center(
                          child: Text(
                            'Tuitions',
                            style: kBodyText20wBold(primary),
                          ),
                        ),
                        addVerticalSpace(1.h),
                        Center(
                          child: Text(
                            'Academic Tuition\nNon- Academic Tuition\nCompetitive Exams\nLanguage Learning',
                            style: kBodyText15wNormal(black),
                            textAlign: TextAlign.center,
                          ),
                        ),
                        addVerticalSpace(3.h),

                        Center(
                          child: Text(
                            'Get In Touch',
                            style: kBodyText24wBold(Color(0xff48116A)),
                          ),
                        ),

                        addVerticalSpace(3.h),
                        SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Container(
                                    height: 6.5.h,
                                    width: 15.w,
                                    decoration: k3DboxDecoration(15),
                                    child: const Center(
                                      child: Icon(
                                        Icons.call,
                                        size: 30,
                                        color: Color(0xff48116A),
                                      ),
                                    ),
                                  ),
                                  addHorizontalySpace(6.w),
                                  Text(
                                    '020-28438294',
                                    style: kBodyText18wNormal(black),
                                  )
                                ],
                              ),
                              addVerticalSpace(2.h),
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Container(
                                    height: 6.5.h,
                                    width: 15.w,
                                    decoration: k3DboxDecoration(15),
                                    child: const Center(
                                      child: Icon(
                                        Icons.mail,
                                        size: 30,
                                        color: Color(0xff48116A),
                                      ),
                                    ),
                                  ),
                                  addHorizontalySpace(6.w),
                                  Text(
                                    'abcd1234@gmail.com',
                                    style: kBodyText18wNormal(black),
                                  )
                                ],
                              ),
                              addVerticalSpace(2.h),
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Container(
                                    height: 6.5.h,
                                    width: 15.w,
                                    decoration: k3DboxDecoration(15),
                                    child: const Center(
                                        child: ImageIcon(
                                      AssetImage('assets/images/wpicon.png'),
                                      size: 30,
                                    )),
                                  ),
                                  addHorizontalySpace(6.w),
                                  Text(
                                    '08346728197',
                                    style: kBodyText18wNormal(black),
                                  )
                                ],
                              ),
                              addVerticalSpace(2.h),
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Container(
                                    height: 6.5.h,
                                    width: 15.w,
                                    decoration: k3DboxDecoration(15),
                                    child: const Center(
                                      child: Icon(
                                        Icons.location_on,
                                        size: 30,
                                        color: Color(0xff48116A),
                                      ),
                                    ),
                                  ),
                                  addHorizontalySpace(6.w),
                                  Text(
                                    'Bihar',
                                    style: kBodyText18wNormal(black),
                                  )
                                ],
                              ),
                            ],
                          ),
                        ),
                        addVerticalSpace(3.5.h),
                        Center(
                          child: Text(
                            'Follow Us On',
                            style: kBodyText24wBold(Color(0xff48116A)),
                          ),
                        ),
                        addVerticalSpace(3.h),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            SizedBox(
                                height: 6.1.h,
                                child: Image.asset('assets/images/insta.png')),
                            SizedBox(
                                height: 6.h,
                                child: Image.asset('assets/images/fb.png')),
                            SizedBox(
                                height: 6.h,
                                child: Image.asset('assets/images/utube.png')),
                          ],
                        ),
                        addVerticalSpace(3.h),
                      ],
                    ),
                  ),
                  Container(
                    height: 10.h,
                    width: width(context),
                    // decoration: kGradientBoxDecoration(0, purpleGradident()),
                    decoration: kFillBoxDecoration(0, Color(0xff48116a), 0),
                    child: Center(
                      child: Text(
                        'www.trusir.com',
                        style: kBodyText27wNormal(white),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        }
      },
    );
  }
}
