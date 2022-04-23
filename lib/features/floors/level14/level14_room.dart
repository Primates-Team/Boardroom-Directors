import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hot_desking/core/app_colors.dart';
import 'package:hot_desking/core/app_helpers.dart';

class Level14Room extends StatefulWidget {
  final Function(int? room) selectedRoom;
  const Level14Room({Key? key, required this.selectedRoom}) : super(key: key);

  @override
  State<Level14Room> createState() => _Level14RoomState();
}

class _Level14RoomState extends State<Level14Room> {
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
    return SizedBox(
      height: 600,
      child: ListView(
        shrinkWrap: true,
        scrollDirection: Axis.horizontal,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: EdgeInsets.only(left: 300.w),
                child: simpleTableWidget(),
              ),
              Padding(
                padding: EdgeInsets.only(left: 150.0.w),
                child: longTableWidget(),
              ),
              semiCircleRoom(),
            ],
          ),
        ],
      ),
    );
  }

  Widget semiCircleRoom() {
    return InkWell(
      onTap: () => selectRoom(1),
      child: Container(
        color: seats.contains(1)
            ? AppColors.kRed
            : selectedRoom == 1
                ? AppColors.kOrange
                : Colors.transparent,
        child: RotatedBox(
          quarterTurns: 3,
          child: Stack(
            alignment: Alignment.center,
            children: [
              Image.asset(
                semiCircleTable,
                height: 115.w,
              ),
              Positioned(
                top: 25.w,
                left: 0.w,
                child: RotatedBox(
                  quarterTurns: 2,
                  child: Image.asset(
                    semiCircleChair,
                    height: 30.w,
                  ),
                ),
              ),
              Positioned(
                top: 25.w,
                right: 0.w,
                child: RotatedBox(
                  quarterTurns: 4,
                  child: Image.asset(
                    semiCircleChair,
                    height: 30.w,
                  ),
                ),
              ),
              Positioned(
                bottom: 0.w,
                left: 0.w,
                child: RotatedBox(
                  quarterTurns: 2,
                  child: Image.asset(
                    semiCircleChair,
                    height: 30.w,
                  ),
                ),
              ),
              Positioned(
                bottom: 0.w,
                right: 0.w,
                child: RotatedBox(
                  quarterTurns: 4,
                  child: Image.asset(
                    semiCircleChair,
                    height: 30.w,
                  ),
                ),
              ),
              Positioned(
                top: 0.w,
                child: RotatedBox(
                  quarterTurns: 3,
                  child: Image.asset(
                    semiCircleChair,
                    height: 30.w,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget longTableWidget() {
    return InkWell(
      onTap: () => selectRoom(2),
      child: Container(
        color: seats.contains(2)
            ? AppColors.kRed
            : selectedRoom == 2
                ? AppColors.kOrange
                : Colors.transparent,
        child: Stack(
          children: [
            Image.asset(
              longTable,
              height: 115.w,
              width: 90.w,
            ),
            Positioned(
              top: 0.w,
              child: RotatedBox(
                quarterTurns: 2,
                child: Image.asset(
                  semiCircleChair,
                  height: 25.w,
                ),
              ),
            ),
            Positioned(
              top: 25.w,
              child: RotatedBox(
                quarterTurns: 2,
                child: Image.asset(
                  semiCircleChair,
                  height: 25.w,
                ),
              ),
            ),
            Positioned(
              top: 45.w,
              child: RotatedBox(
                quarterTurns: 2,
                child: Image.asset(
                  semiCircleChair,
                  height: 25.w,
                ),
              ),
            ),
            Positioned(
              bottom: 25.w,
              child: RotatedBox(
                quarterTurns: 2,
                child: Image.asset(
                  semiCircleChair,
                  height: 25.w,
                ),
              ),
            ),
            Positioned(
              bottom: 0.w,
              child: RotatedBox(
                quarterTurns: 2,
                child: Image.asset(
                  semiCircleChair,
                  height: 25.w,
                ),
              ),
            ),
            Positioned(
              top: 0.w,
              right: 0.w,
              child: RotatedBox(
                quarterTurns: 4,
                child: Image.asset(
                  semiCircleChair,
                  height: 25.w,
                ),
              ),
            ),
            Positioned(
              top: 25.w,
              right: 0.w,
              child: RotatedBox(
                quarterTurns: 4,
                child: Image.asset(
                  semiCircleChair,
                  height: 25.w,
                ),
              ),
            ),
            Positioned(
              top: 45.w,
              right: 0.w,
              child: RotatedBox(
                quarterTurns: 4,
                child: Image.asset(
                  semiCircleChair,
                  height: 25.w,
                ),
              ),
            ),
            Positioned(
              bottom: 25.w,
              right: 0.w,
              child: RotatedBox(
                quarterTurns: 4,
                child: Image.asset(
                  semiCircleChair,
                  height: 25.w,
                ),
              ),
            ),
            Positioned(
              bottom: 0.w,
              right: 0.w,
              child: RotatedBox(
                quarterTurns: 4,
                child: Image.asset(
                  semiCircleChair,
                  height: 25.w,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget simpleTableWidget() {
    return InkWell(
      onTap: () => selectRoom(3),
      child: Container(
        color: seats.contains(3)
            ? AppColors.kRed
            : selectedRoom == 3
                ? AppColors.kOrange
                : Colors.transparent,
        child: Stack(
          alignment: Alignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 10.0),
              child: Image.asset(
                simpleTable,
                height: 115.w,
                width: 100.w,
                fit: BoxFit.contain,
              ),
            ),
            Positioned(
              bottom: 10.w,
              left: 0.w,
              child: RotatedBox(
                quarterTurns: 2,
                child: Image.asset(
                  starChair,
                  height: 25.w,
                ),
              ),
            ),
            Positioned(
              top: 10.w,
              right: 0.w,
              child: RotatedBox(
                quarterTurns: 4,
                child: Image.asset(
                  starChair,
                  height: 25.w,
                ),
              ),
            ),
            Positioned(
              top: 10.w,
              left: 0.w,
              child: RotatedBox(
                quarterTurns: 2,
                child: Image.asset(
                  starChair,
                  height: 25.w,
                ),
              ),
            ),
            Positioned(
              bottom: 10.w,
              right: 0.w,
              child: RotatedBox(
                quarterTurns: 4,
                child: Image.asset(
                  starChair,
                  height: 25.w,
                ),
              ),
            ),
            Positioned(
              bottom: 30.w,
              right: 0.w,
              child: RotatedBox(
                quarterTurns: 4,
                child: Image.asset(
                  starChair,
                  height: 25.w,
                ),
              ),
            ),
            Positioned(
              top: 30.w,
              right: 0.w,
              child: RotatedBox(
                quarterTurns: 4,
                child: Image.asset(
                  starChair,
                  height: 25.w,
                ),
              ),
            ),
            Positioned(
              top: 55.w,
              right: 0.w,
              child: RotatedBox(
                quarterTurns: 4,
                child: Image.asset(
                  starChair,
                  height: 25.w,
                ),
              ),
            ),
            Positioned(
              bottom: 30.w,
              left: 0.w,
              child: RotatedBox(
                quarterTurns: 2,
                child: Image.asset(
                  starChair,
                  height: 25.w,
                ),
              ),
            ),
            Positioned(
              top: 30.w,
              left: 0.w,
              child: RotatedBox(
                quarterTurns: 2,
                child: Image.asset(
                  starChair,
                  height: 25.w,
                ),
              ),
            ),
            Positioned(
              top: 55.w,
              left: 0.w,
              child: RotatedBox(
                quarterTurns: 2,
                child: Image.asset(
                  starChair,
                  height: 25.w,
                ),
              ),
            ),
            Positioned(
              bottom: 0.w,
              child: RotatedBox(
                quarterTurns: 1,
                child: Image.asset(
                  starChair,
                  height: 25.w,
                ),
              ),
            ),
            Positioned(
              top: 0.w,
              child: RotatedBox(
                quarterTurns: 3,
                child: Image.asset(
                  starChair,
                  height: 25.w,
                ),
              ),
            ),
            Positioned(
              top: 0.w,
              right: 15.w,
              child: RotatedBox(
                quarterTurns: 3,
                child: Image.asset(
                  starChair,
                  height: 25.w,
                ),
              ),
            ),
            Positioned(
              top: 0.w,
              left: 15.w,
              child: RotatedBox(
                quarterTurns: 3,
                child: Image.asset(
                  starChair,
                  height: 25.w,
                ),
              ),
            ),
            Positioned(
              bottom: 0.w,
              right: 15.w,
              child: RotatedBox(
                quarterTurns: 1,
                child: Image.asset(
                  starChair,
                  height: 25.w,
                ),
              ),
            ),
            Positioned(
              bottom: 0.w,
              left: 15.w,
              child: RotatedBox(
                quarterTurns: 1,
                child: Image.asset(
                  starChair,
                  height: 25.w,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
