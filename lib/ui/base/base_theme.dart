import 'package:flutter/material.dart';

import '../../core/constants/app_colors.dart';

class BaseSpacing {
  static const double xs = 4;
  static const double sm = 8;
  static const double md = 16;
  static const double lg = 24;
  static const double xl = 32;
}

class BaseRadius {
  static const BorderRadius small = BorderRadius.all(Radius.circular(8));
  static const BorderRadius medium = BorderRadius.all(Radius.circular(12));
  static const BorderRadius large = BorderRadius.all(Radius.circular(16));
}

class BaseElevation {
  static const double none = 0;
  static const double low = 1;
  static const double medium = 2;
  static const double high = 4;
}

class BaseTypography {
  static const TextStyle title = TextStyle(
    color: AppColors.textPrimary,
    fontSize: 16,
    fontWeight: FontWeight.w600,
  );

  static const TextStyle body = TextStyle(
    color: AppColors.textSecondary,
    fontSize: 14,
  );

  static const TextStyle caption = TextStyle(
    color: AppColors.textTertiary,
    fontSize: 12,
  );
}

