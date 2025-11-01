import 'package:flutter/material.dart';

class BaseRichText extends StatelessWidget {
  final String first;
  final String? second;
  final Color firstColor;
  final Color secondColor;
  final double fontSize;
  final FontWeight fontWeight;

  const BaseRichText({
    super.key,
    required this.first,
    this.second,
    this.firstColor = Colors.black,
    this.secondColor = Colors.red,
    this.fontSize = 20,
    this.fontWeight = FontWeight.normal,
  });

  @override
  Widget build(BuildContext context) {
    return RichText(
      text: TextSpan(
        style: TextStyle(
          fontSize: fontSize,
          fontWeight: fontWeight,
        ),
        children: [
          TextSpan(
            text: first,
            style: TextStyle(color: firstColor),
          ),
          TextSpan(
            text: second,
            style: TextStyle(color: secondColor),
          ),
        ],
      ),
    );
  }
}
