import 'package:flutter/material.dart';

import 'base_theme.dart';

class BaseText extends StatelessWidget {
  final String text;
  final TextStyle? style;
  final TextAlign? textAlign;
  final int? maxLines;
  final TextOverflow? overflow;

  const BaseText(
    this.text, {
    super.key,
    this.style,
    this.textAlign,
    this.maxLines,
    this.overflow,
  });

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: style ?? BaseTypography.body,
      textAlign: textAlign,
      maxLines: maxLines,
      overflow: overflow,
    );
  }
}

