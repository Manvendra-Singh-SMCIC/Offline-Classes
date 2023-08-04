// ignore_for_file: non_constant_identifier_names

import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:crypto/crypto.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:offline_classes/Views/auth/auth_controller.dart';
import 'package:offline_classes/global_data/GlobalData.dart';
import 'package:offline_classes/utils/constants.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:sizer/sizer.dart';
import '../Views/enquiry_registrations/registration_successfull.dart';
import '../global_data/student_global_data.dart';
import '../widget/custom_button.dart';
import 'razor_credentials.dart' as razorCredentials;

// class MyHttpOverrides extends HttpOverrides {
//   @override
//   HttpClient createHttpClient(SecurityContext? context) {
//     return super.createHttpClient(context)
//       ..badCertificateCallback =
//           (X509Certificate cert, String host, int port) => true;
//   }
// }

class RazorpayScreen extends StatefulWidget {
  final double amount;
  final String role;
  final String payment_type;
  final int courseid;
  final int user_id;

  const RazorpayScreen({
    super.key,
    required this.amount,
    required this.role,
    required this.payment_type,
    this.courseid = 0,
    this.user_id = 1,
  });

  @override
  State<RazorpayScreen> createState() => _RazorpayScreenState();
}

class _RazorpayScreenState extends State<RazorpayScreen> {
  late Razorpay _razorpay;

  double amt = 0.0;

