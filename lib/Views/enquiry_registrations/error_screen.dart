import 'package:flutter/material.dart';
import 'package:offline_classes/Views/auth/auth_controller.dart';

import '../../utils/constants.dart';
import '../../utils/my_appbar.dart';

class ErrorScreen extends StatelessWidget {
  final String message;
  const ErrorScreen({super.key, required this.message});

  @override
  Widget build(BuildContext context) {
    List text = ["Error Occured", message, "Try again"];
    List styles = [
      kBodyText30wBold(black),
      kBodyText22bold(black),
      kBodyText30wBold(black)
    ];
    return Scaffold(
      appBar: customAppbar2(context, ''),
      body: Container(
        child: Center(
          child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(text.length, (index) {
                return Text(
                  text[index],
                  style: styles[index],
                );
              })
              //<Widget>[
              // Text(
              //   'OOPS',
              //   style: kBodyText30wBold(black),
              // ),
              // const VerticalDivider(thickness: 20),
              // Text(
              //   message,
              //   style: kBodyText30wBold(black),
              // ),
              // Text(
              //   message,
              //   style: kBodyText30wBold(kDefaultIconDarkColor),
              // ),
              // ],
              ),
        ),
      ),
    );
  }
}
