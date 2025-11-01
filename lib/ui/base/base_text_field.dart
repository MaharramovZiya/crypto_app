import 'package:flutter/material.dart';

import '../../core/constants/app_colors.dart';
import 'base_theme.dart';

class BaseTextField extends StatelessWidget {
  final TextEditingController? controller;
  final String? hintText;
  final TextInputType keyboardType;
  final bool obscureText;
  final Widget? prefixIcon;
  final Widget? suffixIcon;
  final ValueChanged<String>? onChanged;

  const BaseTextField({
    super.key,
    this.controller,
    this.hintText,
    this.keyboardType = TextInputType.text,
    this.obscureText = false,
    this.prefixIcon,
    this.suffixIcon,
    this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      keyboardType: keyboardType,
      obscureText: obscureText,
      onChanged: onChanged,
      style: BaseTypography.body,
      decoration: InputDecoration(
        hintText: hintText,
        hintStyle: BaseTypography.caption,
        prefixIcon: prefixIcon,
        suffixIcon: suffixIcon,
        filled: true,
        fillColor: AppColors.surface,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: BaseSpacing.md,
          vertical: BaseSpacing.sm,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BaseRadius.small,
          borderSide: const BorderSide(color: AppColors.divider),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BaseRadius.small,
          borderSide: const BorderSide(color: AppColors.primary),
        ),
      ),
    );
  }
}

