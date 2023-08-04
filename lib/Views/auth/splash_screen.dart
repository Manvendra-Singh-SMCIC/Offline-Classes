import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:offline_classes/Views/auth/auth_controller.dart';
import 'package:offline_classes/Views/auth/login_screen.dart';
import 'package:offline_classes/buffer_screens/progress_indicator_screen.dart';
import 'package:offline_classes/global_data/GlobalData.dart';
import 'package:offline_classes/utils/constants.dart';

import '../enquiry_registrations/enquiry_student_or_teachers.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  void initState() {
    _navigateToNextScreen();
    super.initState();
  }

  _navigateToNextScreen() async {
    await Future.delayed(const Duration(milliseconds: 4000), () {});
    if (mounted) {
      Navigator.pushReplacement(context,
          MaterialPageRoute(builder: (ctx) => const ProgressIndicatorScreen()));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Container(
            height: height(context),
            width: width(context),
            decoration: kGradientBoxDecoration(
              0,
              purpleGradident(),
            ),
            child: Center(
              child: SizedBox(
                  width: width(context) * 0.76,
                  child: Image.asset('assets/images/mainLogo.png')),
            ),
          ),
        ],
      ),
    );
  }
}
