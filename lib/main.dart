import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:offline_classes/Views/auth/splash_screen.dart';
import 'package:offline_classes/global_data/student_global_data.dart';
import 'package:sizer/sizer.dart';
import 'Views/auth/auth_controller.dart';
import 'language/localizations.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await Firebase.initializeApp().then((value) => Get.put(AuthController()));
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  MyApp({super.key});

  final LocalizationController localizationController =
      Get.put(LocalizationController());

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    GlobalStudent.moveCourse = [];
    return Sizer(builder: (context, orientation, deviceType) {
      return GetMaterialApp(
        title: 'Offline Classes',
        debugShowCheckedModeBanner: false,
        // locale: Locale(localizationController.selectedLanguage.value),
        // supportedLocales: const [
        //   Locale("en", "US"),
        //   Locale("hi", ""),
        // ],
        // localizationsDelegates: const [
        //   GlobalMaterialLocalizations.delegate,
        //   GlobalWidgetsLocalizations.delegate,
        //   GlobalCupertinoLocalizations.delegate,
        // ],
        theme: ThemeData(
          primarySwatch: Colors.blue,
          fontFamily: GoogleFonts.poppins().fontFamily,
        ),
        home: const SplashScreen(),
      );
    });
  }
}

//teacherenquiryform
//teacher registration
