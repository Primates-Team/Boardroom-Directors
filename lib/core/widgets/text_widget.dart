import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hot_desking/core/app_theme.dart';

Widget textWidget(String title) {
  return SizedBox(
    height: 37.h,
    child: Center(
      child: Text(
        title,
        style: AppTheme.labelTextStyle,
      ),
    ),
  );
}
