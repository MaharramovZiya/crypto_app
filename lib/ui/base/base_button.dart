import 'package:flutter/material.dart';

import '../../core/constants/app_colors.dart';
import 'base_theme.dart';

class BaseButton extends StatelessWidget {
  final String label;
  final VoidCallback? onPressed;
  final double? width;
  final double? height;
  final double? borderRadius;
  final Color? backgroundColor;
  final Color? foregroundColor;
  final bool isPrimary;
  final bool isLoading;
  final EdgeInsetsGeometry padding;

  const BaseButton({
    super.key,
    required this.label,
    this.onPressed,
    this.isPrimary = true,
    this.isLoading = false,
    this.padding = const EdgeInsets.symmetric(
      horizontal: BaseSpacing.lg,
      vertical: BaseSpacing.sm,
    ),
    this.width,
    this.height,
    this.borderRadius = 8,
    this.backgroundColor = AppColors.buttonPrimary,
    this.foregroundColor = AppColors.buttonText,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: isLoading ? null : onPressed,
      style: ButtonStyle(
        fixedSize: WidgetStateProperty.all<Size>(
          Size(width ?? double.maxFinite, height ?? 40),
        ),
        backgroundColor: WidgetStateProperty.all<Color?>(backgroundColor),
        foregroundColor: WidgetStateProperty.all<Color?>(foregroundColor),
        shape: WidgetStateProperty.all<RoundedRectangleBorder>(
          RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(borderRadius ?? 8),
          ),
        ),
      ),
      child: isLoading
          ? const SizedBox(
              width: 18,
              height: 18,
              child: CircularProgressIndicator(
                strokeWidth: 2,
                valueColor: AlwaysStoppedAnimation<Color>(AppColors.progressIndicator),
              ),
            )
          : Text(
              label,
              style: BaseTypography.title.copyWith(color: foregroundColor),
            ),
    );
  }
}

