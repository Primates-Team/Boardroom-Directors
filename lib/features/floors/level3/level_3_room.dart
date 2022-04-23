import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:hot_desking/core/app_colors.dart';
import 'package:hot_desking/core/app_helpers.dart';
import 'package:hot_desking/core/widgets/show_snackbar.dart';
import 'package:hot_desking/features/booking/data/models/table_model.dart';
import 'package:hot_desking/features/booking/presentation/getX/booking_controller.dart';

class Level3Room extends StatefulWidget {
  final Function(int? room) selectedRoom;
  const Level3Room({Key? key, required this.selectedRoom}) : super(key: key);

  @override
  State<Level3Room> createState() => _Level3RoomState();
}

class _Level3RoomState extends State<Level3Room> {
  int selectedRoom = 0;
  List<int> seats = bookingController.bookedRooms.value;

  selectRoom(int roomId) {
    if (!seats.contains(roomId)) {
      setState(() {
        selectedRoom = roomId;
      });
      widget.selectedRoom(roomId);
    }
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<BookingController>(builder: (controller) {
      return Container(
        // height: 100,
        width: double.infinity,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                table3(3),
                table3(4),
                table3(5),
              ],
            ),
            Row(
              children: [
                Column(
                  children: [
                    table2(2),
                    table2(1),
                  ],
                ),
              ],
            ),
          ],
        ),
      );
    });
  }

  Widget table3(int tableNo) {
    return InkWell(
      onTap: () => selectRoom(tableNo),
      child: Container(
        color: seats.contains(tableNo)
            ? AppColors.kRed
            : selectedRoom == tableNo
                ? AppColors.kOrange
                : Colors.transparent,
        child: Stack(
          children: [
            Image.asset(
              table4Seater,
              height: 115.w,
            ),
            Positioned(
              top: 10.w,
              left: 10.w,
              child: InkWell(
                onTap: () => selectRoom(tableNo),
                child: Image.asset(
                  squareChair,
                  height: 30.w,
                ),
              ),
            ),
            Positioned(
              top: 10.w,
              right: 5.w,
              child: Image.asset(
                squareChair,
                height: 30.w,
              ),
            ),
            Positioned(
              bottom: 10.w,
              left: 10.w,
              child: Image.asset(
                squareChair,
                height: 30.w,
              ),
            ),
            Positioned(
              bottom: 10.w,
              right: 5.w,
              child: Image.asset(
                squareChair,
                height: 30.w,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget table2(int tableNo) {
    return InkWell(
      onTap: () => selectRoom(tableNo),
      child: Container(
        color: seats.contains(tableNo)
            ? AppColors.kRed
            : selectedRoom == tableNo
                ? AppColors.kOrange
                : Colors.transparent,
        child: RotatedBox(
          quarterTurns: 1,
          child: Stack(
            children: [
              Image.asset(
                table4Seater,
                height: 120.w,
              ),
              Positioned(
                top: 10.w,
                left: 10.w,
                child: Image.asset(
                  squareChair,
                  height: 30.w,
                ),
              ),
              Positioned(
                top: 10.w,
                right: 5.w,
                child: Image.asset(
                  squareChair,
                  height: 30.w,
                ),
              ),
              Positioned(
                bottom: 10.w,
                left: 10.w,
                child: Image.asset(
                  squareChair,
                  height: 30.w,
                ),
              ),
              Positioned(
                bottom: 10.w,
                right: 5.w,
                child: Image.asset(
                  squareChair,
                  height: 30.w,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
