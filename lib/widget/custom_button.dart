import 'package:flutter/material.dart';

import '../utils/constants.dart';

class CustomButton extends StatelessWidget {
  const CustomButton({
    Key? key,
    required this.text,
    required this.onTap,
  }) : super(key: key);
  final String text;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width(context) * 0.9,
      height: 55,
      child: DecoratedBox(
          decoration: BoxDecoration(
              gradient: greenGradient(),
              borderRadius: BorderRadius.circular(30),
              boxShadow: const <BoxShadow>[
                BoxShadow(
                    color: Color.fromRGBO(0, 0, 0, 0.57), //shadow for button
                    blurRadius: 2,
                    offset: Offset(0, 3)) //blur radius of shadow
              ]),
          child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.transparent,
                disabledForegroundColor: Colors.transparent.withOpacity(0.38),
                disabledBackgroundColor: Colors.transparent.withOpacity(0.12),
                shadowColor: Colors.transparent,
              ),
              onPressed: onTap,
              child: Text(
                text,
                style: kBodyText14wBold(white),
              ))),
    );
  }
}

class CustomButtonOutline extends StatelessWidget {
  const CustomButtonOutline(
      {super.key,
      required this.textWidget,
      required this.ontap,
      required this.width,
      required this.height});
  final Widget textWidget;
  final VoidCallback ontap;
  final double width;
  final double height;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      height: height,
      child: ElevatedButton(
          child: Padding(padding: const EdgeInsets.all(0.0), child: textWidget),
          style: ButtonStyle(
              foregroundColor: MaterialStateProperty.all<Color>(green),
              backgroundColor: MaterialStateProperty.all<Color>(white),
              shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                  RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(50),
                      side: BorderSide(width: 2, color: green)))),
          onPressed: ontap),
    );
  }
}
