import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import 'app_colors.dart';

class AppTheme {
  static InputDecoration textFieldDecoration(String hintText) =>
      InputDecoration(
          border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(5),
              borderSide:
                  const BorderSide(color: AppColors.kLightPantone, width: 1)),
          enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(5),
              borderSide:
                  const BorderSide(color: AppColors.kLightPantone, width: 1)),
          focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(5),
              borderSide:
                  const BorderSide(color: AppColors.kLightPantone, width: 1)),
          hintStyle: const TextStyle(
            fontSize: 12,
            color: AppColors.kLightPantone,
            fontWeight: FontWeight.w600,
          ),
          hintText: hintText.tr,
          contentPadding: const EdgeInsets.only(left: 51)
          //prefixIcon: SizedBox(height: 20, width: 20, child: Image.asset(iconPath, height: 20, width: 20,)),
          );

  static Widget divider() => Container(
        width: Get.width,
        height: 1,
        color: AppColors.kLightPantone,
      );

  static BoxDecoration boxDecoration = BoxDecoration(
    color: AppColors.kGreyContainer,
    borderRadius: BorderRadius.circular(20),
    boxShadow: [
      BoxShadow(
        offset: const Offset(0, 4),
        blurRadius: 28,
        color: Colors.black.withOpacity(0.15),
      ),
    ],
  );
  static TextStyle appBarTextStyle = TextStyle(
    fontSize: 28.sp,
    fontWeight: FontWeight.w400,
    color: AppColors.kLightPantone,
  );

  static TextStyle black500TextStyle(double fontSize) {
    return TextStyle(
      fontSize: fontSize.sp,
      fontWeight: FontWeight.w500,
    );
  }
  static TextStyle black400TextStyle(double fontSize) {
    return TextStyle(
      fontSize: fontSize.sp,
      fontWeight: FontWeight.w400,
    );
  }

  static TextStyle black600TextStyle(double fontSize) {
    return TextStyle(
      fontSize: fontSize.sp,
      fontWeight: FontWeight.w600,
    );
  }

  static final TextStyle hintTextStyle = TextStyle(
    fontSize: 12.sp,
    letterSpacing: 2.2,
    color: Colors.black.withOpacity(0.8),
  );

  static final TextStyle labelTextStyle = TextStyle(
    fontSize: 12.sp,
    letterSpacing: 2.5,
    fontWeight: FontWeight.w500,
    color: Colors.black,
  );

  static final TextStyle buttonTextStyle = TextStyle(
    fontSize: 12.sp,
    fontWeight: FontWeight.w500,
    letterSpacing: 2.2,
  );

  static AppBar appBar(String title, BuildContext context,
      [hasLeading = true]) {
    return AppBar(
      backgroundColor: AppColors.kAubergine,
      centerTitle: true,
      title: Text(
        title,
        style: appBarTextStyle,
      ),
      leading: hasLeading
          ? IconButton(
              onPressed: () {
                Navigator.pop(context);
              },
              icon: const Icon(
                Icons.arrow_back_ios,
                color: AppColors.kLightPantone,
              ),
            )
          : null,
    );
  }
}
