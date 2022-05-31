import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:hot_desking/core/app_theme.dart';
import 'package:hot_desking/features/booking/widgets/confirm_button.dart';

class BookingConfirmedWidget extends StatelessWidget {
  final String message;

  final String startTime;

  final String endTime;

  final int tableNo;

  final int seatNo;

  final String date;

  final String floor;

  BookingConfirmedWidget(this.startTime, this.endTime, this.tableNo,
      this.seatNo, this.date, this.floor,
      {Key? key, this.message = 'Booking Confirmed'})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 460.h,
      width: 326.w,
      decoration: AppTheme.boxDecoration,
      child: Stack(
        alignment: Alignment.topRight,
        children: [
          // IconButton(
          //   onPressed: () {
          //     Navigator.pop(context);
          //   },
          //   icon: const Icon(
          //     Icons.close,
          //     size: 30,
          //   ),
          // ),
          Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
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
                const SizedBox(
                  height: 30,
                ),
                _buildRichTextWidget("Date : ", date.toString()),
                const SizedBox(
                  height: 15,
                ),
                _buildRichTextWidget("Floor : ", floor.toString()),
                const SizedBox(
                  height: 15,
                ),
                _buildRichTextWidget("Table No : ", tableNo.toString()),
                const SizedBox(
                  height: 15,
                ),
                _buildRichTextWidget("Seat No : ", "HDG${seatNo.toString()}"),
                const SizedBox(
                  height: 15,
                ),
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
                GestureDetector(
                  onTap: () {
                    Get.back();
                    // Get.back();
                  },
                  child: Padding(
                    padding: const EdgeInsets.all(18.0),
                    child: confirmButton(text: "Done"),
                  ),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }

  RichText _buildRichTextWidget(String key, String value) {
    return RichText(
      text: TextSpan(
          text: key,
          style: AppTheme.black400TextStyle(20).copyWith(color: Colors.black),
          children: [
            TextSpan(
              text: value,
              style:
                  AppTheme.black600TextStyle(21).copyWith(color: Colors.black),
            )
          ]),
    );
  }
}
