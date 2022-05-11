import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hot_desking/core/app_theme.dart';

class BookingConfirmedWidget extends StatelessWidget {
  final String message;

  final String startTime;

  final String endTime;

  BookingConfirmedWidget(this.startTime, this.endTime,
      {Key? key, this.message = 'Booking\nConfirmed'})
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
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'Start time: $startTime',
                  style: AppTheme.black500TextStyle(20),
                ),
                const SizedBox(
                  height: 15,
                ),
                Text(
                  'End time: $endTime',
                  style: AppTheme.black500TextStyle(20),
                ),
                const SizedBox(
                  height: 30,
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
          ),
        ],
      ),
    );
  }
}
