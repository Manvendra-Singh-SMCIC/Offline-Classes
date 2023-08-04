// import 'package:flutter/material.dart';
// import 'package:flutter/src/widgets/container.dart';
// import 'package:flutter/src/widgets/framework.dart';
// import 'package:offline_classes/Views/enquiry_registrations/registration_successfull.dart';
// import 'package:sizer/sizer.dart';

// import '../../utils/constants.dart';
// import '../../widget/custom_back_button.dart';

// class PaymentMethod extends StatelessWidget {
//   const PaymentMethod({super.key, required this.title});
//   final String title;

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: SingleChildScrollView(
//         child: Column(
//           children: [
//             Container(
//               height: 32.h,
//               padding: EdgeInsets.all(2.h),
//               width: width(context),
//               decoration: BoxDecoration(
//                   gradient: purpleGradident(),
//                   borderRadius: BorderRadius.only(
//                       bottomLeft: Radius.circular(100),
//                       bottomRight: Radius.circular(100))),
//               child: SafeArea(
//                 child: Column(
//                   children: [
//                     Row(
//                       children: [
//                         CustomBackButton(),
//                         addHorizontalySpace(10),
//                         Text(
//                           "${title} Payment",
//                           textAlign: TextAlign.center,
//                           style: kBodyText20wBold(white),
//                         ),
//                       ],
//                     ),
//                     addVerticalSpace(3.h),
//                     Text(
//                       'Rs. 299',
//                       style: kBodyText32wBold(white),
//                     ),
//                     Text(
//                       'Registration Fee',
//                       style: kBodyText20wBold(white),
//                     ),
//                   ],
//                 ),
//               ),
//             ),
//             addVerticalSpace(15.h),
//             InkWell(
//               onTap: () {
//                 nextScreen(
//                     context,
//                     RegistrationSuccessfull(
//                       whoareYou: title == 'Student' ? 'Teacher' : 'Student',
//                     ));
//               },
//               child: Container(
//                 height: 17.h,
//                 width: 80.w,
//                 decoration: kGradientBoxDecoration(40, purpleGradident()),
//                 child: Row(
//                   mainAxisAlignment: MainAxisAlignment.center,
//                   children: [
//                     SizedBox(
//                         height: 10.h,
//                         child: Image.asset('assets/images/onlinecash.png')),
//                     addHorizontalySpace(7.w),
//                     Text(
//                       'Online \nPayment',
//                       style: kBodyText24wBold(white),
//                     )
//                   ],
//                 ),
//               ),
//             ),
//             addVerticalSpace(5.h),
//             InkWell(
//               onTap: () {
//                 nextScreen(context, OfflinePayment());
//               },
//               child: Container(
//                 height: 17.h,
//                 width: 80.w,
//                 decoration: kGradientBoxDecoration(40, purpleGradident()),
//                 child: Row(
//                   mainAxisAlignment: MainAxisAlignment.center,
//                   children: [
//                     SizedBox(
//                         height: 10.h,
//                         child: Image.asset('assets/images/onlinecash.png')),
//                     addHorizontalySpace(7.w),
//                     Text(
//                       'Offine \nPayment',
//                       style: kBodyText24wBold(white),
//                     )
//                   ],
//                 ),
//               ),
//             )
//           ],
//         ),
//       ),
//     );
//   }
// }
