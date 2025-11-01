import 'package:flutter/material.dart';

import '../../core/constants/app_colors.dart';

class BaseAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String? title;
  final Widget? titleWidget;
  final bool centerTitle;
  final List<Widget>? actions;
  final Widget? leading;
  final Color backgroundColor;
  final double elevation;
  final Color? titleColor;
  final Color? iconColor;
  final double? toolbarHeight;

  const BaseAppBar({
    super.key,
    this.title,
    this.titleWidget,
    this.centerTitle = true,
    this.actions,
    this.leading,
    this.backgroundColor = Colors.white,
    this.elevation = 0,
    this.titleColor,
    this.iconColor,
    this.toolbarHeight,
  }) : assert(title != null || titleWidget != null, 'Either title or titleWidget must be provided');

  @override
  Widget build(BuildContext context) {
    final defaultTextColor = backgroundColor == Colors.white || backgroundColor == AppColors.background 
        ? Colors.black 
        : Colors.white;
    final defaultIconColor = backgroundColor == Colors.white || backgroundColor == AppColors.background 
        ? Colors.black 
        : Colors.white;

    return AppBar(
      title: titleWidget ?? (title != null
          ? Text(
              title!,
              style: TextStyle(
                color: titleColor ?? defaultTextColor,
                fontSize: 18,
                fontWeight: FontWeight.w600,
              ),
            )
          : null),
      centerTitle: centerTitle,
      actions: actions,
      leading: leading,
      backgroundColor: backgroundColor,
      elevation: elevation,
      iconTheme: IconThemeData(color: iconColor ?? defaultIconColor),
      toolbarHeight: toolbarHeight,
      flexibleSpace: toolbarHeight != null && toolbarHeight! > kToolbarHeight
          ? Container(
              decoration: BoxDecoration(
                color: backgroundColor,
              ),
            )
          : null,
    );
  }

  @override
  Size get preferredSize {
    final height = toolbarHeight ?? kToolbarHeight;
    return Size.fromHeight(height);
  }
}
