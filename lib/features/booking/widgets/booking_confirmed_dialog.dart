import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hot_desking/core/app_theme.dart';

class BookingConfirmedWidget extends StatelessWidget {
  final String message;
  const BookingConfirmedWidget({Key? key, this.message = 'Booking\nConfirmed'})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 241.h,
      width: 326.w,
      decoration: AppTheme.boxDecoration,
      child: Stack(
        alignment: Alignment.topRight,
        children: [
          IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: const Icon(
              Icons.close,
              size: 30,
            ),
          ),
          Center(
            child: Text(
              message,
              style: TextStyle(
                fontSize: 30.sp,
                fontWeight: FontWeight.w700,
              ),
              textAlign: TextAlign.center,
            ),
          ),
        ],
      ),
    );
  }
}
