import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hot_desking/core/app_colors.dart';
import 'package:hot_desking/core/app_theme.dart';

class SeatSelection extends StatelessWidget {
  SeatSelection({Key? key}) : super(key: key);
  final TextStyle buttonTextStyle = TextStyle(
    fontSize: 12.sp,
    fontWeight: FontWeight.w500,
    letterSpacing: 2.2,
  );

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 391.h,
      width: 301.w,
      padding: EdgeInsets.only(
        left: 15.w,
        bottom: 28.h,
        right: 15.w,
        top: 20.h,
      ),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        color: Colors.white,
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              InkWell(
                  onTap: () => Navigator.pop(context),
                  child: Icon(Icons.close)),
            ],
          ),
          Text(
            'Seat Selection',
            style: AppTheme.black600TextStyle(15),
          ),
          Image.asset(
            'assets/chairs/seat_selection_layout.png',
            height: 120.h,
            width: 180.w,
          ),
          Padding(
            padding: const EdgeInsets.only(left: 30.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    colorKey(AppColors.kOrange),
                    SizedBox(
                      width: 15.w,
                    ),
                    Text(
                      'Requested',
                      style: AppTheme.black500TextStyle(10),
                    ),
                  ],
                ),
                SizedBox(
                  height: 10.h,
                ),
                Row(
                  children: [
                    colorKey(AppColors.kNavyBlue),
                    SizedBox(
                      width: 15.w,
                    ),
                    Text(
                      'Occupied',
                      style: AppTheme.black500TextStyle(10),
                    ),
                  ],
                ),
                SizedBox(
                  height: 10.h,
                ),
                Row(
                  children: [
                    colorKey(AppColors.kTeal),
                    SizedBox(
                      width: 15.w,
                    ),
                    Text(
                      'Avaiable',
                      style: AppTheme.black500TextStyle(10),
                    ),
                  ],
                ),
                SizedBox(
                  height: 10.h,
                ),
                Row(
                  children: [
                    colorKey(AppColors.kRed),
                    SizedBox(
                      width: 15.w,
                    ),
                    Text(
                      'Booked',
                      style: AppTheme.black500TextStyle(10),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Align(
            alignment: Alignment.bottomRight,
            child: InkWell(
              onTap: () => Navigator.pop(context),
              child: Container(
                height: 27.h,
                width: 90.w,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10.0),
                  color: AppColors.kEvergreen,
                ),
                child: Center(
                  child: Text(
                    'Done',
                    style: buttonTextStyle,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Container colorKey(Color color) {
    return Container(
      height: 12.5.h,
      width: 25.w,
      decoration: BoxDecoration(
        border: Border.all(width: 0.2),
        borderRadius: BorderRadius.circular(10),
        color: color,
      ),
    );
  }
}
