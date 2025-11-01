


import 'package:crypto_app/ui/constants/icons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

final class SvgIcon extends StatelessWidget {
  const SvgIcon(
    this.icon,{
      this.color,
      double size = 24,
      super.key,
    }) : _size = size,
    _height = null,
    _width = null;


  
  // const SvgIcon.dimensions(
  //   this.icon, {
  //   required double height,
  //   required double width,
  //   this.color,
  //   super.key,
  // })  : _height = height,
  //       _width = width,
  //       _size = null;

  const SvgIcon.dimensions(
    this.icon,{
      required double height,
      required double width,
      this.color,
      super.key,
    }) : _height = height,
    _width = width,
    _size = null;


    const SvgIcon.full(
      this.icon, {
        this.color,
        super.key,
      }
    ): _size = double.maxFinite,
    _height = null,
    _width = null;

    final AppIcons  icon;
    final Color? color;
    final double? _size;
    final double? _height;
    final double? _width;


    @override
    Widget build(BuildContext context){
      return SvgPicture.asset(
        icon.icon,
        height: _size ?? _height,
        width: _size ?? _width,
        colorFilter: ColorFilter.mode(
          color ?? Theme.of(context).colorScheme.onSurface,
          BlendMode.srcIn,
        ),
      );
    }
    
}