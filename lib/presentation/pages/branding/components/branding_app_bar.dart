import 'package:crypto_app/ui/base/base_app_bar.dart';
import 'package:flutter/material.dart';
import 'package:crypto_app/core/constants/app_colors.dart';

class BrandingAppBar extends BaseAppBar {
  BrandingAppBar({
    super.key,
    super.toolbarHeight,
  }) : super(
          backgroundColor: AppColors.background,
          elevation: 0,
          centerTitle: false,
          titleWidget: _BrandingTitle(),
          actions: const [
            _SettingsButton(),
          ], // Custom toolbar height
        );
}

class _SettingsButton extends StatelessWidget {
  const _SettingsButton();

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: () {
        // Settings action
      },
      icon: const Icon(
        Icons.settings,
        color: AppColors.iconPrimary,
      ),
    );
  }
}

class _BrandingTitle extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        // Avatar
        Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: AppColors.primary,
          ),
          child: const Icon(
            Icons.person,
            color: Colors.white,
            size: 24,
          ),
        ),
        const SizedBox(width: 12),
        // Hello Alex text
        const Text(
          'Hello Alex',
          style: TextStyle(
            color: AppColors.textPrimary,
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }
}
