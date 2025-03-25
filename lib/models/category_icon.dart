import 'package:flutter/material.dart';

class CategoryIcon {
  final String? imagePath;
  final IconData? icon;
  final Color? color;

  CategoryIcon({this.imagePath, this.icon, this.color});

  Widget build({Color? color}) {
    if (imagePath != null) {
      return Image.asset(imagePath!, width: 24, height: 24);
    }
    return Container(
      height: 24,
      width: 24,
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(4)),
        color: color?.withAlpha(50),
      ),
      child: Icon(icon, color: color, size: 14),
    );
  }
}
