import 'package:flutter/material.dart';

import '../utils/constants.dart';

class CustomBackButton extends StatelessWidget {
  const CustomBackButton({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
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
    );
  }
}

Widget nullWidget() {
  return SizedBox(
    height: 0.01,
    width: 0.01,
  );
}
