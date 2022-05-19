import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:hot_desking/core/app_colors.dart';
import 'package:hot_desking/core/app_helpers.dart';
import 'package:hot_desking/core/app_urls.dart';
import 'package:hot_desking/core/widgets/show_snackbar.dart';
import 'package:hot_desking/features/booking/data/models/table_model.dart';
import 'package:hot_desking/features/booking/presentation/getX/booking_controller.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

class Level3Layout extends StatefulWidget {
  final Function(TableModel? table) selectedTable;
  String selectedFloor;

  Level3Layout(this.selectedFloor, {Key? key, required this.selectedTable})
      : super(key: key);

  @override
  State<Level3Layout> createState() => _Level3LayoutState();
}

class _Level3LayoutState extends State<Level3Layout> {
  int table = 0;
  int seat = 0;
  // Map<int, List<int>> bookedTables = bookingController.bookedSeats;
  late Map<int, List<int>> bookedTables;

  // List<Map<int, int>> tableData = bookingController.tableData;

  Map<int, List<int>> modifiedTables = {};

  Future<List<Map<int, int>>> callAPI() async {
    var inputDate = DateTime.parse(DateTime.now().toString());
    var outputFormat = DateFormat('dd-MM-yyyy');
    var outputDate = outputFormat.format(inputDate);
    var client = http.Client();
    try {
      var response = await client.post(Uri.parse(AppUrl.tableBookedByFloor),
          headers: {HttpHeaders.contentTypeHeader: 'application/json'},
          body: jsonEncode({
            "selecteddate": outputDate,
            "floor": widget.selectedFloor,
            "current_time": AppHelpers.formatTime(TimeOfDay.now())
          }));

      List<dynamic> jsondata = jsonDecode(response.body);

      List<Map<int, int>> tableData = [];

      for (var element in jsondata) {
        Map<int, int> tableSeatDict = {
          jsonDecode(element)["tableid"]: jsonDecode(element)["seatno"]
        };

        tableData.add(tableSeatDict);
      }

      bookingController.tableData = tableData;

      for (var i = 1; i < 8; i++) {
        modifiedTables[i] = [];
        for (var element in tableData) {
          if (element.containsKey(i)) {
            modifiedTables[i]?.add(element.values.first);
          }
        }
      }
      return tableData;
    } catch (e) {
      return [];
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    // for (var i = 1; i < 8; i++) {
    //   modifiedTables[i] = [];
    //   tableData.forEach((element) {
    //     if (element.containsKey(i)) {
    //       modifiedTables[i]?.add(element.values.first);
    //     }
    //   });
    // }

    bookedTables = modifiedTables;
    // print(modifiedTables);
  }

  selectTable(int tableNo, int seatNo) {
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

      var model = TableModel(
          tableNo: tableNo,
          seats: [SeatModel(seatNo: seatNo, status: SeatStatus.Selected)]);
      widget.selectedTable(model);
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Map<int, int>>>(
      future: callAPI(), // async work
      builder:
          (BuildContext context, AsyncSnapshot<List<Map<int, int>>> snapshot) {
        switch (snapshot.connectionState) {
          case ConnectionState.waiting:
            return const Center(
              child: CircularProgressIndicator(),
            );
          default:
            if (snapshot.hasError) {
              return Text('Error: ${snapshot.error}');
            } else {
              return GetBuilder<BookingController>(builder: (controller) {
                return Container(
                  color: Colors.white,
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: [
                        SizedBox(
                          // height: 100,
                          width: MediaQuery.of(context).size.width,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  table3(
                                      3, bookedTables[3] ?? [], Colors.purple),
                                  table3(
                                      4, bookedTables[4] ?? [], Colors.yellow),
                                  table3(
                                      5, bookedTables[5] ?? [], Colors.yellow),
                                ],
                              ),
                              Row(
                                children: [
                                  Column(
                                    children: [
                                      table2(2, bookedTables[2] ?? [],
                                          Colors.green),
                                      const SizedBox(
                                        height: 10,
                                      ),
                                      table2(1, bookedTables[1] ?? [],
                                          Colors.green),
                                    ],
                                  ),
                                  Expanded(
                                    child: Column(
                                      children: [
                                        table6(6, bookedTables[6] ?? [],
                                            Colors.green),
                                        SizedBox(
                                          height: 20.h,
                                        ),
                                        table7(7, bookedTables[7] ?? [],
                                            Colors.green),
                                      ],
                                    ),
                                  )
                                ],
                              ),
                            ],
                          ),
                        ),
                        Image.asset(
                          "assets/level3/floor3.png",
                          height: MediaQuery.of(context).size.height * 0.7,
                        )
                      ],
                    ),
                  ),
                );
              });
            }
        }
      },
    );
  }

  Widget table3(int tableNo, List<int> seats, Color tableColor) {
    return Stack(
      children: [
        Container(
          color: tableColor,
          child: Image.asset(
            table4Seater,
            height: 115.w,
          ),
        ),
        Positioned(
          top: 10.w,
          left: 10.w,
          child: InkWell(
            onTap: () {
              //selectTable(tableNo, 2);
            },
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

  Widget table2(int tableNo, List<int> seats, Color tableColor) {
    return RotatedBox(
      quarterTurns: 1,
      child: Stack(
        children: [
          Container(
            color: tableColor,
            child: Image.asset(
              table4Seater,
              height: 120.w,
            ),
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

  Stack table6(int tableNo, List<int> seats, Color tableColor) {
    return Stack(
      alignment: Alignment.center,
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Container(
            color: tableColor,
            child: Image.asset(
              table8Seater,
              width: 130.w,
            ),
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

  Transform table7(int tableNo, List<int> seats, Color tableColor) {
    return Transform.rotate(
      angle: 180,
      child: Stack(
        alignment: Alignment.center,
        children: [
          Container(
            color: tableColor,
            child: Image.asset(
              table6Seater,
              height: 150,
            ),
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