  @override
  void initState() {
    _razorpay = Razorpay();
    amt = widget.amount;
    // amt = widget.amount;
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      _razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, _handlePaymentSuccess);
      _razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, _handlePaymentError);
      _razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, _handleExternalWallet);
    });
    super.initState();
  }

  Future<void> _handlePaymentSuccess(PaymentSuccessResponse response) async {
    var res = response;
    Get.snackbar(
      "Done",
      "Payment Successful",
      backgroundColor: Colors.green.withOpacity(0.65),
    );
    // Do something when payment succeeds
    print(response);
    capturePayment(response.paymentId);
    final key = utf8.encode('NgDLPyiDRPuQpcXy1E3GKTDv');
    final bytes = utf8.encode('${response.orderId}|${response.paymentId}');
    final hmacSha256 = Hmac(sha256, key);
    final generatedSignature = hmacSha256.convert(bytes);
    String status = "authorized";
    if (generatedSignature.toString() == response.signature) {
      // Handle what to do after a successful payment.
      print("Payment captured");
      status = "captured";
      // nextScreen(
      //   context,
      //   RegistrationSuccessfull(
      //     whoareYou: widget.role,
      //   ),
      // )
      Get.snackbar(
        "Success",
        "Payment Captured",
        backgroundColor: Colors.green.withOpacity(0.65),
      );
      //Get.back();
    } else {
      print("Payment capture failed");
    }
    //Since the payment is not getting captured, I have kept
    // the screen navigation code outside the successful caputre block
    if (widget.payment_type == 'student registration' ||
        widget.payment_type == 'teacher registration') {
      Map<String, dynamic> map;
      var url = Uri.parse(
          "${GlobalData.baseUrl}/payment?mobile=${GlobalData.phoneNumber.substring(1)}&authKey=${GlobalData.auth1}&payment_type=${widget.payment_type}&payment_id=${res.paymentId}&status=captured&amount=${amt}");
      final http.Response response = await http.get(url);
      map = json.decode(response.body);
      if (response.statusCode == 200) {
        if (map.isNotEmpty) {
          print(map);
          Get.snackbar(
            "Registered",
            "",
            backgroundColor: Colors.green.withOpacity(0.65),
          );
          nextScreen(
            context,
            RegistrationSuccessfull(
              whoareYou: widget.role,
            ),
          );
        } else {
          Get.snackbar(
            "Some Error Occured",
            "",
            backgroundColor: Colors.red.withOpacity(0.65),
          );
        }
      } else {
        Get.snackbar(
          "Some Error Occured",
          "",
          backgroundColor: Colors.red.withOpacity(0.65),
        );
      }
    } else if (widget.payment_type == 'renew course') {
      Map<String, dynamic> map;
      var url = Uri.parse(
          "${GlobalData.baseUrl}/payment?mobile=${GlobalData.phoneNumber.substring(1)}&authKey=${GlobalData.auth1}&payment_type=${widget.payment_type}&amount=${amt}&status=captured&payment_id={${res.paymentId}&user_id=${GlobalStudent.id}&courseid=${widget.courseid}");
      final http.Response response = await http.get(url);
      map = json.decode(response.body);
      if (response.statusCode == 200) {
        if (map.isNotEmpty) {
          print(map);
          Get.snackbar(
            "Payment Sucessful",
            "Fee paid",
            backgroundColor: Colors.green.withOpacity(0.65),
          );
          Timer(const Duration(seconds: 3), () {});
          Navigator.pop(context);
        } else {
          Get.snackbar(
            "Some Error Occured",
            "Fee not paid",
            backgroundColor: Colors.red.withOpacity(0.65),
          );
        }
      } else {
        Get.snackbar(
          "Some Error Occured",
          "Fee not paid",
          backgroundColor: Colors.red.withOpacity(0.65),
        );
      }
    } else {
      Map<String, dynamic> map;
      var url = Uri.parse(
          "${GlobalData.baseUrl}/payment?mobile=${GlobalData.phoneNumber.substring(1)}&authKey=${GlobalData.auth1}&payment_type=${widget.payment_type}&amount=${amt}&status=captured&payment_id={${res.paymentId}&user_id=${GlobalStudent.id}&courseid=${widget.courseid}");
      final http.Response response = await http.get(url);
      map = json.decode(response.body);
      if (response.statusCode == 200) {
        if (map.isNotEmpty) {
          print(map);
          Timer(const Duration(seconds: 3), () {});
          Get.snackbar(
            "Success",
            "Course Added",
            backgroundColor: Colors.green.withOpacity(0.65),
          );
          Navigator.pop(context);
        } else {
          Get.snackbar(
            "Some Error Occured",
            "Course Not Added",
            backgroundColor: Colors.red.withOpacity(0.65),
          );
        }
      } else {
        Get.snackbar(
          "Some Error Occured",
          "Course Not Added",
          backgroundColor: Colors.red.withOpacity(0.65),
        );
      }
    }
  }

  void capturePayment(String? paymentId) async {
    try {
      final apiKey = razorCredentials.keyId;
      final captureUrl =
          'https://api.razorpay.com/v1/payments/$paymentId/capture';

      final response = await http.post(
        Uri.parse(captureUrl),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $apiKey',
        },
      );

      if (response.statusCode == 200) {
        // Payment captured successfully
        print(22222222222);
        var responseData = json.decode(response.body);
        var capturedAmount = responseData['captured_amount'];
        print('Payment captured');
      } else {
        print(000000000);
        // Failed to capture payment
        print('Failed to capture payment');
      }
    } catch (e) {
      print("Exception in captuure");
    }
  }

  void _handlePaymentError(PaymentFailureResponse response) {
    print(response);
    // Do something when payment fails
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(response.message ?? 'Error Occured'),
      ),
    );
  }

  void _handleExternalWallet(ExternalWalletResponse response) {
    print(response);
    // Do something when an external wallet is selected
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(response.walletName ?? 'External wallet selected'),
      ),
    );
  }

