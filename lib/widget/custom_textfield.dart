import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:sizer/sizer.dart';

import '../utils/constants.dart';

class CustomTextfield extends StatelessWidget {
  const CustomTextfield(
      {super.key,
      required this.hintext,
      this.keyBoardType,
      this.controller,
      this.readOnly,
      this.sufixIcon,
      this.onChanged,
      this.onTap});
  final String hintext;
  final bool? readOnly;
  final TextInputType? keyBoardType;
  final TextEditingController? controller;
  final IconData? sufixIcon;
  final VoidCallback? onTap;
  final Function(String)? onChanged;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(left: 33, top: 5),
      // height: 6.5.h,
      width: width(context) * 0.93,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(40),
        boxShadow: [
          const BoxShadow(
            color: textColor,
            offset: Offset(0, 3),
          ),
          BoxShadow(
            color: white.withOpacity(0.95),
            // spreadRadius: -2.0,
            blurRadius: 7.0,
          ),
        ],
      ),
      child: Center(
        child: TextFormField(
          textCapitalization: TextCapitalization.words,

          controller: controller,
          readOnly: readOnly ?? false,
          keyboardType: keyBoardType,
          // style: kBodyText16wBold(black),
          // inputFormatters: [
          //   LengthLimitingTextInputFormatter(10),
          //   FilteringTextInputFormatter.allow(
          //     RegExp(r"[0-9]"),
          //   )
          // ],
          onTap: onTap,
          onChanged: onChanged,
          decoration: InputDecoration(
              labelStyle: kBodyText14w500(Color(0xffA4A4A4)),
              border: InputBorder.none,
              suffixIcon: Icon(sufixIcon),
              suffixIconColor: textColor,
              labelText: hintext),
        ),
      ),
    );
  }
}

class CustomTextfieldMaxLine extends StatelessWidget {
  const CustomTextfieldMaxLine(
      {super.key,
      required this.hintext,
      this.keyBoardType,
      this.controller,
      this.sufixIcon,
      this.onChanged,
      this.onTap});
  final String hintext;
  final TextInputType? keyBoardType;
  final TextEditingController? controller;
  final IconData? sufixIcon;
  final Function(String)? onChanged;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(left: 20, top: 7),
      width: 195.w,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(34),
        boxShadow: [
          const BoxShadow(
            color: textColor,
            offset: Offset(0, 3),
          ),
          BoxShadow(
            color: white.withOpacity(0.95),
            // spreadRadius: -2.0,
            blurRadius: 7.0,
          ),
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TextFormField(
            textCapitalization: TextCapitalization.words,

            maxLines: 4,
            controller: controller,
            onChanged: onChanged,
            keyboardType: keyBoardType,
            // style: kBodyText16wBold(black),
            // inputFormatters: [
            //   LengthLimitingTextInputFormatter(10),
            //   FilteringTextInputFormatter.allow(
            //     RegExp(r"[0-9]"),
            //   )
            // ],
            onTap: onTap,
            decoration: InputDecoration(
                labelStyle: kBodyText14w500(Color(0xffA4A4A4)),
                border: InputBorder.none,
                suffixIcon: Icon(sufixIcon),
                suffixIconColor: textColor,
                labelText: hintext),
          ),
        ],
      ),
    );
  }
}
