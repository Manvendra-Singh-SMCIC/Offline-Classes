import 'package:flutter/material.dart';

class Ztest extends StatelessWidget {
  const Ztest({Key? key, required this.message}) : super(key: key);

  final String message;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: Center(child: Text(message)),
      ),
    );
  }
}