// create order
  void createOrder() async {
    String username = razorCredentials.keyId;
    String password = razorCredentials.keySecret;
    String basicAuth =
        'Basic ${base64Encode(utf8.encode('$username:$password'))}';

    Map<String, dynamic> body = {
      "amount": amt * 100,
      "currency": "INR",
      "receipt": "rcptid_11"
    };
    var res = await http.post(
      Uri.parse(
        "https://api.razorpay.com/v1/orders",
      ),
      headers: <String, String>{
        "Content-Type": "application/json",
        'authorization': basicAuth,
      },
      body: jsonEncode(body),
    );

    if (res.statusCode == 200) {
      openGateway(jsonDecode(res.body)['id']);
    }
    print(res.body);
  }

  openGateway(String orderId) async {
    var options = {
      'key': razorCredentials.keyId,
      'amount': amt * 100, //in the smallest currency sub-unit.
      'name': 'Trusir',
      'order_id': orderId, // Generate order_id using Orders API
      'description': 'Payment',
      'timeout': 60 * 5, // in seconds // 5 minutes
      'capture': true,
      'external': {
        'wallets': ['paytm']
      },
      'prefill': {
        'contact': GlobalData.phoneNumber.substring(3),
        'email': emailTextEditingController.text.toString(),
      },
      'method': {
        'upi': {
          'vpa': '8577098983@paytm',
        },
      },
    };
    _razorpay.open(options);
  }

  @override
  void dispose() {
    _razorpay.clear(); // Removes all listeners
    _razorpay = Razorpay();
    super.dispose();
  }

  TextEditingController textEditingController = TextEditingController();
  TextEditingController nameTextEditingController = TextEditingController();
  TextEditingController emailTextEditingController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              const Padding(
                padding: EdgeInsets.only(bottom: 50),
                child: Text("Razorpay Payment Gateway"),
              ),
              Padding(
                padding: const EdgeInsets.all(20),
                child: TextField(
                  controller: textEditingController,
                  enabled: false,
                  readOnly: true,
                  decoration: InputDecoration(
                    hintText: amt.toString(),
                    icon: const Icon(
                      Icons.monetization_on,
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(20),
                child: TextField(
                  controller: nameTextEditingController,
                  decoration: const InputDecoration(
                    hintText: "Name",
                    icon: Icon(
                      Icons.monetization_on,
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(20),
                child: TextField(
                  controller: emailTextEditingController,
                  decoration: const InputDecoration(
                    hintText: "Email",
                    icon: Icon(
                      Icons.monetization_on,
                    ),
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.all(20),
                child: TextButton(
                  onPressed: () {
                    String name =
                        nameTextEditingController.text.toString().trim();
                    String email =
                        emailTextEditingController.text.toString().trim();
                    if (name.isNotEmpty &&
                        name != "Name" &&
                        email.isNotEmpty &&
                        email.contains('@')) {
                      createOrder();
                    } else {
                      if (!email.isEmail) {
                        Get.snackbar(
                          "Error",
                          "Enter a valid email id",
                          backgroundColor: Colors.red.withOpacity(0.65),
                        );
                      }
                      if (!email.contains('@')) {
                        Get.snackbar(
                          "Error",
                          "Enter Valid Email",
                          backgroundColor: Colors.red.withOpacity(0.65),
                        );
                      } else {
                        Get.snackbar(
                          "Error",
                          "Enter Values",
                          backgroundColor: Colors.red.withOpacity(0.65),
                        );
                      }
                    }
                  },
                  child: Text(
                    "Start Payment",
                    style: TextStyle(color: Colors.white),
                  ),
                  style: TextButton.styleFrom(backgroundColor: Colors.blue),
                ),
              ),
              addVerticalSpace(70),
              Padding(
                padding: EdgeInsets.all(20),
                child: TextButton(
                  onPressed: () {
                    showDialog(
                        context: context,
                        builder: (_) => AlertDialog(
                              contentPadding: const EdgeInsets.all(6),
                              shape: const RoundedRectangleBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(10.0))),
                              content: StatefulBuilder(
                                builder: (BuildContext context,
                                    StateSetter setState) {
                                  var height =
                                      MediaQuery.of(context).size.height;
                                  var width = MediaQuery.of(context).size.width;

                                  return Container(
                                      height: height * 0.3,
                                      // decoration: kFillBoxDecoration(0, white, 40),
                                      padding: EdgeInsets.all(10),
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceEvenly,
                                        children: [
                                          Text(
                                            "Are you sure you want to logout?",
                                            style: kBodyText18wBold(black),
                                            textAlign: TextAlign.center,
                                          ),
                                          addVerticalSpace(6.h),
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceEvenly,
                                            children: [
                                              InkWell(
                                                onTap: AuthController
                                                    .instance.logout,
                                                child: Container(
                                                  height: 5.h,
                                                  width: 30.w,
                                                  decoration:
                                                      kOutlineBoxDecoration(
                                                    2,
                                                    green,
                                                    18,
                                                  ),
                                                  child: Center(
                                                    child: Text(
                                                      'Yes',
                                                      style: kBodyText16wBold(
                                                        green,
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                              SizedBox(
                                                height: 5.h,
                                                width: 30.w,
                                                child: CustomButton(
                                                  text: 'No',
                                                  onTap: () {
                                                    goBack(context);
                                                  },
                                                ),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ));
                                },
                              ),
                            ));
                  },
                  child: Text(
                    "Logout",
                    style: TextStyle(color: Colors.white),
                  ),
                  style: TextButton.styleFrom(backgroundColor: Colors.blue),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
