import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../utils/constants.dart';

class CustomItemSelectedField extends StatelessWidget {
  const CustomItemSelectedField({
    Key? key,
    required this.title,
    required this.onTap,
    required this.isChanged,
  }) : super(key: key);
  final String title;
  final VoidCallback onTap;
  final bool isChanged;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        height: 8.5.h,
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
        padding: EdgeInsets.symmetric(
          horizontal: 33,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            addVerticalSpace(5),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  title,
                  style: kBodyText14w500(Color(0xffA4A4A4)),
                ),
                Icon(
                  isChanged ? Icons.expand_less : Icons.expand_more,
                  size: 30,
                  color: textColor,
                )
              ],
            ),
          ],
        ),
      ),
    );
  }
}
