import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:get/get.dart';
import 'package:offline_classes/utils/my_appbar.dart';
import 'package:sizer/sizer.dart';

import '../../../utils/constants.dart';

class ViewProgressReport extends StatefulWidget {
  final String subject;
  final String date;
  final String marks;
  const ViewProgressReport(
      {super.key,
      required this.subject,
      required this.date,
      required this.marks});

  @override
  State<ViewProgressReport> createState() => _ViewProgressReportState();
}

class _ViewProgressReportState extends State<ViewProgressReport> {
  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: customAppbar2(context, "View Report"),
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              height: height * 0.3,
              child: Center(
                child: Icon(
                  Icons.file_copy_sharp,
                  size: context.height * 0.22,
                  color: const Color.fromRGBO(121, 62, 255, 0.2),
                ),
              ),
            ),
            addVerticalSpace(height * 0.1),
            Center(
              child: Container(
                height: 8.h,
                width: 81.w,
                decoration: kFillBoxDecoration(
                    0, Color.fromRGBO(121, 62, 255, 0.2), 20),
                child: Center(
                  child: Text(
                    widget.subject,
                    style: kBodyText16wBold(black),
                  ),
                ),
              ),
            ),
            addVerticalSpace(20),
            Container(
              height: 8.h,
              width: 81.w,
              decoration:
                  kFillBoxDecoration(0, Color.fromRGBO(121, 62, 255, 0.2), 20),
              child: Center(
                child: Text(
                  widget.date,
                  style: kBodyText16wBold(black),
                ),
              ),
            ),
            addVerticalSpace(20),
            Container(
              height: 8.h,
              width: 81.w,
              decoration:
                  kFillBoxDecoration(0, Color.fromRGBO(121, 62, 255, 0.2), 20),
              child: Center(
                child: Text(
                  widget.marks,
                  style: kBodyText16wBold(black),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
