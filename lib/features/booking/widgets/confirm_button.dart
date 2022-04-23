import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../core/app_colors.dart';
import '../../../core/app_theme.dart';

Container confirmButton([String text = 'Confirm']) {
    return Container(
              height: 27.h,
              width: 117.w,
              decoration: BoxDecoration(
                color: AppColors.kEvergreen,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Center(
                child: Text(
                  text,
                  style: AppTheme.buttonTextStyle,
                ),
              ),
            );
  }