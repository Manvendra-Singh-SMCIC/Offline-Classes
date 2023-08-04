import 'dart:convert';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:offline_classes/Views/home/courses_tab.dart';
import 'package:offline_classes/Views/home/home_page_for_register_user.dart';
import 'package:http/http.dart' as http;
import 'package:offline_classes/Views/home/students_facilities/select_student_profile.dart';
import 'package:offline_classes/Views/home/students_facilities/student_facilities.dart';
import 'package:offline_classes/Views/home/teachers_facilities/teacher_course_tab.dart';
import 'package:offline_classes/Views/home/teachers_facilities/teacher_facilities.dart';
import 'package:offline_classes/global_data/student_global_data.dart';
import 'package:offline_classes/global_data/teacher_global_data.dart';
import 'package:offline_classes/model/statics_list.dart';

import '../global_data/GlobalData.dart';
import '../utils/constants.dart';

class MyBottomBar extends StatefulWidget {
  const MyBottomBar({
    Key? key,
    required this.whoRYou,
  }) : super(key: key);
  final String whoRYou;

  static int? id;

  @override
  State<MyBottomBar> createState() => _MyBottomBarState();
}

class _MyBottomBarState extends State<MyBottomBar> {
  int _selectedIndex = 0;
  bool isIAm = false;

  // List<Widget> _widgetOptions = <Widget>[
  //   HomeScreen(),
  //   Text('data'),
  //   Text('data'),
  // ];
  Widget getPage(int index) {
    switch (index) {
      case 0:
        return HomeScreenForRegisterUser(
          whoAreYou: widget.whoRYou,
          serviceList: widget.whoRYou == 'student'
              ? studentServiceList
              : teacherServiceList,
          sliderList: widget.whoRYou == 'student'
              ? ['Trusted Teachers', 'Home to Home tuition service']
              : const ['Annual Gift Hamper', '100% Trusted & Satisfied'],
        );

        break;
      case 1:
        return widget.whoRYou == 'student' ? CoursesTab() : TeachersCourseTab();
        break;
      default:
        return widget.whoRYou == 'student'
            ? StudentFacilities()
            : TeacherFacilities();
        break;
    }
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  static Map<String, dynamic> specificProfile = {};
  int? id = SelectStudentProfile.id;

  Future<void> checkSpecificProfiles() async {
    try {
      id = SelectStudentProfile().getId();
      MyBottomBar.id = SelectStudentProfile().getId();
      final http.Response response = await http.get(Uri.parse(
          "${GlobalData.baseUrl}/perticularstudentProfile?authKey=${GlobalData.auth1}&user_id=${SelectStudentProfile().getId()}"));
      specificProfile = json.decode(response.body);
      if (response.statusCode == 200) {
        print(id);
        print(MyBottomBar.id);
        print(specificProfile);
      } else {
        return;
      }
    } catch (e) {
      print(e);
    }
  }

  static Map<String, dynamic> teacherProfile = {};

  Future<void> checkTeacherProfile() async {
    final http.Response response = await http.get(Uri.parse(
        "${GlobalData.baseUrl}/teacherLogin?authKey=${GlobalData.auth1}&mobile=${GlobalData.phoneNumber.substring(1)}"));
    teacherProfile = json.decode(response.body);
    print("caled");
    if (response.statusCode == 200) {
      print(teacherProfile);
    } else {
      return;
    }
  }

  DateTime? currentBackPressTime;

  Future<bool> _onWillPop() async {
    DateTime now = DateTime.now();
    if (currentBackPressTime == null ||
        now.difference(currentBackPressTime!) > Duration(seconds: 2)) {
      currentBackPressTime = now;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Press back again to exit'),
          duration: Duration(seconds: 2),
        ),
      );
      return false;
    }
    return true;
  }

  @override
  Widget build(BuildContext context) {
    String role = widget.whoRYou;
    print(role);
    return FutureBuilder(
      future: widget.whoRYou == 'student'
          ? checkSpecificProfiles()
          : checkTeacherProfile(),
      builder: (context, snapshot) {
        if ((role == 'student' && specificProfile.isNotEmpty) ||
            (role == 'teacher' && teacherProfile.isNotEmpty)) {
          if (role == 'student') {
            GlobalStudent().updateSpecificProfile(specificProfile);
          }
          if (role == 'teacher') {
            GlobalTeacher().updateId(teacherProfile["data"][0]["id"]);
            GlobalTeacher().updateProfiles(teacherProfile);
          }
          return Scaffold(
            body: WillPopScope(
              onWillPop: _onWillPop,
              child: Center(
                child: getPage(_selectedIndex),
              ),
            ),
            bottomNavigationBar: ClipRRect(
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(30.0),
                topRight: Radius.circular(30.0),
              ),
              child: SizedBox(
                height: height(context) * 0.08,
                child: BottomNavigationBar(
                  elevation: 7,
                  backgroundColor: Color.fromRGBO(239, 239, 239, 1),
                  items: const <BottomNavigationBarItem>[
                    BottomNavigationBarItem(
                      icon: ImageIcon(AssetImage('assets/images/nav1.png')),
                      label: 'Home',
                    ),
                    BottomNavigationBarItem(
                      icon: ImageIcon(AssetImage('assets/images/nav2.png')),
                      // activeIcon: ImageIcon(AssetImage('assets/images/active2.png')),

                      label: 'Courses',
                    ),
                    BottomNavigationBarItem(
                      // icon: ImageIcon(AssetImage('assets/images/inactive3.png')),
                      icon: ImageIcon(AssetImage('assets/images/nav3.png')),

                      label: 'Menu',
                    ),
                  ],
                  currentIndex: _selectedIndex,
                  unselectedItemColor: Colors.grey,
                  selectedItemColor: primary2,
                  selectedFontSize: 12,
                  unselectedFontSize: 12,
                  type: BottomNavigationBarType.fixed,
                  onTap: _onItemTapped,
                  showSelectedLabels: true,
                  showUnselectedLabels: true,
                ),
              ),
            ),
          );
        } else {
          return const Center(
              child: CircularProgressIndicator(color: primary2));
        }
      },
    );
  }
}
