import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:offline_classes/Views/auth/login_screen.dart';
import 'package:offline_classes/Views/auth/otp_verify_screen.dart';
import 'package:offline_classes/Views/auth/splash_screen.dart';
import 'package:offline_classes/Views/auth/splash_screen_for_login_screen.dart';
import 'package:offline_classes/global_data/GlobalData.dart';
import 'package:offline_classes/widget/my_bottom_navbar.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../buffer_screens/progress_indicator_screen.dart';
import '../enquiry_registrations/enquiry_student_or_teachers.dart';

class AuthController extends GetxController {
  //AuthController instance
  static AuthController get instance => Get.put(AuthController());
  //Email, password, name
  late Rx<User?> _user;
  FirebaseAuth auth = FirebaseAuth.instance;

  var verificationId = "".obs;

  String role = "";
  static Map<String, dynamic> mapResponse = {};

  @override
  void onReady() {
    super.onReady();
    _user = Rx<User?>(auth.currentUser);
    _user.bindStream(auth.userChanges());
    getPhoneNumber().then((phoneNumber) async {
      if (phoneNumber != null && phoneNumber.isNotEmpty) {
        // Use the phoneNumber for OTP login or any further processing
        print('Phone Number: $phoneNumber');
        GlobalData().updatePhoneNumber(phoneNumber);
      }
    });
    ever(_user, _initialScreen);
  }

  _initialScreen(User? user) async {
    if (user == null) {
      Get.offAll(() => SplashForLoginScreen());
    } else {
      Get.offAll(() => SplashScreen());
    }
  }

  Future<void> sendOTP(String phno) async {
    savePhoneNumber(phno);
    GlobalData().updatePhoneNumber(phno);
    await auth.verifyPhoneNumber(
      phoneNumber: phno,
      verificationCompleted: (PhoneAuthCredential credential) async {
        await auth.signInWithCredential(credential);
      },
      verificationFailed: (FirebaseAuthException e) {
        if (e.code == "invalid-phone-number") {
          Get.snackbar(
            "Error",
            "Invalid Phone Number",
            backgroundColor: Colors.red.withOpacity(0.65),
          );
        } else {
          Get.snackbar(
            "Error",
            "Something went wrong.",
            backgroundColor: Colors.red.withOpacity(0.65),
          );
        }
      },
      codeSent: (String verificationId, int? resendToken) {
        this.verificationId.value = verificationId;
        GlobalData().updatePhoneNumber(phno);
        OtpVeryfyScreen.verify = verificationId;
        print("OTP Sent");
        print(verificationId);
      },
      codeAutoRetrievalTimeout: (String verificationId) {
        this.verificationId.value = verificationId;
      },
    );
  }

  void savePhoneNumber(String phoneNumber) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('phoneNumber', phoneNumber);
  }

  Future<String?> getPhoneNumber() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('phoneNumber');
  }

  void removePhoneNumber() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove('phoneNumber');
  }

  Future<bool> verifyOTP(String otp) async {
    var credentials;
    try {
      credentials = await auth.signInWithCredential(
          PhoneAuthProvider.credential(
              verificationId: this.verificationId.toString(), smsCode: otp));
      return credentials.user != null ? true : false;
    } catch (e) {
      print("Error");
      Fluttertoast.showToast(
        msg: "Invalid OTP",
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 2,
        backgroundColor: Colors.grey.withOpacity(0.7),
        textColor: Colors.white,
        fontSize: 15,
      );
      return false;
    }
  }

  Future<void> logout() async {
    await auth.signOut();
  }
}
