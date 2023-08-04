import 'package:get/get.dart';
import 'package:offline_classes/Views/auth/auth_controller.dart';
import 'package:offline_classes/Views/auth/succesfull_login_screen.dart';

import '../../global_data/GlobalData.dart';

class OtpController extends GetxController {
  static OtpController get instace => Get.put(OtpController());

  void verifyOTP(String otp) async {
    var isVerified = await AuthController.instance.verifyOTP(otp);
    GlobalData().getInfoLogin(
        "/login", GlobalData.auth1, GlobalData.phoneNumber.substring(1));
    isVerified ? Get.offAll(() => const SuccessfullLogInscreen()) : Get.back();
  }
}
