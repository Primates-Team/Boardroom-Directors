import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:hot_desking/core/app_colors.dart';
import 'package:hot_desking/core/app_helpers.dart';
import 'package:hot_desking/core/widgets/show_snackbar.dart';
import 'package:hot_desking/features/booking/data/models/table_model.dart';
import 'package:hot_desking/features/booking/presentation/getX/booking_controller.dart';

class Level3Layout extends StatefulWidget {
  final Function(TableModel? table) selectedTable;
  const Level3Layout({Key? key, required this.selectedTable}) : super(key: key);

  @override
  State<Level3Layout> createState() => _Level3LayoutState();
}

class _Level3LayoutState extends State<Level3Layout> {

  int table = 0;
  int seat = 0;
  Map<int, List<int>> bookedTables = bookingController.bookedSeats;

  selectTable(int tableNo, int seatNo) {
    print(bookedTables);
    print('$tableNo $seatNo');
    if (bookedTables.containsKey(tableNo) && bookedTables[tableNo] != null) {
      if (bookedTables[tableNo]!.contains(seatNo)) {
        showSnackBar(context: context, message: 'Seat Already booked');
      } else {
        setState(() {
          table = tableNo;
          seat = seatNo;
        });
        print('$table $seat');
        var model = TableModel(
            tableNo: tableNo,
            seats: [SeatModel(seatNo: seatNo, status: SeatStatus.Selected)]);
        widget.selectedTable(model);
      }
    } else {
      setState(() {
        table = tableNo;
        seat = seatNo;
      });
      print('$table $seat');
      var model = TableModel(
          tableNo: tableNo,
          seats: [SeatModel(seatNo: seatNo, status: SeatStatus.Selected)]);
      widget.selectedTable(model);
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
                table3(3, bookedTables[3] ?? []),
                table3(4, bookedTables[4] ?? []),
                table3(5, bookedTables[5] ?? []),
              ],
            ),
            Row(
              children: [
                Column(
                  children: [
                    table2(2, bookedTables[2] ?? []),
                    table2(1, bookedTables[1] ?? []),
                  ],
                ),
                Expanded(
                  child: Column(
                    children: [
                      table6(6, bookedTables[6] ?? []),
                      SizedBox(
                        height: 20.h,
                      ),
                      table7(7, bookedTables[7] ?? []),
                    ],
                  ),
                )
              ],
            ),
          ],
        ),
      );
    });
  }

  Widget table3(int tableNo, List<int> seats) {
    return Stack(
      children: [
        Image.asset(
          table4Seater,
          height: 115.w,
        ),
        Positioned(
          top: 10.w,
          left: 10.w,
          child: InkWell(
            onTap: () => selectTable(tableNo, 2),
            child: Image.asset(
              squareChair,
              height: 30.w,
              color: seats.contains(2)
                  ? AppColors.kRed
                  : (table == tableNo && seat == 2)
                      ? AppColors.kOrange
                      : AppColors.kEvergreen,
            ),
          ),
        ),
        Positioned(
          top: 10.w,
          right: 5.w,
          child: InkWell(
            onTap: () => selectTable(tableNo, 3),
            child: Image.asset(
              squareChair,
              height: 30.w,
              color: seats.contains(3)
                  ? AppColors.kRed
                  : (table == tableNo && seat == 3)
                      ? AppColors.kOrange
                      : AppColors.kEvergreen,
            ),
          ),
        ),
        Positioned(
          bottom: 10.w,
          left: 10.w,
          child: InkWell(
            onTap: () => selectTable(tableNo, 1),
            child: Image.asset(
              squareChair,
              height: 30.w,
              color: seats.contains(1)
                  ? AppColors.kRed
                  : (table == tableNo && seat == 1)
                      ? AppColors.kOrange
                      : AppColors.kEvergreen,
            ),
          ),
        ),
        Positioned(
          bottom: 10.w,
          right: 5.w,
          child: InkWell(
            onTap: () => selectTable(tableNo, 4),
            child: Image.asset(
              squareChair,
              height: 30.w,
              color: seats.contains(4)
                  ? AppColors.kRed
                  : (table == tableNo && seat == 4)
                      ? AppColors.kOrange
                      : AppColors.kEvergreen,
            ),
          ),
        ),
      ],
    );
  }

  Widget table2(int tableNo, List<int> seats) {
    return RotatedBox(
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
            child: InkWell(
              onTap: () => selectTable(tableNo, 3),
              child: Image.asset(
                squareChair,
                height: 30.w,
                color: seats.contains(3)
                    ? AppColors.kRed
                    : (table == tableNo && seat == 3)
                        ? AppColors.kOrange
                        : AppColors.kEvergreen,
              ),
            ),
          ),
          Positioned(
            top: 10.w,
            right: 5.w,
            child: InkWell(
              onTap: () => selectTable(tableNo, 4),
              child: Image.asset(
                squareChair,
                height: 30.w,
                color: seats.contains(4)
                    ? AppColors.kRed
                    : (table == tableNo && seat == 4)
                        ? AppColors.kOrange
                        : AppColors.kEvergreen,
              ),
            ),
          ),
          Positioned(
            bottom: 10.w,
            left: 10.w,
            child: InkWell(
              onTap: () => selectTable(tableNo, 2),
              child: Image.asset(
                squareChair,
                height: 30.w,
                color: seats.contains(2)
                    ? AppColors.kRed
                    : (table == tableNo && seat == 2)
                        ? AppColors.kOrange
                        : AppColors.kEvergreen,
              ),
            ),
          ),
          Positioned(
            bottom: 10.w,
            right: 5.w,
            child: InkWell(
              onTap: () => selectTable(tableNo, 1),
              child: Image.asset(
                squareChair,
                height: 30.w,
                color: seats.contains(1)
                    ? AppColors.kRed
                    : (table == tableNo && seat == 1)
                        ? AppColors.kOrange
                        : AppColors.kEvergreen,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Stack table6(int tableNo, List<int> seats) {
    return Stack(
      alignment: Alignment.center,
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Image.asset(
            table8Seater,
            width: 130.w,
          ),
        ),
        Positioned(
          top: 10.w,
          right: 5.w,
          child: RotatedBox(
            quarterTurns: 3,
            child: InkWell(
              onTap: () => selectTable(tableNo, 5),
              child: Image.asset(
                ovalChair,
                height: 30.w,
                color: seats.contains(5)
                    ? AppColors.kRed
                    : (table == tableNo && seat == 5)
                        ? AppColors.kOrange
                        : AppColors.kEvergreen,
              ),
            ),
          ),
        ),
        Positioned(
          bottom: 10.w,
          right: 5.w,
          child: RotatedBox(
            quarterTurns: 1,
            child: InkWell(
              onTap: () => selectTable(tableNo, 7),
              child: Image.asset(
                ovalChair,
                height: 30.w,
                color: seats.contains(7)
                    ? AppColors.kRed
                    : (table == tableNo && seat == 7)
                        ? AppColors.kOrange
                        : AppColors.kEvergreen,
              ),
            ),
          ),
        ),
        Positioned(
          // bottom: 10.w,
          right: 0.w,
          child: RotatedBox(
            quarterTurns: 4,
            child: InkWell(
              onTap: () => selectTable(tableNo, 6),
              child: Image.asset(
                ovalChair,
                height: 30.w,
                color: seats.contains(6)
                    ? AppColors.kRed
                    : (table == tableNo && seat == 6)
                        ? AppColors.kOrange
                        : AppColors.kEvergreen,
              ),
            ),
          ),
        ),
        Positioned(
          top: 10.w,
          left: 5.w,
          child: RotatedBox(
            quarterTurns: 3,
            child: InkWell(
              onTap: () => selectTable(tableNo, 3),
              child: Image.asset(
                ovalChair,
                height: 30.w,
                color: seats.contains(3)
                    ? AppColors.kRed
                    : (table == tableNo && seat == 3)
                        ? AppColors.kOrange
                        : AppColors.kEvergreen,
              ),
            ),
          ),
        ),
        Positioned(
          bottom: 10.w,
          left: 5.w,
          child: RotatedBox(
            quarterTurns: 1,
            child: InkWell(
              onTap: () => selectTable(tableNo, 1),
              child: Image.asset(
                ovalChair,
                height: 30.w,
                color: seats.contains(1)
                    ? AppColors.kRed
                    : (table == tableNo && seat == 1)
                        ? AppColors.kOrange
                        : AppColors.kEvergreen,
              ),
            ),
          ),
        ),
        Positioned(
          // bottom: 10.w,
          left: 0.w,
          child: RotatedBox(
            quarterTurns: 4,
            child: InkWell(
              onTap: () => selectTable(tableNo, 2),
              child: Image.asset(
                ovalChair,
                height: 30.w,
                color: seats.contains(2)
                    ? AppColors.kRed
                    : (table == tableNo && seat == 2)
                        ? AppColors.kOrange
                        : AppColors.kEvergreen,
              ),
            ),
          ),
        ),
        Positioned(
          bottom: 10.w,
          // left: 0.w,
          child: RotatedBox(
            quarterTurns: 1,
            child: InkWell(
              onTap: () => selectTable(tableNo, 8),
              child: Image.asset(
                ovalChair,
                height: 30.w,
                color: seats.contains(8)
                    ? AppColors.kRed
                    : (table == tableNo && seat == 8)
                        ? AppColors.kOrange
                        : AppColors.kEvergreen,
              ),
            ),
          ),
        ),
        Positioned(
          top: 10.w,
          // left: 0.w,
          child: RotatedBox(
            quarterTurns: 3,
            child: InkWell(
              onTap: () => selectTable(tableNo, 4),
              child: Image.asset(
                ovalChair,
                height: 30.w,
                color: seats.contains(4)
                    ? AppColors.kRed
                    : (table == tableNo && seat == 4)
                        ? AppColors.kOrange
                        : AppColors.kEvergreen,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Transform table7(int tableNo, List<int> seats) {
    return Transform.rotate(
      angle: 180,
      child: Stack(
        alignment: Alignment.center,
        children: [
          Image.asset(
            table6Seater,
            height: 150,
          ),
          Positioned(
            top: 15.w,
            left: 15.w,
            child: InkWell(
              onTap: () => selectTable(tableNo, 6),
              child: Image.asset(
                squareChair,
                height: 30,
                color: seats.contains(6)
                    ? AppColors.kRed
                    : (table == tableNo && seat == 6)
                        ? AppColors.kOrange
                        : AppColors.kEvergreen,
              ),
            ),
          ),
          Positioned(
            top: 15.w,
            right: 10.w,
            child: InkWell(
              onTap: () => selectTable(tableNo, 1),
              child: Image.asset(
                squareChair,
                height: 30,
                color: seats.contains(1)
                    ? AppColors.kRed
                    : (table == tableNo && seat == 1)
                        ? AppColors.kOrange
                        : AppColors.kEvergreen,
              ),
            ),
          ),
          Positioned(
            bottom: 10.w,
            left: 15.w,
            child: InkWell(
              onTap: () => selectTable(tableNo, 4),
              child: Image.asset(
                squareChair,
                height: 30,
                color: seats.contains(4)
                    ? AppColors.kRed
                    : (table == tableNo && seat == 4)
                        ? AppColors.kOrange
                        : AppColors.kEvergreen,
              ),
            ),
          ),
          Positioned(
            bottom: 10.w,
            right: 10.w,
            child: InkWell(
              onTap: () => selectTable(tableNo, 3),
              child: Image.asset(
                squareChair,
                height: 30,
                color: seats.contains(3)
                    ? AppColors.kRed
                    : (table == tableNo && seat == 3)
                        ? AppColors.kOrange
                        : AppColors.kEvergreen,
              ),
            ),
          ),
          Positioned(
            // top: 10.w,
            left: 15.w,
            child: InkWell(
              onTap: () => selectTable(tableNo, 5),
              child: Image.asset(
                squareChair,
                height: 30,
                color: seats.contains(5)
                    ? AppColors.kRed
                    : (table == tableNo && seat == 5)
                        ? AppColors.kOrange
                        : AppColors.kEvergreen,
              ),
            ),
          ),
          Positioned(
            // bottom: 10.w,
            right: 10.w,
            child: InkWell(
              onTap: () => selectTable(tableNo, 2),
              child: Image.asset(
                squareChair,
                height: 30,
                color: seats.contains(2)
                    ? AppColors.kRed
                    : (table == tableNo && seat == 2)
                        ? AppColors.kOrange
                        : AppColors.kEvergreen,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
