import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hot_desking/core/app_colors.dart';
import 'package:hot_desking/core/app_helpers.dart';
import 'package:hot_desking/core/widgets/show_snackbar.dart';
import 'package:hot_desking/features/booking/data/models/table_model.dart';

class Level14Layout extends StatefulWidget {
  final Function(TableModel? table) selectedTable;
  const Level14Layout({Key? key, required this.selectedTable})
      : super(key: key);

  @override
  State<Level14Layout> createState() => _Level14LayoutState();
}

class _Level14LayoutState extends State<Level14Layout> {
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
    return Container(
      height: 650.h,
      child: ListView(
        shrinkWrap: true,
        scrollDirection: Axis.horizontal,
        children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              table6seaterHoriz(10, bookedTables[10] ?? []),
              table6seaterHoriz(9, bookedTables[9] ?? []),
              // const SizedBox(
              //   height: 200,
              // ),
              table6seaterVert(8, bookedTables[8] ?? []),
              table6seaterHoriz(7, bookedTables[7] ?? []),
            ],
          ),
          SizedBox(
            width: 20.w,
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                height: 20.h,
              ),
              Row(
                children: [
                  table7(16, bookedTables[16] ?? []),
                  table7(15, bookedTables[15] ?? []),
                  table6seaterVert(14, bookedTables[14] ?? []),
                  table6seaterVert(13, bookedTables[13] ?? []),
                  table6(12, bookedTables[12] ?? []),
                  table6(11, bookedTables[11] ?? []),
                ],
              ),
              const Spacer(),
              Row(
                children: [
                  table3(6, bookedTables[6] ?? []),
                  table3(5, bookedTables[5] ?? []),
                  table3(4, bookedTables[4] ?? []),
                  table3(3, bookedTables[3] ?? []),
                  table3(2, bookedTables[2] ?? []),
                  table3(1, bookedTables[1] ?? []),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget table3(int tableNo, List<int> seats) {
    return Transform.scale(
      scale: 0.8,
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
      ),
    );
  }

  Transform table7(int tableNo, List<int> seats) {
    return Transform.scale(
      scale: 0.8,
      child: Transform.rotate(
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
      ),
    );
  }

  Transform table6(int tableNo, List<int> seats) {
    return Transform.scale(
      scale: 0.8,
      child: Transform.rotate(
        angle: 40,
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
      ),
    );
  }

  Widget table6seaterHoriz(int tableNo, List<int> seats) {
    return Transform.scale(
      scale: 0.8,
      child: RotatedBox(
        quarterTurns: 1,
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
      ),
    );
  }

  Widget table6seaterVert(int tableNo, List<int> seats) {
    return Transform.scale(
      scale: 0.8,
      child: RotatedBox(
        quarterTurns: 2,
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
      ),
    );
  }
}
