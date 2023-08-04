import 'package:flutter/material.dart';

import 'constants.dart';

PreferredSize customAppbarForAuth(
    BuildContext context, String title, Widget anyWidget) {
  return PreferredSize(
      preferredSize: const Size.fromHeight(50),
      child: AppBar(
        foregroundColor: black,
        backgroundColor: white,
        elevation: 0,
        centerTitle: true,
        leading: Column(
          children: [
            addVerticalSpace(7),
            Center(
              child: InkWell(
                onTap: () {
                  Navigator.pop(context);
                },
                child: Container(
                  padding: EdgeInsets.only(left: 10),
                  height: 40,
                  width: 40,
                  decoration: kOutlineBoxDecoration(1, Colors.grey, 30),
                  child: Center(
                    child: Icon(Icons.arrow_back_ios),
                  ),
                ),
              ),
            ),
          ],
        ),
        title: Text(
          title,
          style: kBodyText24wBold(black),
        ),
      ));
}

PreferredSize customAppbar2(BuildContext context, String title) {
  return PreferredSize(
    preferredSize: const Size.fromHeight(60),
    child: AppBar(
      backgroundColor: white,
      foregroundColor: black,
      elevation: 0,
      leading: Container(
        margin: EdgeInsets.all(3),
        padding: EdgeInsets.symmetric(horizontal: 8),
        height: 50,
        width: 50,
        decoration: BoxDecoration(
          gradient: orangeGradient(),
          borderRadius: BorderRadius.all(Radius.circular(15)),
        ),
        child: Center(
          child: IconButton(
              onPressed: () {
                goBack(context);
              },
              icon: const Icon(
                Icons.arrow_back_ios,
                color: white,
              )),
        ),
      ),
      title: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Text(
          title,
          style: kBodyText20wBold(primary),
        ),
      ),
    ),
  );
}

PreferredSize customMainAppbar(BuildContext context, VoidCallback onTap) {
  return PreferredSize(
    preferredSize: const Size.fromHeight(50),
    child: AppBar(
      backgroundColor: white,
      foregroundColor: black,
      elevation: 0,
      leadingWidth: 40,
      leading: Row(
        children: [
          InkWell(
              onTap: onTap,
              child: SizedBox(
                  height: 40, child: Image.asset('assets/images/menu.png'))),
        ],
      ),
      title: Column(
        children: [
          // SizedBox(
          //     height: 40,
          //     child: CustomSerchField(
          //         onTap: () {
          //           Navigator.push(context,
          //               MaterialPageRoute(builder: (ctx) => SearchExamHome()));
          //         },
          //         hinttext: 'Search Target Exams')),
        ],
      ),
      actions: [
        Row(
          children: [
            SizedBox(height: 30, child: Image.asset('assets/images/bell.png')),
            addHorizontalySpace(10),
          ],
        ),
      ],
    ),
  );
}
