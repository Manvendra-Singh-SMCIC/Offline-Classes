import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

class LocalizationController extends GetxController {
  var selectedLanguage = ''.obs;

  @override
  void onInit() {
    super.onInit();
    initLanguage();
  }

  Future<void> initLanguage() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    selectedLanguage.value = prefs.getString('language') ?? 'en';
  }

  Future<void> changeLanguage(String languageCode) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('language', languageCode);
    selectedLanguage.value = languageCode;
    Get.updateLocale(Locale(languageCode));
  }
}
