import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:hot_desking/core/app_theme.dart';
import 'package:hot_desking/features/booking/data/datasource/room_booking_datasource.dart';
import 'package:hot_desking/features/booking/widgets/confirm_button.dart';

class RoomBookingController extends GetxController with StateMixin {
  Future<void> createBooking(
      int roomId,
      String startDate,
      String endDate,
      String fromTime,
      String toTime,
      List<String> members,
      String floor,
      String roomName) async {
    change(null, status: RxStatus.loading());

    Get.back();

    var response = await RoomBookingDataSource().createRoomBooking(
        roomId: roomId,
        startDate: startDate,
        endDate: endDate,
        fromTime: fromTime,
        toTime: toTime,
        members: members,
        floor: floor);

    if (response) {
      change(null, status: RxStatus.success());

      RoomBookingDataSource().viewAllRoomBooking();
      Get.dialog(BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 2.5, sigmaY: 2.5),
        child: Dialog(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
          child: RoomBookingConfirmedWidget(fromTime, toTime, roomName, floor),
        ),
      ));
    } else {
      change(null, status: RxStatus.error());
    }

    //     .then((value) {
    //   if (value) {
    //     Get.back();
    //     showDialog(
    //         context: context,
    //         barrierDismissible: false,
    //         builder: (context) {
    //           return BackdropFilter(
    //             filter: ImageFilter.blur(sigmaX: 2.5, sigmaY: 2.5),
    //             child: Dialog(
    //               shape: RoundedRectangleBorder(
    //                   borderRadius: BorderRadius.circular(20.0)),
    //               child: BookingConfirmedWidget(
    //                   _formattedStartTime!, _formattedEndTime!),
    //             ),
    //           );
    //         });
    //     RoomBookingDataSource().viewAllRoomBooking();
    //   } else {
    //     Get.back();
    //   }
    // });
  }
}

class RoomBookingConfirmedWidget extends StatefulWidget {
  final String message;

  final String startTime;

  final String endTime;

  final String roomName;

  final String floor;

  RoomBookingConfirmedWidget(
      this.startTime, this.endTime, this.roomName, this.floor,
      {Key? key, this.message = 'Booking Confirmed'})
      : super(key: key);

  @override
  State<RoomBookingConfirmedWidget> createState() =>
      _RoomBookingConfirmedWidgetState();
}

class _RoomBookingConfirmedWidgetState
    extends State<RoomBookingConfirmedWidget> {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 380.h,
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
                    widget.message,
                    style: TextStyle(
                      fontSize: 25.sp,
                      fontWeight: FontWeight.w700,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
                const SizedBox(
                  height: 30,
                ),
                _buildRichTextWidget("Room Name : ", widget.roomName),
                const SizedBox(
                  height: 15,
                ),
                _buildRichTextWidget("Floor : ", widget.floor),
                const SizedBox(
                  height: 15,
                ),
                _buildRichTextWidget("Start time: ", widget.startTime),
                const SizedBox(
                  height: 15,
                ),
                _buildRichTextWidget("End time: ", widget.endTime),
                const SizedBox(
                  height: 30,
                ),
                Padding(
                  padding: const EdgeInsets.all(18.0),
                  child: GestureDetector(
                      onTap: () {
                        Get.back();
                      },
                      child: confirmButton(text: "Done")),
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
