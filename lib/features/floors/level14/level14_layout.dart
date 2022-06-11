import 'dart:convert';
import 'dart:io';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
// import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hot_desking/core/app_colors.dart';
import 'package:hot_desking/core/app_helpers.dart';
import 'package:hot_desking/core/app_urls.dart';
import 'package:hot_desking/core/widgets/show_snackbar.dart';
import 'package:hot_desking/features/booking/data/datasource/table_booking_datasource.dart';
import 'package:hot_desking/features/booking/data/models/table_model.dart';
import 'package:hot_desking/features/booking/presentation/getX/booking_controller.dart';
import 'package:hot_desking/features/booking/widgets/booking_confirmed_dialog.dart';
import 'package:hot_desking/features/booking/widgets/table_booking_dialog.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

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
  int? tableNo, seatNo;
  String? displayName;
  late Map<int, List<int>> bookedTables;

  List<Map<int, int>> tableData = bookingController.tableData;
  String _selectedFloor = 'Floor 14';
  Map<int, List<int>> modifiedTables = {};

  callnext() async {
    var inputDate = DateTime.parse(DateTime.now().toString());
    var outputFormat = DateFormat('dd-MM-yyyy');
    var outputDate = outputFormat.format(inputDate);
    var client = http.Client();
    try {
      var response = await client.post(Uri.parse(AppUrl.tableBookedByFloor),
          headers: {HttpHeaders.contentTypeHeader: 'application/json'},
          body: jsonEncode({
            "selecteddate": outputDate,
            "floor": _selectedFloor,
            "current_time": AppHelpers.formatTime(TimeOfDay.now())
          }));

      List<dynamic> jsondata = jsonDecode(response.body);

      List<Map<int, int>> tableData = [];

      jsondata.forEach((element) {
        Map<int, int> tableSeatDict = {
          int.parse(element["tableid"]): int.parse(element["seatno"])
          // jsonDecode(element)["tableid"]: jsonDecode(element)["seatno"]
        };

        tableData.add(tableSeatDict);
      });

      bookingController.tableData = tableData;
    } catch (e) {}
  }

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
            "floor": _selectedFloor,
            "current_time": AppHelpers.formatTime(TimeOfDay.now())
          }));

      List<dynamic> jsondata = jsonDecode(response.body);

      List<Map<int, int>> tableData = [];

      jsondata.forEach((element) {
        Map<int, int> tableSeatDict = {
          int.parse(element["tableid"]): int.parse(element["seatnumber"])
          // jsonDecode(element)["tableid"]: jsonDecode(element)["seatno"]
        };

        tableData.add(tableSeatDict);
      });

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

    for (var i = 1; i < 17; i++) {
      modifiedTables[i] = [];
      tableData.forEach((element) {
        if (element.containsKey(i)) {
          modifiedTables[i]?.add(element.values.first);
        }
      });
    }

    callAPI();
    callnext();

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
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
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
                return SizedBox(
                  height: height,
                  width: width,
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Stack(
                      children: [
                        RotatedBox(
                            quarterTurns: 4,
                            child: SvgPicture.asset(
                              'assets/svg/level14/mAP_14level14.svg',
                              height: height,
                              width: width,
                            )

                            // SvgPicture.asset(
                            //   'assets/Svg_images/Frame-4.svg',
                            // height: 1000.h,
                            // width: width,
                            // ),
                            ),
                        Positioned(
                            top: 90.h,
                            left: 150.w,
                            child: InkWell(
                              child: SvgPicture.asset(
                                  'assets/svg/level14/Frame 56level14.svg',
                                  width: 100.w,
                                  // height: 110.h,
                                  fit: BoxFit.fitWidth),
                              onTap: () {
                                setState(() {});
                                _buildDateSelectionDialog(7);
                              },
                            )),
                        Positioned(
                            top: 190.h,
                            left: 150.w,
                            child: InkWell(
                              child: SvgPicture.asset(
                                  'assets/svg/level14/Frame 57level14.svg',
                                  width: 100.w,
                                  // height: 110.h,
                                  fit: BoxFit.fitWidth),
                              onTap: () {
                                setState(() {});
                                _buildDateSelectionDialog(8);
                              },
                            )),
                        Positioned(
                            top: 380.h,
                            left: 150.w,
                            child: InkWell(
                              child: SvgPicture.asset(
                                  'assets/svg/level14/Frame 58level14.svg',
                                  width: 100.w,
                                  // height: 110.h,
                                  fit: BoxFit.fitWidth),
                              onTap: () {
                                setState(() {});
                                _buildDateSelectionDialog(9);
                              },
                            )),
                        Positioned(
                            top: 480.h,
                            left: 150.w,
                            child: InkWell(
                              child: SvgPicture.asset(
                                  'assets/svg/level14/Frame 59level14.svg',
                                  width: 100.w,
                                  // height: 110.h,
                                  fit: BoxFit.fitWidth),
                              onTap: () {
                                setState(() {});
                                _buildDateSelectionDialog(10);
                              },
                            )),
                        Positioned(
                            top: 650.h,
                            left: 240.w,
                            child: InkWell(
                              child: SvgPicture.asset(
                                  'assets/svg/level14/Frame 60level14.svg',
                                  width: 70.w,
                                  // height: 110.h,
                                  fit: BoxFit.fitWidth),
                              onTap: () {
                                setState(() {});
                                _buildDateSelectionDialog(11);
                              },
                            )),
                        Positioned(
                            top: 650.h,
                            left: 320.w,
                            child: InkWell(
                              child: SvgPicture.asset(
                                  'assets/svg/level14/Frame 61level14.svg',
                                  width: 70.w,
                                  // height: 110.h,
                                  fit: BoxFit.fitWidth),
                              onTap: () {
                                setState(() {});
                                _buildDateSelectionDialog(12);
                              },
                            )),
                        Positioned(
                            top: 650.h,
                            left: 400.w,
                            child: InkWell(
                              child: SvgPicture.asset(
                                  'assets/svg/level14/Frame 62level14.svg',
                                  width: 70.w,
                                  // height: 110.h,
                                  fit: BoxFit.fitWidth),
                              onTap: () {
                                setState(() {});
                                _buildDateSelectionDialog(13);
                              },
                            )),
                        Positioned(
                            top: 650.h,
                            left: 476.w,
                            child: InkWell(
                              child: SvgPicture.asset(
                                  'assets/svg/level14/Frame 63level14.svg',
                                  width: 70.w,
                                  // height: 110.h,
                                  fit: BoxFit.fitWidth),
                              onTap: () {
                                setState(() {});
                                _buildDateSelectionDialog(14);
                              },
                            )),
                        Positioned(
                            top: 650.h,
                            left: 550.w,
                            child: InkWell(
                              child: SvgPicture.asset(
                                  'assets/svg/level14/Frame 64level14.svg',
                                  width: 70.w,
                                  // height: 110.h,
                                  fit: BoxFit.fitWidth),
                              onTap: () {
                                setState(() {});
                                _buildDateSelectionDialog(15);
                              },
                            )),
                        Positioned(
                            top: 650.h,
                            left: 625.w,
                            child: InkWell(
                              child: SvgPicture.asset(
                                  'assets/svg/level14/Frame 65level14.svg',
                                  width: 70.w,
                                  // height: 110.h,
                                  fit: BoxFit.fitWidth),
                              onTap: () {
                                setState(() {});
                                _buildDateSelectionDialog(16);
                              },
                            )),
                        Positioned(
                            top: 650.h,
                            left: 700.w,
                            child: InkWell(
                              child: SvgPicture.asset(
                                  'assets/svg/level14/Frame 66level14.svg',
                                  width: 70.w,
                                  // height: 110.h,
                                  fit: BoxFit.fitWidth),
                              onTap: () {
                                setState(() {});
                                _buildDateSelectionDialog(17);
                              },
                            )),
                        Positioned(
                            top: 60.h,
                            left: 260.w,
                            child: InkWell(
                              child: SvgPicture.asset(
                                  'assets/background_floor/floor14/Table_6.svg',
                                  width: 100.w,
                                  // height: 110.h,
                                  fit: BoxFit.fitWidth),
                              onTap: () {
                                setState(() {});
                                _buildDateSelectionDialog(6);
                              },
                            )),
                        Positioned(
                            top: 60.h,
                            left: 360.w,
                            child: InkWell(
                              child: SvgPicture.asset(
                                  'assets/background_floor/floor14/Table_5.svg',
                                  width: 100.w,
                                  // height: 110.h,
                                  fit: BoxFit.fitWidth),
                              onTap: () {
                                setState(() {});
                                _buildDateSelectionDialog(5);
                              },
                            )),
                        Positioned(
                            top: 60.h,
                            left: 460.w,
                            child: InkWell(
                              child: SvgPicture.asset(
                                  'assets/background_floor/floor14/Table_4.svg',
                                  width: 100.w,
                                  // height: 110.h,
                                  fit: BoxFit.fitWidth),
                              onTap: () {
                                setState(() {});
                                _buildDateSelectionDialog(4);
                              },
                            )),
                        Positioned(
                            top: 60.h,
                            left: 540.w,
                            child: InkWell(
                              child: SvgPicture.asset(
                                  'assets/background_floor/floor14/Table_3.svg',
                                  width: 100.w,
                                  // height: 110.h,
                                  fit: BoxFit.fitWidth),
                              onTap: () {
                                setState(() {});
                                _buildDateSelectionDialog(3);
                              },
                            )),
                        Positioned(
                            top: 60.h,
                            left: 630.w,
                            child: InkWell(
                              child: SvgPicture.asset(
                                  'assets/background_floor/floor14/Table_2.svg',
                                  width: 100.w,
                                  // height: 110.h,
                                  fit: BoxFit.fitWidth),
                              onTap: () {
                                setState(() {});
                                _buildDateSelectionDialog(2);
                              },
                            )),
                        Positioned(
                            top: 60.h,
                            left: 720.w,
                            child: InkWell(
                              child: SvgPicture.asset(
                                  'assets/background_floor/floor14/Table_1.svg',
                                  width: 100.w,
                                  // height: 110.h,
                                  fit: BoxFit.fitWidth),
                              onTap: () {
                                setState(() {});
                                _buildDateSelectionDialog(1);
                              },
                            )),
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

  _buildDateSelectionDialog(int tableNumber) async {
    return showDialog(
        context: context,
        builder: (context) {
          return Dialog(
            child:
                TableBookingDateDialog((Map<String, dynamic> jsonData) async {
              jsonData["floor"] = _selectedFloor;
              jsonData["employeeid"] =
                  AppHelpers.SHARED_PREFERENCES.getInt('user_id') != null
                      ? AppHelpers.SHARED_PREFERENCES
                          .getInt('user_id')
                          .toString()
                      : 1.toString();

              List<Map<int, int>> bookedSeats =
                  await TableBookingDataSource().viewAllBooking(jsonData);

              for (var i = 1; i < 20; i++) {
                modifiedTables[i] = [];
                for (var element in bookedSeats) {
                  if (element.containsKey(i)) {
                    modifiedTables[i]?.add(element.values.first);
                  }
                }
              }

              bookedTables = modifiedTables;

              if (tableNumber == 1) {
                showTabledetails1(1, bookedTables[1] ?? [], jsonData);
              } else if (tableNumber == 2) {
                showTabledetails2(2, bookedTables[2] ?? [], jsonData);
              } else if (tableNumber == 3) {
                showTabledetails3(3, bookedTables[3] ?? [], jsonData);
              } else if (tableNumber == 4) {
                showTabledetails4(4, bookedTables[4] ?? [], jsonData);
              } else if (tableNumber == 5) {
                showTabledetails5(5, bookedTables[5] ?? [], jsonData);
              } else if (tableNumber == 6) {
                showTabledetails6(6, bookedTables[6] ?? [], jsonData);
              } else if (tableNumber == 7) {
                showTabledetails7(7, bookedTables[7] ?? [], jsonData);
              } else if (tableNumber == 8) {
                showTabledetails8(8, bookedTables[8] ?? [], jsonData);
              } else if (tableNumber == 9) {
                showTabledetails9(9, bookedTables[9] ?? [], jsonData);
              } else if (tableNumber == 10) {
                showTabledetails10(10, bookedTables[10] ?? [], jsonData);
              } else if (tableNumber == 11) {
                showTabledetails11(11, bookedTables[11] ?? [], jsonData);
              } else if (tableNumber == 12) {
                showTabledetails12(12, bookedTables[12] ?? [], jsonData);
              } else if (tableNumber == 13) {
                showTabledetails13(13, bookedTables[13] ?? [], jsonData);
              } else if (tableNumber == 14) {
                showTabledetails14(14, bookedTables[14] ?? [], jsonData);
              } else if (tableNumber == 15) {
                showTabledetails15(15, bookedTables[15] ?? [], jsonData);
              } else if (tableNumber == 16) {
                showTabledetails16(16, bookedTables[16] ?? [], jsonData);
              } else if (tableNumber == 17) {
                showTabledetails17(17, bookedTables[17] ?? [], jsonData);
              }
            }),
          );
        });
  }

  showTabledetails1(
      int tableNo, List<int> seats, Map<String, dynamic> data) async {
    await callAPI();
    return showDialog(
        context: context,
        builder: (context) {
          return StatefulBuilder(
              builder: (BuildContext context, StateSetter setState) {
            return Center(
              child: Card(
                child: Container(
                  height: MediaQuery.of(context).size.height * 0.57,
                  width: MediaQuery.of(context).size.width * 0.9,
                  // margin: const EdgeInsets.only(
                  //   left: 16.09,
                  //   right: 7.09,
                  // ),
                  padding: EdgeInsets.all(20.r),
                  decoration: const BoxDecoration(
                    color: Colors.white,
                  ),
                  child: Column(
                    //     mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      SizedBox(
                        height: 10.h,
                        width: MediaQuery.of(context).size.width,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            // ignore: avoid_unnecessary_containers
                            InkWell(
                              child: Icon(
                                Icons.close_rounded,
                                size: 20.r,
                              ),
                              onTap: () {
                                Navigator.pop(context);
                              },
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 20.6.h,
                      ),
                      Text(
                        "Seat Selection",
                        style: GoogleFonts.lato(
                          textStyle: TextStyle(
                              fontSize: 15.sp, fontWeight: FontWeight.w700),
                        ),
                      ),
                      SizedBox(
                        height: 20.6.h,
                      ),
                      // ignore: sized_box_for_whitespace
                      Container(
                        height: MediaQuery.of(context).size.height * 0.24,
                        width: MediaQuery.of(context).size.width,
                        // color: Colors.lightBlue,
                        // margin: const EdgeInsets.only(
                        //     top: 34.32, left: 48.41, right: 48.41),
                        child: Stack(
                          children: [
                            Center(
                                child: SvgPicture.asset(
                                    'assets/table/tableleftangle.svg',
                                    height: 200.h,
                                    width: 800.w)),
                            Positioned(
                              top: 94.h,
                              left: 205.w,
                              child: InkWell(
                                child: Column(
                                  children: [
                                    Text("HDG1"),
                                    RotatedBox(
                                      quarterTurns: 4,
                                      child: Image.asset(
                                        "assets/chairs/available.png",
                                        color: seats.contains(1)
                                            ? AppColors.kRed
                                            : (table == tableNo && seat == 1)
                                                ? AppColors.kOrange
                                                : AppColors.kEvergreen,
                                        height: 22.r,
                                      ),
                                    ),
                                  ],
                                ),
                                onTap: () {
                                  setState(() {
                                    updateTable(tableNo, 1, 'HDG1');
                                  });
                                },
                              ),
                            ),
                            Positioned(
                              top: 136.h,
                              left: 115.w,
                              child: InkWell(
                                child: Column(
                                  children: [
                                    RotatedBox(
                                      quarterTurns: 4,
                                      child: Image.asset(
                                        "assets/chairs/available.png",
                                        color: seats.contains(2)
                                            ? AppColors.kRed
                                            : (table == tableNo && seat == 2)
                                                ? AppColors.kOrange
                                                : AppColors.kEvergreen,
                                        height: 22.r,
                                      ),
                                    ),
                                    Text("HDG2"),
                                  ],
                                ),
                                onTap: () {
                                  setState(() {
                                    updateTable(tableNo, 2, 'HDG2');
                                  });
                                },
                              ),
                            ),
                            Positioned(
                              top: 100.h,
                              left: 93.w,
                              child: InkWell(
                                child: Column(
                                  children: [
                                    RotatedBox(
                                      quarterTurns: 4,
                                      child: Image.asset(
                                        "assets/chairs/available.png",
                                        color: seats.contains(3)
                                            ? AppColors.kRed
                                            : (table == tableNo && seat == 3)
                                                ? AppColors.kOrange
                                                : AppColors.kEvergreen,
                                        height: 22.r,
                                      ),
                                    ),
                                    Text("HDG3"),
                                  ],
                                ),
                                onTap: () {
                                  setState(() {
                                    updateTable(tableNo, 3, 'HDG3');
                                  });
                                },
                              ),
                            ),
                            Positioned(
                              top: 60.h,
                              left: 70.w,
                              child: InkWell(
                                child: Column(
                                  children: [
                                    RotatedBox(
                                      quarterTurns: 4,
                                      child: Image.asset(
                                        "assets/chairs/available.png",
                                        color: seats.contains(4)
                                            ? AppColors.kRed
                                            : (table == tableNo && seat == 4)
                                                ? AppColors.kOrange
                                                : AppColors.kEvergreen,
                                        height: 22.r,
                                      ),
                                    ),
                                    Text("HDG4"),
                                  ],
                                ),
                                onTap: () {
                                  setState(() {
                                    updateTable(tableNo, 4, 'HDG4');
                                  });
                                },
                              ),
                            ),
                            Positioned(
                              top: 20.h,
                              left: 165.w,
                              child: InkWell(
                                child: Column(
                                  children: [
                                    Text("HDG5"),
                                    RotatedBox(
                                      quarterTurns: 4,
                                      child: Image.asset(
                                        "assets/chairs/available.png",
                                        color: seats.contains(5)
                                            ? AppColors.kRed
                                            : (table == tableNo && seat == 5)
                                                ? AppColors.kOrange
                                                : AppColors.kEvergreen,
                                        height: 22.r,
                                      ),
                                    ),
                                  ],
                                ),
                                onTap: () {
                                  setState(() {
                                    updateTable(tableNo, 5, 'HDG5');
                                  });
                                },
                              ),
                            ),
                            Positioned(
                              top: 55.h,
                              left: 185.w,
                              child: InkWell(
                                child: Column(
                                  children: [
                                    Text("HDG6"),
                                    RotatedBox(
                                      quarterTurns: 4,
                                      child: Image.asset(
                                        "assets/chairs/available.png",
                                        color: seats.contains(6)
                                            ? AppColors.kRed
                                            : (table == tableNo && seat == 6)
                                                ? AppColors.kOrange
                                                : AppColors.kEvergreen,
                                        height: 22.r,
                                      ),
                                    ),
                                  ],
                                ),
                                onTap: () {
                                  setState(() {
                                    updateTable(tableNo, 6, 'HDG6');
                                  });
                                },
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 10.92.h,
                      ),
                      Row(
                        children: [
                          Container(
                            height: 15.61,
                            width: 31.21,
                            margin: const EdgeInsets.only(
                              left: 53.69,
                            ),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              color: const Color(0xFFEA893B),
                            ),
                          ),
                          Container(
                            margin: const EdgeInsets.only(
                              left: 18.73,
                            ),
                            child: Text(
                              "Selected",
                              style: GoogleFonts.lato(
                                textStyle: const TextStyle(
                                    fontSize: 10, fontWeight: FontWeight.w500),
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 15.61,
                      ),

                      Row(
                        children: [
                          Container(
                            height: 15.61,
                            width: 31.21,
                            margin: const EdgeInsets.only(
                              left: 53.69,
                            ),
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                color: AppColors.kEvergreen),
                          ),
                          Container(
                            margin: const EdgeInsets.only(
                              left: 18.73,
                            ),
                            child: Text(
                              "Available",
                              style: GoogleFonts.lato(
                                textStyle: const TextStyle(
                                    fontSize: 10, fontWeight: FontWeight.w500),
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 15.61,
                      ),
                      Row(
                        children: [
                          Container(
                            height: 15.61,
                            width: 31.21,
                            margin: const EdgeInsets.only(
                              left: 53.69,
                            ),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              color: const Color(0xFFD14751),
                            ),
                          ),
                          Container(
                            margin: const EdgeInsets.only(
                              left: 18.73,
                            ),
                            child: Text(
                              "Booked",
                              style: GoogleFonts.lato(
                                textStyle: const TextStyle(
                                    fontSize: 10, fontWeight: FontWeight.w500),
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 15,
                      ),
                      Center(
                        child: ElevatedButton(
                          style: ButtonStyle(
                              backgroundColor: MaterialStateProperty.all(
                                  AppColors.kAubergine)),
                          onPressed: () {
                            _performTableBooking(data);
                          },
                          child: const Text('Book'),
                        ),
                      )
                    ],
                  ),
                ),
              ),
            );
          });
        });
  }

  showTabledetails2(
      int tableNo, List<int> seats, Map<String, dynamic> data) async {
    await callAPI();
    return showDialog(
        context: context,
        builder: (context) {
          return StatefulBuilder(
              builder: (BuildContext context, StateSetter setState) {
            return Center(
              child: Card(
                child: Container(
                  height: MediaQuery.of(context).size.height * 0.57,
                  width: MediaQuery.of(context).size.width * 0.9,
                  // margin: const EdgeInsets.only(
                  //   left: 16.09,
                  //   right: 7.09,
                  // ),
                  padding: EdgeInsets.all(20.r),
                  decoration: const BoxDecoration(
                    color: Colors.white,
                  ),
                  child: Column(
                    //     mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      SizedBox(
                        height: 10.h,
                        width: MediaQuery.of(context).size.width,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            // ignore: avoid_unnecessary_containers
                            InkWell(
                              child: Icon(
                                Icons.close_rounded,
                                size: 20.r,
                              ),
                              onTap: () {
                                Navigator.pop(context);
                              },
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 20.6.h,
                      ),
                      Text(
                        "Seat Selection",
                        style: GoogleFonts.lato(
                          textStyle: TextStyle(
                              fontSize: 15.sp, fontWeight: FontWeight.w700),
                        ),
                      ),
                      SizedBox(
                        height: 20.6.h,
                      ),
                      // ignore: sized_box_for_whitespace
                      Container(
                        height: MediaQuery.of(context).size.height * 0.24,
                        width: MediaQuery.of(context).size.width,
                        // color: Colors.lightBlue,
                        // margin: const EdgeInsets.only(
                        //     top: 34.32, left: 48.41, right: 48.41),
                        child: Stack(
                          children: [
                            Center(
                                child: SvgPicture.asset(
                                    'assets/table/tableleftangle.svg',
                                    height: 200.h,
                                    width: 800.w)),
                            Positioned(
                              top: 94.h,
                              left: 205.w,
                              child: InkWell(
                                child: Column(
                                  children: [
                                    Text("HDG7"),
                                    RotatedBox(
                                      quarterTurns: 4,
                                      child: Image.asset(
                                        "assets/chairs/available.png",
                                        color: seats.contains(7)
                                            ? AppColors.kRed
                                            : (table == tableNo && seat == 7)
                                                ? AppColors.kOrange
                                                : AppColors.kEvergreen,
                                        height: 22.r,
                                      ),
                                    ),
                                  ],
                                ),
                                onTap: () {
                                  setState(() {
                                    updateTable(tableNo, 7, 'HDG7');
                                  });
                                },
                              ),
                            ),
                            Positioned(
                              top: 142.h,
                              left: 110.w,
                              child: InkWell(
                                child: Column(
                                  children: [
                                    RotatedBox(
                                      quarterTurns: 4,
                                      child: Image.asset(
                                        "assets/chairs/available.png",
                                        color: seats.contains(8)
                                            ? AppColors.kRed
                                            : (table == tableNo && seat == 8)
                                                ? AppColors.kOrange
                                                : AppColors.kEvergreen,
                                        height: 22.r,
                                      ),
                                    ),
                                    Text("HDG8"),
                                  ],
                                ),
                                onTap: () {
                                  setState(() {
                                    updateTable(tableNo, 8, 'HDG8');
                                  });
                                },
                              ),
                            ),
                            Positioned(
                              top: 103.h,
                              left: 88.w,
                              child: InkWell(
                                child: Column(
                                  children: [
                                    RotatedBox(
                                      quarterTurns: 4,
                                      child: Image.asset(
                                        "assets/chairs/available.png",
                                        color: seats.contains(9)
                                            ? AppColors.kRed
                                            : (table == tableNo && seat == 9)
                                                ? AppColors.kOrange
                                                : AppColors.kEvergreen,
                                        height: 22.r,
                                      ),
                                    ),
                                    Text("HDG9"),
                                  ],
                                ),
                                onTap: () {
                                  setState(() {
                                    updateTable(tableNo, 9, 'HDG9');
                                  });
                                },
                              ),
                            ),
                            Positioned(
                              top: 60.h,
                              left: 60.w,
                              child: InkWell(
                                child: Column(
                                  children: [
                                    RotatedBox(
                                      quarterTurns: 4,
                                      child: Image.asset(
                                        "assets/chairs/available.png",
                                        color: seats.contains(10)
                                            ? AppColors.kRed
                                            : (table == tableNo && seat == 10)
                                                ? AppColors.kOrange
                                                : AppColors.kEvergreen,
                                        height: 22.r,
                                      ),
                                    ),
                                    Text("HDG10"),
                                  ],
                                ),
                                onTap: () {
                                  setState(() {
                                    updateTable(tableNo, 10, 'HDG10');
                                  });
                                },
                              ),
                            ),
                            Positioned(
                              top: 20.h,
                              left: 165.w,
                              child: InkWell(
                                child: Column(
                                  children: [
                                    Text("HDG11"),
                                    RotatedBox(
                                      quarterTurns: 4,
                                      child: Image.asset(
                                        "assets/chairs/available.png",
                                        color: seats.contains(11)
                                            ? AppColors.kRed
                                            : (table == tableNo && seat == 11)
                                                ? AppColors.kOrange
                                                : AppColors.kEvergreen,
                                        height: 22.r,
                                      ),
                                    ),
                                  ],
                                ),
                                onTap: () {
                                  setState(() {
                                    updateTable(tableNo, 11, 'HDG11');
                                  });
                                },
                              ),
                            ),
                            Positioned(
                              top: 55.h,
                              left: 185.w,
                              child: InkWell(
                                child: Column(
                                  children: [
                                    Text("HDG12"),
                                    RotatedBox(
                                      quarterTurns: 4,
                                      child: Image.asset(
                                        "assets/chairs/available.png",
                                        color: seats.contains(12)
                                            ? AppColors.kRed
                                            : (table == tableNo && seat == 12)
                                                ? AppColors.kOrange
                                                : AppColors.kEvergreen,
                                        height: 22.r,
                                      ),
                                    ),
                                  ],
                                ),
                                onTap: () {
                                  setState(() {
                                    updateTable(tableNo, 12, 'HDG12');
                                  });
                                },
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 10.92.h,
                      ),
                      Row(
                        children: [
                          Container(
                            height: 15.61,
                            width: 31.21,
                            margin: const EdgeInsets.only(
                              left: 53.69,
                            ),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              color: const Color(0xFFEA893B),
                            ),
                          ),
                          Container(
                            margin: const EdgeInsets.only(
                              left: 18.73,
                            ),
                            child: Text(
                              "Selected",
                              style: GoogleFonts.lato(
                                textStyle: const TextStyle(
                                    fontSize: 10, fontWeight: FontWeight.w500),
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 15.61,
                      ),

                      Row(
                        children: [
                          Container(
                            height: 15.61,
                            width: 31.21,
                            margin: const EdgeInsets.only(
                              left: 53.69,
                            ),
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                color: AppColors.kEvergreen),
                          ),
                          Container(
                            margin: const EdgeInsets.only(
                              left: 18.73,
                            ),
                            child: Text(
                              "Available",
                              style: GoogleFonts.lato(
                                textStyle: const TextStyle(
                                    fontSize: 10, fontWeight: FontWeight.w500),
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 15.61,
                      ),
                      Row(
                        children: [
                          Container(
                            height: 15.61,
                            width: 31.21,
                            margin: const EdgeInsets.only(
                              left: 53.69,
                            ),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              color: const Color(0xFFD14751),
                            ),
                          ),
                          Container(
                            margin: const EdgeInsets.only(
                              left: 18.73,
                            ),
                            child: Text(
                              "Booked",
                              style: GoogleFonts.lato(
                                textStyle: const TextStyle(
                                    fontSize: 10, fontWeight: FontWeight.w500),
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 15,
                      ),
                      Center(
                        child: ElevatedButton(
                          style: ButtonStyle(
                              backgroundColor: MaterialStateProperty.all(
                                  AppColors.kAubergine)),
                          onPressed: () {
                            _performTableBooking(data);
                          },
                          child: const Text('Book'),
                        ),
                      )
                    ],
                  ),
                ),
              ),
            );
          });
        });
  }

  showTabledetails3(
      int tableNo, List<int> seats, Map<String, dynamic> data) async {
    await callAPI();
    return showDialog(
        context: context,
        builder: (context) {
          return StatefulBuilder(
              builder: (BuildContext context, StateSetter setState) {
            return Center(
              child: Card(
                child: Container(
                  height: MediaQuery.of(context).size.height * 0.57,
                  width: MediaQuery.of(context).size.width * 0.9,
                  // margin: const EdgeInsets.only(
                  //   left: 16.09,
                  //   right: 7.09,
                  // ),
                  padding: EdgeInsets.all(20.r),
                  decoration: const BoxDecoration(
                    color: Colors.white,
                  ),
                  child: Column(
                    //     mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      SizedBox(
                        height: 10.h,
                        width: MediaQuery.of(context).size.width,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            // ignore: avoid_unnecessary_containers
                            InkWell(
                              child: Icon(
                                Icons.close_rounded,
                                size: 20.r,
                              ),
                              onTap: () {
                                Navigator.pop(context);
                              },
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 20.6.h,
                      ),
                      Text(
                        "Seat Selection",
                        style: GoogleFonts.lato(
                          textStyle: TextStyle(
                              fontSize: 15.sp, fontWeight: FontWeight.w700),
                        ),
                      ),
                      SizedBox(
                        height: 20.6.h,
                      ),
                      // ignore: sized_box_for_whitespace
                      Container(
                        height: MediaQuery.of(context).size.height * 0.17,
                        width: MediaQuery.of(context).size.width,
                        // color: Colors.lightBlue,
                        // margin: const EdgeInsets.only(
                        //     top: 34.32, left: 48.41, right: 48.41),
                        child: Stack(
                          children: [
                            Center(
                                child: RotatedBox(
                              quarterTurns: 0,
                              child: SvgPicture.asset(
                                  'assets/table/rightangletable.svg',
                                  height: 120.h,
                                  width: 700.w),
                            )),

                            Positioned(
                              top: 94.h,
                              left: 190.w,
                              child: InkWell(
                                child: Column(
                                  children: [
                                    RotatedBox(
                                      quarterTurns: 4,
                                      child: Image.asset(
                                        "assets/chairs/available.png",
                                        color: seats.contains(13)
                                            ? AppColors.kRed
                                            : (table == tableNo && seat == 13)
                                                ? AppColors.kOrange
                                                : AppColors.kEvergreen,
                                        height: 22.r,
                                      ),
                                    ),
                                    Text("HDG13"),
                                  ],
                                ),
                                onTap: () {
                                  setState(() {
                                    updateTable(tableNo, 13, 'HDG13');
                                  });
                                },
                              ),
                            ),

                            Positioned(
                              top: 94.h,
                              left: 80.w,
                              child: InkWell(
                                child: Column(
                                  children: [
                                    Text("HDG14"),
                                    RotatedBox(
                                      quarterTurns: 4,
                                      child: Image.asset(
                                        "assets/chairs/available.png",
                                        color: seats.contains(14)
                                            ? AppColors.kRed
                                            : (table == tableNo && seat == 14)
                                                ? AppColors.kOrange
                                                : AppColors.kEvergreen,
                                        height: 22.r,
                                      ),
                                    ),
                                  ],
                                ),
                                onTap: () {
                                  setState(() {
                                    updateTable(tableNo, 14, 'HDG14');
                                  });
                                },
                              ),
                            ),

                            Positioned(
                              top: 50.h,
                              left: 80.w,
                              child: InkWell(
                                child: Column(
                                  children: [
                                    Text("HDG15"),
                                    RotatedBox(
                                      quarterTurns: 4,
                                      child: Image.asset(
                                        "assets/chairs/available.png",
                                        color: seats.contains(15)
                                            ? AppColors.kRed
                                            : (table == tableNo && seat == 15)
                                                ? AppColors.kOrange
                                                : AppColors.kEvergreen,
                                        height: 22.r,
                                      ),
                                    ),
                                  ],
                                ),
                                onTap: () {
                                  setState(() {
                                    updateTable(tableNo, 15, 'HDG15');
                                  });
                                },
                              ),
                            ),

                            Positioned(
                              top: 10.h,
                              left: 80.w,
                              child: InkWell(
                                child: Column(
                                  children: [
                                    Text("HDG16"),
                                    RotatedBox(
                                      quarterTurns: 4,
                                      child: Image.asset(
                                        "assets/chairs/available.png",
                                        color: seats.contains(16)
                                            ? AppColors.kRed
                                            : (table == tableNo && seat == 16)
                                                ? AppColors.kOrange
                                                : AppColors.kEvergreen,
                                        height: 22.r,
                                      ),
                                    ),
                                  ],
                                ),
                                onTap: () {
                                  setState(() {
                                    updateTable(tableNo, 16, 'HDG16');
                                  });
                                },
                              ),
                            ),

                            //
                            //
                            // Positioned(
                            //   top: 60.h,
                            //   right: 35.w,
                            //   child: InkWell(
                            //     child:
                            //     Row(
                            //       children: [

                            //         RotatedBox(

                            //           quarterTurns: 1,
                            //           child: Image.asset(

                            //             "assets/chairs/available.png", color: seats.contains(6)
                            //               ? AppColors.kRed
                            //               : (table == tableNo && seat == 6)
                            //               ? AppColors.kOrange
                            //               : AppColors.kEvergreen,
                            //             height: 22.r,),
                            //         ),
                            //         Text('6'),
                            //       ],
                            //     ),
                            //   ),
                            // ),

                            Positioned(
                              top: 10.h,
                              left: 190.w,
                              child: InkWell(
                                child: Column(
                                  children: [
                                    RotatedBox(
                                      quarterTurns: 4,
                                      child: Image.asset(
                                        "assets/chairs/available.png",
                                        color: seats.contains(17)
                                            ? AppColors.kRed
                                            : (table == tableNo && seat == 17)
                                                ? AppColors.kOrange
                                                : AppColors.kEvergreen,
                                        height: 22.r,
                                      ),
                                    ),
                                    Text("HDG17"),
                                  ],
                                ),
                                onTap: () {
                                  setState(() {
                                    updateTable(tableNo, 17, 'HDG17');
                                  });
                                },
                              ),
                            ),
                            Positioned(
                              top: 50.h,
                              left: 190.w,
                              child: InkWell(
                                child: Column(
                                  children: [
                                    RotatedBox(
                                      quarterTurns: 4,
                                      child: Image.asset(
                                        "assets/chairs/available.png",
                                        color: seats.contains(18)
                                            ? AppColors.kRed
                                            : (table == tableNo && seat == 18)
                                                ? AppColors.kOrange
                                                : AppColors.kEvergreen,
                                        height: 22.r,
                                      ),
                                    ),
                                    Text("HDG18"),
                                  ],
                                ),
                                onTap: () {
                                  setState(() {
                                    updateTable(tableNo, 18, 'HDG18');
                                  });
                                },
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 10.92.h,
                      ),
                      Row(
                        children: [
                          Container(
                            height: 15.61,
                            width: 31.21,
                            margin: const EdgeInsets.only(
                              left: 53.69,
                            ),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              color: const Color(0xFFEA893B),
                            ),
                          ),
                          Container(
                            margin: const EdgeInsets.only(
                              left: 18.73,
                            ),
                            child: Text(
                              "Selected",
                              style: GoogleFonts.lato(
                                textStyle: const TextStyle(
                                    fontSize: 10, fontWeight: FontWeight.w500),
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 15.61,
                      ),

                      Row(
                        children: [
                          Container(
                            height: 15.61,
                            width: 31.21,
                            margin: const EdgeInsets.only(
                              left: 53.69,
                            ),
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                color: AppColors.kEvergreen),
                          ),
                          Container(
                            margin: const EdgeInsets.only(
                              left: 18.73,
                            ),
                            child: Text(
                              "Available",
                              style: GoogleFonts.lato(
                                textStyle: const TextStyle(
                                    fontSize: 10, fontWeight: FontWeight.w500),
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 15.61,
                      ),
                      Row(
                        children: [
                          Container(
                            height: 15.61,
                            width: 31.21,
                            margin: const EdgeInsets.only(
                              left: 53.69,
                            ),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              color: const Color(0xFFD14751),
                            ),
                          ),
                          Container(
                            margin: const EdgeInsets.only(
                              left: 18.73,
                            ),
                            child: Text(
                              "Booked",
                              style: GoogleFonts.lato(
                                textStyle: const TextStyle(
                                    fontSize: 10, fontWeight: FontWeight.w500),
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 15,
                      ),
                      Center(
                        child: ElevatedButton(
                          style: ButtonStyle(
                              backgroundColor: MaterialStateProperty.all(
                                  AppColors.kAubergine)),
                          onPressed: () {
                            _performTableBooking(data);
                          },
                          child: const Text('Book'),
                        ),
                      )
                    ],
                  ),
                ),
              ),
            );
          });
        });
  }

  showTabledetails4(
      int tableNo, List<int> seats, Map<String, dynamic> data) async {
    await callAPI();
    return showDialog(
        context: context,
        builder: (context) {
          return StatefulBuilder(
              builder: (BuildContext context, StateSetter setState) {
            return Center(
              child: Card(
                child: Container(
                  height: MediaQuery.of(context).size.height * 0.57,
                  width: MediaQuery.of(context).size.width * 0.9,
                  // margin: const EdgeInsets.only(
                  //   left: 16.09,
                  //   right: 7.09,
                  // ),
                  padding: EdgeInsets.all(20.r),
                  decoration: const BoxDecoration(
                    color: Colors.white,
                  ),
                  child: Column(
                    //     mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      SizedBox(
                        height: 10.h,
                        width: MediaQuery.of(context).size.width,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            // ignore: avoid_unnecessary_containers
                            InkWell(
                              child: Icon(
                                Icons.close_rounded,
                                size: 20.r,
                              ),
                              onTap: () {
                                Navigator.pop(context);
                              },
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 20.6.h,
                      ),
                      Text(
                        "Seat Selection",
                        style: GoogleFonts.lato(
                          textStyle: TextStyle(
                              fontSize: 15.sp, fontWeight: FontWeight.w700),
                        ),
                      ),
                      SizedBox(
                        height: 20.6.h,
                      ),
                      // ignore: sized_box_for_whitespace
                      Container(
                        height: MediaQuery.of(context).size.height * 0.17,
                        width: MediaQuery.of(context).size.width,
                        // color: Colors.lightBlue,
                        // margin: const EdgeInsets.only(
                        //     top: 34.32, left: 48.41, right: 48.41),
                        child: Stack(
                          children: [
                            Center(
                                child: RotatedBox(
                              quarterTurns: 0,
                              child: SvgPicture.asset(
                                  'assets/table/rightangletable.svg',
                                  height: 120.h,
                                  width: 700.w),
                            )),

                            Positioned(
                              top: 94.h,
                              left: 190.w,
                              child: InkWell(
                                child: Column(
                                  children: [
                                    RotatedBox(
                                      quarterTurns: 4,
                                      child: Image.asset(
                                        "assets/chairs/available.png",
                                        color: seats.contains(19)
                                            ? AppColors.kRed
                                            : (table == tableNo && seat == 19)
                                                ? AppColors.kOrange
                                                : AppColors.kEvergreen,
                                        height: 22.r,
                                      ),
                                    ),
                                    Text("HDG19"),
                                  ],
                                ),
                                onTap: () {
                                  setState(() {
                                    updateTable(tableNo, 19, 'HDG19');
                                  });
                                },
                              ),
                            ),

                            Positioned(
                              top: 94.h,
                              left: 80.w,
                              child: InkWell(
                                child: Column(
                                  children: [
                                    Text("HDG20"),
                                    RotatedBox(
                                      quarterTurns: 4,
                                      child: Image.asset(
                                        "assets/chairs/available.png",
                                        color: seats.contains(20)
                                            ? AppColors.kRed
                                            : (table == tableNo && seat == 20)
                                                ? AppColors.kOrange
                                                : AppColors.kEvergreen,
                                        height: 22.r,
                                      ),
                                    ),
                                  ],
                                ),
                                onTap: () {
                                  setState(() {
                                    updateTable(tableNo, 20, 'HDG20');
                                  });
                                },
                              ),
                            ),

                            Positioned(
                              top: 50.h,
                              left: 80.w,
                              child: InkWell(
                                child: Column(
                                  children: [
                                    Text("HDG21"),
                                    RotatedBox(
                                      quarterTurns: 4,
                                      child: Image.asset(
                                        "assets/chairs/available.png",
                                        color: seats.contains(21)
                                            ? AppColors.kRed
                                            : (table == tableNo && seat == 21)
                                                ? AppColors.kOrange
                                                : AppColors.kEvergreen,
                                        height: 22.r,
                                      ),
                                    ),
                                  ],
                                ),
                                onTap: () {
                                  setState(() {
                                    updateTable(tableNo, 21, 'HDG21');
                                  });
                                },
                              ),
                            ),

                            Positioned(
                              top: 10.h,
                              left: 80.w,
                              child: InkWell(
                                child: Column(
                                  children: [
                                    Text("HDG22"),
                                    RotatedBox(
                                      quarterTurns: 4,
                                      child: Image.asset(
                                        "assets/chairs/available.png",
                                        color: seats.contains(22)
                                            ? AppColors.kRed
                                            : (table == tableNo && seat == 22)
                                                ? AppColors.kOrange
                                                : AppColors.kEvergreen,
                                        height: 22.r,
                                      ),
                                    ),
                                  ],
                                ),
                                onTap: () {
                                  setState(() {
                                    updateTable(tableNo, 22, 'HDG22');
                                  });
                                },
                              ),
                            ),

                            //
                            //
                            // Positioned(
                            //   top: 60.h,
                            //   right: 35.w,
                            //   child: InkWell(
                            //     child:
                            //     Row(
                            //       children: [

                            //         RotatedBox(

                            //           quarterTurns: 1,
                            //           child: Image.asset(

                            //             "assets/chairs/available.png", color: seats.contains(6)
                            //               ? AppColors.kRed
                            //               : (table == tableNo && seat == 6)
                            //               ? AppColors.kOrange
                            //               : AppColors.kEvergreen,
                            //             height: 22.r,),
                            //         ),
                            //         Text('6'),
                            //       ],
                            //     ),
                            //   ),
                            // ),

                            Positioned(
                              top: 10.h,
                              left: 190.w,
                              child: InkWell(
                                child: Column(
                                  children: [
                                    RotatedBox(
                                      quarterTurns: 4,
                                      child: Image.asset(
                                        "assets/chairs/available.png",
                                        color: seats.contains(23)
                                            ? AppColors.kRed
                                            : (table == tableNo && seat == 23)
                                                ? AppColors.kOrange
                                                : AppColors.kEvergreen,
                                        height: 22.r,
                                      ),
                                    ),
                                    Text("HDG23"),
                                  ],
                                ),
                                onTap: () {
                                  setState(() {
                                    updateTable(tableNo, 23, 'HDG23');
                                  });
                                },
                              ),
                            ),
                            Positioned(
                              top: 50.h,
                              left: 190.w,
                              child: InkWell(
                                child: Column(
                                  children: [
                                    RotatedBox(
                                      quarterTurns: 4,
                                      child: Image.asset(
                                        "assets/chairs/available.png",
                                        color: seats.contains(24)
                                            ? AppColors.kRed
                                            : (table == tableNo && seat == 24)
                                                ? AppColors.kOrange
                                                : AppColors.kEvergreen,
                                        height: 22.r,
                                      ),
                                    ),
                                    Text("HDG24"),
                                  ],
                                ),
                                onTap: () {
                                  setState(() {
                                    updateTable(tableNo, 24, 'HDG24');
                                  });
                                },
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 10.92.h,
                      ),
                      Row(
                        children: [
                          Container(
                            height: 15.61,
                            width: 31.21,
                            margin: const EdgeInsets.only(
                              left: 53.69,
                            ),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              color: const Color(0xFFEA893B),
                            ),
                          ),
                          Container(
                            margin: const EdgeInsets.only(
                              left: 18.73,
                            ),
                            child: Text(
                              "Selected",
                              style: GoogleFonts.lato(
                                textStyle: const TextStyle(
                                    fontSize: 10, fontWeight: FontWeight.w500),
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 15.61,
                      ),

                      Row(
                        children: [
                          Container(
                            height: 15.61,
                            width: 31.21,
                            margin: const EdgeInsets.only(
                              left: 53.69,
                            ),
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                color: AppColors.kEvergreen),
                          ),
                          Container(
                            margin: const EdgeInsets.only(
                              left: 18.73,
                            ),
                            child: Text(
                              "Available",
                              style: GoogleFonts.lato(
                                textStyle: const TextStyle(
                                    fontSize: 10, fontWeight: FontWeight.w500),
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 15.61,
                      ),
                      Row(
                        children: [
                          Container(
                            height: 15.61,
                            width: 31.21,
                            margin: const EdgeInsets.only(
                              left: 53.69,
                            ),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              color: const Color(0xFFD14751),
                            ),
                          ),
                          Container(
                            margin: const EdgeInsets.only(
                              left: 18.73,
                            ),
                            child: Text(
                              "Booked",
                              style: GoogleFonts.lato(
                                textStyle: const TextStyle(
                                    fontSize: 10, fontWeight: FontWeight.w500),
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 15,
                      ),
                      Center(
                        child: ElevatedButton(
                          style: ButtonStyle(
                              backgroundColor: MaterialStateProperty.all(
                                  AppColors.kAubergine)),
                          onPressed: () {
                            _performTableBooking(data);
                          },
                          child: const Text('Book'),
                        ),
                      )
                    ],
                  ),
                ),
              ),
            );
          });
        });
  }

  showTabledetails5(
      int tableNo, List<int> seats, Map<String, dynamic> data) async {
    await callAPI();
    return showDialog(
        context: context,
        builder: (context) {
          return StatefulBuilder(
              builder: (BuildContext context, StateSetter setState) {
            return Center(
              child: Card(
                child: Container(
                  height: MediaQuery.of(context).size.height * 0.59,
                  width: MediaQuery.of(context).size.width * 0.9,
                  // margin: const EdgeInsets.only(
                  //   left: 16.09,
                  //   right: 7.09,
                  // ),
                  padding: EdgeInsets.all(20.r),
                  decoration: const BoxDecoration(
                    color: Colors.white,
                  ),
                  child: Column(
                    //     mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      SizedBox(
                        height: 10.h,
                        width: MediaQuery.of(context).size.width,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            // ignore: avoid_unnecessary_containers
                            InkWell(
                              child: Icon(
                                Icons.close_rounded,
                                size: 20.r,
                              ),
                              onTap: () {
                                Navigator.pop(context);
                              },
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 20.6.h,
                      ),
                      Text(
                        "Seat Selection",
                        style: GoogleFonts.lato(
                          textStyle: TextStyle(
                              fontSize: 15.sp, fontWeight: FontWeight.w700),
                        ),
                      ),
                      SizedBox(
                        height: 20.6.h,
                      ),
                      // ignore: sized_box_for_whitespace
                      Container(
                        height: MediaQuery.of(context).size.height * 0.24,
                        width: MediaQuery.of(context).size.width,
                        // color: Colors.lightBlue,
                        // margin: const EdgeInsets.only(
                        //     top: 34.32, left: 48.41, right: 48.41),
                        child: Stack(
                          children: [
                            Center(
                                child: SvgPicture.asset(
                                    'assets/table/tableangle.svg',
                                    height: 120.h,
                                    width: 500.w)),
                            Positioned(
                              top: 150.h,
                              left: 125.w,
                              child: InkWell(
                                child: Column(
                                  children: [
                                    RotatedBox(
                                      quarterTurns: 4,
                                      child: Image.asset(
                                        "assets/chairs/available.png",
                                        color: seats.contains(25)
                                            ? AppColors.kRed
                                            : (table == tableNo && seat == 25)
                                                ? AppColors.kOrange
                                                : AppColors.kEvergreen,
                                        height: 22.r,
                                      ),
                                    ),
                                    Text("HDG25"),
                                  ],
                                ),
                                onTap: () {
                                  setState(() {
                                    updateTable(tableNo, 25, 'HDG25');
                                  });
                                },
                              ),
                            ),
                            Positioned(
                              top: 80.h,
                              left: 60.w,
                              child: InkWell(
                                child: Column(
                                  children: [
                                    Text("HDG26"),
                                    RotatedBox(
                                      quarterTurns: 4,
                                      child: Image.asset(
                                        "assets/chairs/available.png",
                                        color: seats.contains(26)
                                            ? AppColors.kRed
                                            : (table == tableNo && seat == 26)
                                                ? AppColors.kOrange
                                                : AppColors.kEvergreen,
                                        height: 22.r,
                                      ),
                                    ),
                                  ],
                                ),
                                onTap: () {
                                  setState(() {
                                    updateTable(tableNo, 26, 'HDG26');
                                  });
                                },
                              ),
                            ),
                            Positioned(
                              top: 38.h,
                              left: 100.w,
                              child: InkWell(
                                child: Column(
                                  children: [
                                    Text("HDG27"),
                                    RotatedBox(
                                      quarterTurns: 4,
                                      child: Image.asset(
                                        "assets/chairs/available.png",
                                        color: seats.contains(27)
                                            ? AppColors.kRed
                                            : (table == tableNo && seat == 27)
                                                ? AppColors.kOrange
                                                : AppColors.kEvergreen,
                                        height: 22.r,
                                      ),
                                    ),
                                  ],
                                ),
                                onTap: () {
                                  setState(() {
                                    updateTable(tableNo, 27, 'HDG27');
                                  });
                                },
                              ),
                            ),
                            Positioned(
                              //   top: 10.h,
                              left: 138.w,
                              child: InkWell(
                                child: Column(
                                  children: [
                                    Text("HDG28"),
                                    RotatedBox(
                                      quarterTurns: 4,
                                      child: Image.asset(
                                        "assets/chairs/available.png",
                                        color: seats.contains(28)
                                            ? AppColors.kRed
                                            : (table == tableNo && seat == 28)
                                                ? AppColors.kOrange
                                                : AppColors.kEvergreen,
                                        height: 22.r,
                                      ),
                                    ),
                                  ],
                                ),
                                onTap: () {
                                  setState(() {
                                    updateTable(tableNo, 28, 'HDG28');
                                  });
                                },
                              ),
                            ),
                            Positioned(
                              top: 71.h,
                              left: 210.w,
                              child: InkWell(
                                child: Column(
                                  children: [
                                    RotatedBox(
                                      quarterTurns: 4,
                                      child: Image.asset(
                                        "assets/chairs/available.png",
                                        color: seats.contains(29)
                                            ? AppColors.kRed
                                            : (table == tableNo && seat == 29)
                                                ? AppColors.kOrange
                                                : AppColors.kEvergreen,
                                        height: 22.r,
                                      ),
                                    ),
                                    Text("HDG29"),
                                  ],
                                ),
                                onTap: () {
                                  setState(() {
                                    updateTable(tableNo, 29, 'HDG29');
                                  });
                                },
                              ),
                            ),
                            Positioned(
                              top: 110.h,
                              left: 175.w,
                              child: InkWell(
                                child: Column(
                                  children: [
                                    RotatedBox(
                                      quarterTurns: 4,
                                      child: Image.asset(
                                        "assets/chairs/available.png",
                                        color: seats.contains(30)
                                            ? AppColors.kRed
                                            : (table == tableNo && seat == 30)
                                                ? AppColors.kOrange
                                                : AppColors.kEvergreen,
                                        height: 22.r,
                                      ),
                                    ),
                                    Text("HDG30"),
                                  ],
                                ),
                                onTap: () {
                                  setState(() {
                                    updateTable(tableNo, 30, 'HDG30');
                                  });
                                },
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 10.92.h,
                      ),
                      Row(
                        children: [
                          Container(
                            height: 15.61,
                            width: 31.21,
                            margin: const EdgeInsets.only(
                              left: 53.69,
                            ),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              color: const Color(0xFFEA893B),
                            ),
                          ),
                          Container(
                            margin: const EdgeInsets.only(
                              left: 18.73,
                            ),
                            child: Text(
                              "Selected",
                              style: GoogleFonts.lato(
                                textStyle: const TextStyle(
                                    fontSize: 10, fontWeight: FontWeight.w500),
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 15.61,
                      ),

                      Row(
                        children: [
                          Container(
                            height: 15.61,
                            width: 31.21,
                            margin: const EdgeInsets.only(
                              left: 53.69,
                            ),
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                color: AppColors.kEvergreen),
                          ),
                          Container(
                            margin: const EdgeInsets.only(
                              left: 18.73,
                            ),
                            child: Text(
                              "Available",
                              style: GoogleFonts.lato(
                                textStyle: const TextStyle(
                                    fontSize: 10, fontWeight: FontWeight.w500),
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 15.61,
                      ),
                      Row(
                        children: [
                          Container(
                            height: 15.61,
                            width: 31.21,
                            margin: const EdgeInsets.only(
                              left: 53.69,
                            ),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              color: const Color(0xFFD14751),
                            ),
                          ),
                          Container(
                            margin: const EdgeInsets.only(
                              left: 18.73,
                            ),
                            child: Text(
                              "Booked",
                              style: GoogleFonts.lato(
                                textStyle: const TextStyle(
                                    fontSize: 10, fontWeight: FontWeight.w500),
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 15,
                      ),
                      Center(
                        child: ElevatedButton(
                          style: ButtonStyle(
                              backgroundColor: MaterialStateProperty.all(
                                  AppColors.kAubergine)),
                          onPressed: () {
                            _performTableBooking(data);
                          },
                          child: const Text('Book'),
                        ),
                      )
                    ],
                  ),
                ),
              ),
            );
          });
        });
  }

  showTabledetails6(
      int tableNo, List<int> seats, Map<String, dynamic> data) async {
    await callAPI();
    return showDialog(
        context: context,
        builder: (context) {
          return StatefulBuilder(
              builder: (BuildContext context, StateSetter setState) {
            return Center(
              child: Card(
                child: Container(
                  height: MediaQuery.of(context).size.height * 0.59,
                  width: MediaQuery.of(context).size.width * 0.9,
                  // margin: const EdgeInsets.only(
                  //   left: 16.09,
                  //   right: 7.09,
                  // ),
                  padding: EdgeInsets.all(20.r),
                  decoration: const BoxDecoration(
                    color: Colors.white,
                  ),
                  child: Column(
                    //     mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      SizedBox(
                        height: 10.h,
                        width: MediaQuery.of(context).size.width,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            // ignore: avoid_unnecessary_containers
                            InkWell(
                              child: Icon(
                                Icons.close_rounded,
                                size: 20.r,
                              ),
                              onTap: () {
                                Navigator.pop(context);
                              },
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 20.6.h,
                      ),
                      Text(
                        "Seat Selection",
                        style: GoogleFonts.lato(
                          textStyle: TextStyle(
                              fontSize: 15.sp, fontWeight: FontWeight.w700),
                        ),
                      ),
                      SizedBox(
                        height: 20.6.h,
                      ),
                      // ignore: sized_box_for_whitespace
                      Container(
                        height: MediaQuery.of(context).size.height * 0.24,
                        width: MediaQuery.of(context).size.width,
                        // color: Colors.lightBlue,
                        // margin: const EdgeInsets.only(
                        //     top: 34.32, left: 48.41, right: 48.41),
                        child: Stack(
                          children: [
                            Center(
                                child: SvgPicture.asset(
                                    'assets/table/tableangle.svg',
                                    height: 120.h,
                                    width: 500.w)),
                            Positioned(
                              top: 150.h,
                              left: 125.w,
                              child: InkWell(
                                child: Column(
                                  children: [
                                    RotatedBox(
                                      quarterTurns: 4,
                                      child: Image.asset(
                                        "assets/chairs/available.png",
                                        color: seats.contains(31)
                                            ? AppColors.kRed
                                            : (table == tableNo && seat == 31)
                                                ? AppColors.kOrange
                                                : AppColors.kEvergreen,
                                        height: 22.r,
                                      ),
                                    ),
                                    Text("HDG31"),
                                  ],
                                ),
                                onTap: () {
                                  setState(() {
                                    updateTable(tableNo, 31, 'HDG31');
                                  });
                                },
                              ),
                            ),
                            Positioned(
                              top: 80.h,
                              left: 60.w,
                              child: InkWell(
                                child: Column(
                                  children: [
                                    Text("HDG32"),
                                    RotatedBox(
                                      quarterTurns: 4,
                                      child: Image.asset(
                                        "assets/chairs/available.png",
                                        color: seats.contains(32)
                                            ? AppColors.kRed
                                            : (table == tableNo && seat == 32)
                                                ? AppColors.kOrange
                                                : AppColors.kEvergreen,
                                        height: 22.r,
                                      ),
                                    ),
                                  ],
                                ),
                                onTap: () {
                                  setState(() {
                                    updateTable(tableNo, 32, 'HDG32');
                                  });
                                },
                              ),
                            ),
                            Positioned(
                              top: 38.h,
                              left: 100.w,
                              child: InkWell(
                                child: Column(
                                  children: [
                                    Text("HDG33"),
                                    RotatedBox(
                                      quarterTurns: 4,
                                      child: Image.asset(
                                        "assets/chairs/available.png",
                                        color: seats.contains(33)
                                            ? AppColors.kRed
                                            : (table == tableNo && seat == 33)
                                                ? AppColors.kOrange
                                                : AppColors.kEvergreen,
                                        height: 22.r,
                                      ),
                                    ),
                                  ],
                                ),
                                onTap: () {
                                  setState(() {
                                    updateTable(tableNo, 33, 'HDG33');
                                  });
                                },
                              ),
                            ),
                            Positioned(
                              //   top: 10.h,
                              left: 138.w,
                              child: InkWell(
                                child: Column(
                                  children: [
                                    Text("HDG34"),
                                    RotatedBox(
                                      quarterTurns: 4,
                                      child: Image.asset(
                                        "assets/chairs/available.png",
                                        color: seats.contains(34)
                                            ? AppColors.kRed
                                            : (table == tableNo && seat == 34)
                                                ? AppColors.kOrange
                                                : AppColors.kEvergreen,
                                        height: 22.r,
                                      ),
                                    ),
                                  ],
                                ),
                                onTap: () {
                                  setState(() {
                                    updateTable(tableNo, 34, 'HDG34');
                                  });
                                },
                              ),
                            ),
                            Positioned(
                              top: 71.h,
                              left: 210.w,
                              child: InkWell(
                                child: Column(
                                  children: [
                                    RotatedBox(
                                      quarterTurns: 4,
                                      child: Image.asset(
                                        "assets/chairs/available.png",
                                        color: seats.contains(35)
                                            ? AppColors.kRed
                                            : (table == tableNo && seat == 35)
                                                ? AppColors.kOrange
                                                : AppColors.kEvergreen,
                                        height: 22.r,
                                      ),
                                    ),
                                    Text("HDG35"),
                                  ],
                                ),
                                onTap: () {
                                  setState(() {
                                    updateTable(tableNo, 35, 'HDG35');
                                  });
                                },
                              ),
                            ),
                            Positioned(
                              top: 110.h,
                              left: 175.w,
                              child: InkWell(
                                child: Column(
                                  children: [
                                    RotatedBox(
                                      quarterTurns: 4,
                                      child: Image.asset(
                                        "assets/chairs/available.png",
                                        color: seats.contains(36)
                                            ? AppColors.kRed
                                            : (table == tableNo && seat == 36)
                                                ? AppColors.kOrange
                                                : AppColors.kEvergreen,
                                        height: 22.r,
                                      ),
                                    ),
                                    Text("HDG36"),
                                  ],
                                ),
                                onTap: () {
                                  setState(() {
                                    updateTable(tableNo, 36, 'HDG36');
                                  });
                                },
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 10.92.h,
                      ),
                      Row(
                        children: [
                          Container(
                            height: 15.61,
                            width: 31.21,
                            margin: const EdgeInsets.only(
                              left: 53.69,
                            ),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              color: const Color(0xFFEA893B),
                            ),
                          ),
                          Container(
                            margin: const EdgeInsets.only(
                              left: 18.73,
                            ),
                            child: Text(
                              "Selected",
                              style: GoogleFonts.lato(
                                textStyle: const TextStyle(
                                    fontSize: 10, fontWeight: FontWeight.w500),
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 15.61,
                      ),

                      Row(
                        children: [
                          Container(
                            height: 15.61,
                            width: 31.21,
                            margin: const EdgeInsets.only(
                              left: 53.69,
                            ),
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                color: AppColors.kEvergreen),
                          ),
                          Container(
                            margin: const EdgeInsets.only(
                              left: 18.73,
                            ),
                            child: Text(
                              "Available",
                              style: GoogleFonts.lato(
                                textStyle: const TextStyle(
                                    fontSize: 10, fontWeight: FontWeight.w500),
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 15.61,
                      ),
                      Row(
                        children: [
                          Container(
                            height: 15.61,
                            width: 31.21,
                            margin: const EdgeInsets.only(
                              left: 53.69,
                            ),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              color: const Color(0xFFD14751),
                            ),
                          ),
                          Container(
                            margin: const EdgeInsets.only(
                              left: 18.73,
                            ),
                            child: Text(
                              "Booked",
                              style: GoogleFonts.lato(
                                textStyle: const TextStyle(
                                    fontSize: 10, fontWeight: FontWeight.w500),
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 15,
                      ),
                      Center(
                        child: ElevatedButton(
                          style: ButtonStyle(
                              backgroundColor: MaterialStateProperty.all(
                                  AppColors.kAubergine)),
                          onPressed: () {
                            _performTableBooking(data);
                          },
                          child: const Text('Book'),
                        ),
                      )
                    ],
                  ),
                ),
              ),
            );
          });
        });
  }

  showTabledetails7(
      int tableNo, List<int> seats, Map<String, dynamic> data) async {
    await callAPI();
    return showDialog(
        context: context,
        builder: (context) {
          return StatefulBuilder(
              builder: (BuildContext context, StateSetter setState) {
            return Center(
              child: Card(
                child: Container(
                  height: MediaQuery.of(context).size.height * 0.60,
                  width: MediaQuery.of(context).size.width * 0.9,
                  // margin: const EdgeInsets.only(
                  //   left: 16.09,
                  //   right: 7.09,
                  // ),
                  padding: EdgeInsets.all(20.r),
                  decoration: const BoxDecoration(
                    color: Colors.white,
                  ),
                  child: Column(
                    //     mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      SizedBox(
                        height: 10.h,
                        width: MediaQuery.of(context).size.width,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            // ignore: avoid_unnecessary_containers
                            InkWell(
                              child: Icon(
                                Icons.close_rounded,
                                size: 20.r,
                              ),
                              onTap: () {
                                Navigator.pop(context);
                              },
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 20.6.h,
                      ),
                      Text(
                        "Seat Selection",
                        style: GoogleFonts.lato(
                          textStyle: TextStyle(
                              fontSize: 15.sp, fontWeight: FontWeight.w700),
                        ),
                      ),
                      SizedBox(
                        height: 20.6.h,
                      ),
                      // ignore: sized_box_for_whitespace
                      Container(
                        height: MediaQuery.of(context).size.height * 0.24,
                        width: MediaQuery.of(context).size.width,
                        // color: Colors.lightBlue,
                        // margin: const EdgeInsets.only(
                        //     top: 34.32, left: 48.41, right: 48.41),
                        child: Stack(
                          children: [
                            Center(
                                child: SvgPicture.asset(
                                    'assets/table/horizontaltable.svg',
                                    height: 70.h,
                                    width: 300.w)),
                            Positioned(
                              top: 135.h,
                              left: 70.w,
                              child: InkWell(
                                child: Column(
                                  children: [
                                    RotatedBox(
                                      quarterTurns: 4,
                                      child: Image.asset(
                                        "assets/chairs/available.png",
                                        color: seats.contains(37)
                                            ? AppColors.kRed
                                            : (table == tableNo && seat == 37)
                                                ? AppColors.kOrange
                                                : AppColors.kEvergreen,
                                        height: 22.r,
                                      ),
                                    ),
                                    Text("HDS1"),
                                  ],
                                ),
                                onTap: () {
                                  setState(() {
                                    updateTable(tableNo, 37, 'HDS1');
                                  });
                                },
                              ),
                            ),
                            Positioned(
                              top: 10.h,
                              left: 70.w,
                              child: InkWell(
                                child: Column(
                                  children: [
                                    Text("HDS2"),
                                    RotatedBox(
                                      quarterTurns: 4,
                                      child: Image.asset(
                                        "assets/chairs/available.png",
                                        color: seats.contains(38)
                                            ? AppColors.kRed
                                            : (table == tableNo && seat == 38)
                                                ? AppColors.kOrange
                                                : AppColors.kEvergreen,
                                        height: 22.r,
                                      ),
                                    ),
                                  ],
                                ),
                                onTap: () {
                                  setState(() {
                                    updateTable(tableNo, 38, 'HDS2');
                                  });
                                },
                              ),
                            ),
                            Positioned(
                              top: 10.h,
                              left: 130.w,
                              child: InkWell(
                                child: Column(
                                  children: [
                                    Text("HDS3"),
                                    RotatedBox(
                                      quarterTurns: 4,
                                      child: Image.asset(
                                        "assets/chairs/available.png",
                                        color: seats.contains(39)
                                            ? AppColors.kRed
                                            : (table == tableNo && seat == 39)
                                                ? AppColors.kOrange
                                                : AppColors.kEvergreen,
                                        height: 22.r,
                                      ),
                                    ),
                                  ],
                                ),
                                onTap: () {
                                  setState(() {
                                    updateTable(tableNo, 39, 'HDS3');
                                  });
                                },
                              ),
                            ),
                            Positioned(
                              top: 10.h,
                              left: 190.w,
                              child: InkWell(
                                child: Column(
                                  children: [
                                    Text("HDS4"),
                                    RotatedBox(
                                      quarterTurns: 4,
                                      child: Image.asset(
                                        "assets/chairs/available.png",
                                        color: seats.contains(40)
                                            ? AppColors.kRed
                                            : (table == tableNo && seat == 40)
                                                ? AppColors.kOrange
                                                : AppColors.kEvergreen,
                                        height: 22.r,
                                      ),
                                    ),
                                  ],
                                ),
                                onTap: () {
                                  setState(() {
                                    updateTable(tableNo, 40, 'HDS4');
                                  });
                                },
                              ),
                            ),
                            Positioned(
                              top: 135.h,
                              left: 190.w,
                              child: InkWell(
                                child: Column(
                                  children: [
                                    RotatedBox(
                                      quarterTurns: 4,
                                      child: Image.asset(
                                        "assets/chairs/available.png",
                                        color: seats.contains(41)
                                            ? AppColors.kRed
                                            : (table == tableNo && seat == 41)
                                                ? AppColors.kOrange
                                                : AppColors.kEvergreen,
                                        height: 22.r,
                                      ),
                                    ),
                                    Text("HDS5"),
                                  ],
                                ),
                                onTap: () {
                                  setState(() {
                                    updateTable(tableNo, 41, 'HDS5');
                                  });
                                },
                              ),
                            ),
                            Positioned(
                              top: 135.h,
                              left: 130.w,
                              child: InkWell(
                                child: Column(
                                  children: [
                                    RotatedBox(
                                      quarterTurns: 4,
                                      child: Image.asset(
                                        "assets/chairs/available.png",
                                        color: seats.contains(42)
                                            ? AppColors.kRed
                                            : (table == tableNo && seat == 42)
                                                ? AppColors.kOrange
                                                : AppColors.kEvergreen,
                                        height: 22.r,
                                      ),
                                    ),
                                    Text("HDS6"),
                                  ],
                                ),
                                onTap: () {
                                  setState(() {
                                    updateTable(tableNo, 42, 'HDS6');
                                  });
                                },
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 10.92.h,
                      ),
                      Row(
                        children: [
                          Container(
                            height: 15.61,
                            width: 31.21,
                            margin: const EdgeInsets.only(
                              left: 53.69,
                            ),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              color: const Color(0xFFEA893B),
                            ),
                          ),
                          Container(
                            margin: const EdgeInsets.only(
                              left: 18.73,
                            ),
                            child: Text(
                              "Selected",
                              style: GoogleFonts.lato(
                                textStyle: const TextStyle(
                                    fontSize: 10, fontWeight: FontWeight.w500),
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 15.61,
                      ),

                      Row(
                        children: [
                          Container(
                            height: 15.61,
                            width: 31.21,
                            margin: const EdgeInsets.only(
                              left: 53.69,
                            ),
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                color: AppColors.kEvergreen),
                          ),
                          Container(
                            margin: const EdgeInsets.only(
                              left: 18.73,
                            ),
                            child: Text(
                              "Available",
                              style: GoogleFonts.lato(
                                textStyle: const TextStyle(
                                    fontSize: 10, fontWeight: FontWeight.w500),
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 15.61,
                      ),
                      Row(
                        children: [
                          Container(
                            height: 15.61,
                            width: 31.21,
                            margin: const EdgeInsets.only(
                              left: 53.69,
                            ),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              color: const Color(0xFFD14751),
                            ),
                          ),
                          Container(
                            margin: const EdgeInsets.only(
                              left: 18.73,
                            ),
                            child: Text(
                              "Booked",
                              style: GoogleFonts.lato(
                                textStyle: const TextStyle(
                                    fontSize: 10, fontWeight: FontWeight.w500),
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 15,
                      ),
                      Center(
                        child: ElevatedButton(
                          style: ButtonStyle(
                              backgroundColor: MaterialStateProperty.all(
                                  AppColors.kAubergine)),
                          onPressed: () {
                            _performTableBooking(data);
                          },
                          child: const Text('Book'),
                        ),
                      )
                    ],
                  ),
                ),
              ),
            );
          });
        });
  }

  showTabledetails8(
      int tableNo, List<int> seats, Map<String, dynamic> data) async {
    await callAPI();
    return showDialog(
        context: context,
        builder: (context) {
          return StatefulBuilder(
              builder: (BuildContext context, StateSetter setState) {
            return Center(
              child: Card(
                child: Container(
                  height: MediaQuery.of(context).size.height * 0.60,
                  width: MediaQuery.of(context).size.width * 0.9,
                  // margin: const EdgeInsets.only(
                  //   left: 16.09,
                  //   right: 7.09,
                  // ),
                  padding: EdgeInsets.all(20.r),
                  decoration: const BoxDecoration(
                    color: Colors.white,
                  ),
                  child: Column(
                    //     mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      SizedBox(
                        height: 10.h,
                        width: MediaQuery.of(context).size.width,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            // ignore: avoid_unnecessary_containers
                            InkWell(
                              child: Icon(
                                Icons.close_rounded,
                                size: 20.r,
                              ),
                              onTap: () {
                                Navigator.pop(context);
                              },
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 20.6.h,
                      ),
                      Text(
                        "Seat Selection",
                        style: GoogleFonts.lato(
                          textStyle: TextStyle(
                              fontSize: 15.sp, fontWeight: FontWeight.w700),
                        ),
                      ),
                      SizedBox(
                        height: 20.6.h,
                      ),
                      // ignore: sized_box_for_whitespace
                      Container(
                        height: MediaQuery.of(context).size.height * 0.24,
                        width: MediaQuery.of(context).size.width,
                        // color: Colors.lightBlue,
                        // margin: const EdgeInsets.only(
                        //     top: 34.32, left: 48.41, right: 48.41),
                        child: Stack(
                          children: [
                            Center(
                                child: SvgPicture.asset(
                                    'assets/table/horizontaltable.svg',
                                    height: 70.h,
                                    width: 300.w)),
                            Positioned(
                              top: 135.h,
                              left: 70.w,
                              child: InkWell(
                                child: Column(
                                  children: [
                                    RotatedBox(
                                      quarterTurns: 4,
                                      child: Image.asset(
                                        "assets/chairs/available.png",
                                        color: seats.contains(43)
                                            ? AppColors.kRed
                                            : (table == tableNo && seat == 43)
                                                ? AppColors.kOrange
                                                : AppColors.kEvergreen,
                                        height: 22.r,
                                      ),
                                    ),
                                    Text("HDS7"),
                                  ],
                                ),
                                onTap: () {
                                  setState(() {
                                    updateTable(tableNo, 43, 'HDS7');
                                  });
                                },
                              ),
                            ),
                            Positioned(
                              top: 10.h,
                              left: 70.w,
                              child: InkWell(
                                child: Column(
                                  children: [
                                    Text("HDS8"),
                                    RotatedBox(
                                      quarterTurns: 4,
                                      child: Image.asset(
                                        "assets/chairs/available.png",
                                        color: seats.contains(44)
                                            ? AppColors.kRed
                                            : (table == tableNo && seat == 44)
                                                ? AppColors.kOrange
                                                : AppColors.kEvergreen,
                                        height: 22.r,
                                      ),
                                    ),
                                  ],
                                ),
                                onTap: () {
                                  setState(() {
                                    updateTable(tableNo, 44, 'HDS8');
                                  });
                                },
                              ),
                            ),
                            Positioned(
                              top: 10.h,
                              left: 130.w,
                              child: InkWell(
                                child: Column(
                                  children: [
                                    Text("HDS9"),
                                    RotatedBox(
                                      quarterTurns: 4,
                                      child: Image.asset(
                                        "assets/chairs/available.png",
                                        color: seats.contains(45)
                                            ? AppColors.kRed
                                            : (table == tableNo && seat == 45)
                                                ? AppColors.kOrange
                                                : AppColors.kEvergreen,
                                        height: 22.r,
                                      ),
                                    ),
                                  ],
                                ),
                                onTap: () {
                                  setState(() {
                                    updateTable(tableNo, 45, 'HDS9');
                                  });
                                },
                              ),
                            ),
                            Positioned(
                              top: 10.h,
                              left: 190.w,
                              child: InkWell(
                                child: Column(
                                  children: [
                                    Text("HDS10"),
                                    RotatedBox(
                                      quarterTurns: 4,
                                      child: Image.asset(
                                        "assets/chairs/available.png",
                                        color: seats.contains(46)
                                            ? AppColors.kRed
                                            : (table == tableNo && seat == 46)
                                                ? AppColors.kOrange
                                                : AppColors.kEvergreen,
                                        height: 22.r,
                                      ),
                                    ),
                                  ],
                                ),
                                onTap: () {
                                  setState(() {
                                    updateTable(tableNo, 46, 'HDS10');
                                  });
                                },
                              ),
                            ),
                            Positioned(
                              top: 135.h,
                              left: 190.w,
                              child: InkWell(
                                child: Column(
                                  children: [
                                    RotatedBox(
                                      quarterTurns: 4,
                                      child: Image.asset(
                                        "assets/chairs/available.png",
                                        color: seats.contains(47)
                                            ? AppColors.kRed
                                            : (table == tableNo && seat == 47)
                                                ? AppColors.kOrange
                                                : AppColors.kEvergreen,
                                        height: 22.r,
                                      ),
                                    ),
                                    Text("HDS11"),
                                  ],
                                ),
                                onTap: () {
                                  setState(() {
                                    updateTable(tableNo, 47, 'HDS11');
                                  });
                                },
                              ),
                            ),
                            Positioned(
                              top: 135.h,
                              left: 130.w,
                              child: InkWell(
                                child: Column(
                                  children: [
                                    RotatedBox(
                                      quarterTurns: 4,
                                      child: Image.asset(
                                        "assets/chairs/available.png",
                                        color: seats.contains(48)
                                            ? AppColors.kRed
                                            : (table == tableNo && seat == 48)
                                                ? AppColors.kOrange
                                                : AppColors.kEvergreen,
                                        height: 22.r,
                                      ),
                                    ),
                                    Text("HDS12"),
                                  ],
                                ),
                                onTap: () {
                                  setState(() {
                                    updateTable(tableNo, 48, 'HDS12');
                                  });
                                },
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 10.92.h,
                      ),
                      Row(
                        children: [
                          Container(
                            height: 15.61,
                            width: 31.21,
                            margin: const EdgeInsets.only(
                              left: 53.69,
                            ),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              color: const Color(0xFFEA893B),
                            ),
                          ),
                          Container(
                            margin: const EdgeInsets.only(
                              left: 18.73,
                            ),
                            child: Text(
                              "Selected",
                              style: GoogleFonts.lato(
                                textStyle: const TextStyle(
                                    fontSize: 10, fontWeight: FontWeight.w500),
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 15.61,
                      ),

                      Row(
                        children: [
                          Container(
                            height: 15.61,
                            width: 31.21,
                            margin: const EdgeInsets.only(
                              left: 53.69,
                            ),
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                color: AppColors.kEvergreen),
                          ),
                          Container(
                            margin: const EdgeInsets.only(
                              left: 18.73,
                            ),
                            child: Text(
                              "Available",
                              style: GoogleFonts.lato(
                                textStyle: const TextStyle(
                                    fontSize: 10, fontWeight: FontWeight.w500),
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 15.61,
                      ),
                      Row(
                        children: [
                          Container(
                            height: 15.61,
                            width: 31.21,
                            margin: const EdgeInsets.only(
                              left: 53.69,
                            ),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              color: const Color(0xFFD14751),
                            ),
                          ),
                          Container(
                            margin: const EdgeInsets.only(
                              left: 18.73,
                            ),
                            child: Text(
                              "Booked",
                              style: GoogleFonts.lato(
                                textStyle: const TextStyle(
                                    fontSize: 10, fontWeight: FontWeight.w500),
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 15,
                      ),
                      Center(
                        child: ElevatedButton(
                          style: ButtonStyle(
                              backgroundColor: MaterialStateProperty.all(
                                  AppColors.kAubergine)),
                          onPressed: () {
                            _performTableBooking(data);
                          },
                          child: const Text('Book'),
                        ),
                      )
                    ],
                  ),
                ),
              ),
            );
          });
        });
  }

  showTabledetails9(
      int tableNo, List<int> seats, Map<String, dynamic> data) async {
    await callAPI();
    return showDialog(
        context: context,
        builder: (context) {
          return StatefulBuilder(
              builder: (BuildContext context, StateSetter setState) {
            return Center(
              child: Card(
                child: Container(
                  height: MediaQuery.of(context).size.height * 0.57,
                  width: MediaQuery.of(context).size.width * 0.9,
                  // margin: const EdgeInsets.only(
                  //   left: 16.09,
                  //   right: 7.09,
                  // ),
                  padding: EdgeInsets.all(20.r),
                  decoration: const BoxDecoration(
                    color: Colors.white,
                  ),
                  child: Column(
                    //     mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      SizedBox(
                        height: 10.h,
                        width: MediaQuery.of(context).size.width,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            // ignore: avoid_unnecessary_containers
                            InkWell(
                              child: Icon(
                                Icons.close_rounded,
                                size: 20.r,
                              ),
                              onTap: () {
                                Navigator.pop(context);
                              },
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 20.6.h,
                      ),
                      Text(
                        "Seat Selection",
                        style: GoogleFonts.lato(
                          textStyle: TextStyle(
                              fontSize: 15.sp, fontWeight: FontWeight.w700),
                        ),
                      ),
                      SizedBox(
                        height: 20.6.h,
                      ),
                      // ignore: sized_box_for_whitespace
                      Container(
                        height: MediaQuery.of(context).size.height * 0.17,
                        width: MediaQuery.of(context).size.width,
                        // color: Colors.lightBlue,
                        // margin: const EdgeInsets.only(
                        //     top: 34.32, left: 48.41, right: 48.41),
                        child: Stack(
                          children: [
                            Center(
                                child: RotatedBox(
                              quarterTurns: 0,
                              child: SvgPicture.asset(
                                  'assets/table/rightangletable.svg',
                                  height: 120.h,
                                  width: 700.w),
                            )),

                            Positioned(
                              top: 94.h,
                              left: 190.w,
                              child: InkWell(
                                child: Column(
                                  children: [
                                    RotatedBox(
                                      quarterTurns: 4,
                                      child: Image.asset(
                                        "assets/chairs/available.png",
                                        color: seats.contains(49)
                                            ? AppColors.kRed
                                            : (table == tableNo && seat == 49)
                                                ? AppColors.kOrange
                                                : AppColors.kEvergreen,
                                        height: 22.r,
                                      ),
                                    ),
                                    Text("HDS13"),
                                  ],
                                ),
                                onTap: () {
                                  setState(() {
                                    updateTable(tableNo, 49, 'HDS13');
                                  });
                                },
                              ),
                            ),

                            Positioned(
                              top: 94.h,
                              left: 80.w,
                              child: InkWell(
                                child: Column(
                                  children: [
                                    Text("HDS14"),
                                    RotatedBox(
                                      quarterTurns: 4,
                                      child: Image.asset(
                                        "assets/chairs/available.png",
                                        color: seats.contains(50)
                                            ? AppColors.kRed
                                            : (table == tableNo && seat == 50)
                                                ? AppColors.kOrange
                                                : AppColors.kEvergreen,
                                        height: 22.r,
                                      ),
                                    ),
                                  ],
                                ),
                                onTap: () {
                                  setState(() {
                                    updateTable(tableNo, 50, 'HDS14');
                                  });
                                },
                              ),
                            ),

                            Positioned(
                              top: 50.h,
                              left: 80.w,
                              child: InkWell(
                                child: Column(
                                  children: [
                                    Text("HDS15"),
                                    RotatedBox(
                                      quarterTurns: 4,
                                      child: Image.asset(
                                        "assets/chairs/available.png",
                                        color: seats.contains(51)
                                            ? AppColors.kRed
                                            : (table == tableNo && seat == 51)
                                                ? AppColors.kOrange
                                                : AppColors.kEvergreen,
                                        height: 22.r,
                                      ),
                                    ),
                                  ],
                                ),
                                onTap: () {
                                  setState(() {
                                    updateTable(tableNo, 51, 'HDS15');
                                  });
                                },
                              ),
                            ),

                            Positioned(
                              top: 10.h,
                              left: 80.w,
                              child: InkWell(
                                child: Column(
                                  children: [
                                    Text("HDS16"),
                                    RotatedBox(
                                      quarterTurns: 4,
                                      child: Image.asset(
                                        "assets/chairs/available.png",
                                        color: seats.contains(52)
                                            ? AppColors.kRed
                                            : (table == tableNo && seat == 52)
                                                ? AppColors.kOrange
                                                : AppColors.kEvergreen,
                                        height: 22.r,
                                      ),
                                    ),
                                  ],
                                ),
                                onTap: () {
                                  setState(() {
                                    updateTable(tableNo, 52, 'HDS16');
                                  });
                                },
                              ),
                            ),

                            //
                            //
                            // Positioned(
                            //   top: 60.h,
                            //   right: 35.w,
                            //   child: InkWell(
                            //     child:
                            //     Row(
                            //       children: [

                            //         RotatedBox(

                            //           quarterTurns: 1,
                            //           child: Image.asset(

                            //             "assets/chairs/available.png", color: seats.contains(6)
                            //               ? AppColors.kRed
                            //               : (table == tableNo && seat == 6)
                            //               ? AppColors.kOrange
                            //               : AppColors.kEvergreen,
                            //             height: 22.r,),
                            //         ),
                            //         Text('6'),
                            //       ],
                            //     ),
                            //   ),
                            // ),

                            Positioned(
                              top: 10.h,
                              left: 190.w,
                              child: InkWell(
                                child: Column(
                                  children: [
                                    RotatedBox(
                                      quarterTurns: 4,
                                      child: Image.asset(
                                        "assets/chairs/available.png",
                                        color: seats.contains(53)
                                            ? AppColors.kRed
                                            : (table == tableNo && seat == 53)
                                                ? AppColors.kOrange
                                                : AppColors.kEvergreen,
                                        height: 22.r,
                                      ),
                                    ),
                                    Text("HDS17"),
                                  ],
                                ),
                                onTap: () {
                                  setState(() {
                                    updateTable(tableNo, 53, 'HDS17');
                                  });
                                },
                              ),
                            ),
                            Positioned(
                              top: 50.h,
                              left: 190.w,
                              child: InkWell(
                                child: Column(
                                  children: [
                                    RotatedBox(
                                      quarterTurns: 4,
                                      child: Image.asset(
                                        "assets/chairs/available.png",
                                        color: seats.contains(54)
                                            ? AppColors.kRed
                                            : (table == tableNo && seat == 54)
                                                ? AppColors.kOrange
                                                : AppColors.kEvergreen,
                                        height: 22.r,
                                      ),
                                    ),
                                    Text("HDS18"),
                                  ],
                                ),
                                onTap: () {
                                  setState(() {
                                    updateTable(tableNo, 54, 'HDS18');
                                  });
                                },
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 10.92.h,
                      ),
                      Row(
                        children: [
                          Container(
                            height: 15.61,
                            width: 31.21,
                            margin: const EdgeInsets.only(
                              left: 53.69,
                            ),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              color: const Color(0xFFEA893B),
                            ),
                          ),
                          Container(
                            margin: const EdgeInsets.only(
                              left: 18.73,
                            ),
                            child: Text(
                              "Selected",
                              style: GoogleFonts.lato(
                                textStyle: const TextStyle(
                                    fontSize: 10, fontWeight: FontWeight.w500),
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 15.61,
                      ),

                      Row(
                        children: [
                          Container(
                            height: 15.61,
                            width: 31.21,
                            margin: const EdgeInsets.only(
                              left: 53.69,
                            ),
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                color: AppColors.kEvergreen),
                          ),
                          Container(
                            margin: const EdgeInsets.only(
                              left: 18.73,
                            ),
                            child: Text(
                              "Available",
                              style: GoogleFonts.lato(
                                textStyle: const TextStyle(
                                    fontSize: 10, fontWeight: FontWeight.w500),
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 15.61,
                      ),
                      Row(
                        children: [
                          Container(
                            height: 15.61,
                            width: 31.21,
                            margin: const EdgeInsets.only(
                              left: 53.69,
                            ),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              color: const Color(0xFFD14751),
                            ),
                          ),
                          Container(
                            margin: const EdgeInsets.only(
                              left: 18.73,
                            ),
                            child: Text(
                              "Booked",
                              style: GoogleFonts.lato(
                                textStyle: const TextStyle(
                                    fontSize: 10, fontWeight: FontWeight.w500),
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 15,
                      ),
                      Center(
                        child: ElevatedButton(
                          style: ButtonStyle(
                              backgroundColor: MaterialStateProperty.all(
                                  AppColors.kAubergine)),
                          onPressed: () {
                            _performTableBooking(data);
                          },
                          child: const Text('Book'),
                        ),
                      )
                    ],
                  ),
                ),
              ),
            );
          });
        });
  }

  showTabledetails10(
      int tableNo, List<int> seats, Map<String, dynamic> data) async {
    await callAPI();
    return showDialog(
        context: context,
        builder: (context) {
          return StatefulBuilder(
              builder: (BuildContext context, StateSetter setState) {
            return Center(
              child: Card(
                child: Container(
                  height: MediaQuery.of(context).size.height * 0.60,
                  width: MediaQuery.of(context).size.width * 0.9,
                  // margin: const EdgeInsets.only(
                  //   left: 16.09,
                  //   right: 7.09,
                  // ),
                  padding: EdgeInsets.all(20.r),
                  decoration: const BoxDecoration(
                    color: Colors.white,
                  ),
                  child: Column(
                    //     mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      SizedBox(
                        height: 10.h,
                        width: MediaQuery.of(context).size.width,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            // ignore: avoid_unnecessary_containers
                            InkWell(
                              child: Icon(
                                Icons.close_rounded,
                                size: 20.r,
                              ),
                              onTap: () {
                                Navigator.pop(context);
                              },
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 20.6.h,
                      ),
                      Text(
                        "Seat Selection",
                        style: GoogleFonts.lato(
                          textStyle: TextStyle(
                              fontSize: 15.sp, fontWeight: FontWeight.w700),
                        ),
                      ),
                      SizedBox(
                        height: 20.6.h,
                      ),
                      // ignore: sized_box_for_whitespace
                      Container(
                        height: MediaQuery.of(context).size.height * 0.24,
                        width: MediaQuery.of(context).size.width,
                        // color: Colors.lightBlue,
                        // margin: const EdgeInsets.only(
                        //     top: 34.32, left: 48.41, right: 48.41),
                        child: Stack(
                          children: [
                            Center(
                                child: SvgPicture.asset(
                                    'assets/table/horizontaltable.svg',
                                    height: 70.h,
                                    width: 300.w)),
                            Positioned(
                              top: 135.h,
                              left: 70.w,
                              child: InkWell(
                                child: Column(
                                  children: [
                                    RotatedBox(
                                      quarterTurns: 4,
                                      child: Image.asset(
                                        "assets/chairs/available.png",
                                        color: seats.contains(55)
                                            ? AppColors.kRed
                                            : (table == tableNo && seat == 55)
                                                ? AppColors.kOrange
                                                : AppColors.kEvergreen,
                                        height: 22.r,
                                      ),
                                    ),
                                    Text("HDS19"),
                                  ],
                                ),
                                onTap: () {
                                  setState(() {
                                    updateTable(tableNo, 55, 'HDS19');
                                  });
                                },
                              ),
                            ),
                            Positioned(
                              top: 10.h,
                              left: 70.w,
                              child: InkWell(
                                child: Column(
                                  children: [
                                    Text("HDS20"),
                                    RotatedBox(
                                      quarterTurns: 4,
                                      child: Image.asset(
                                        "assets/chairs/available.png",
                                        color: seats.contains(56)
                                            ? AppColors.kRed
                                            : (table == tableNo && seat == 56)
                                                ? AppColors.kOrange
                                                : AppColors.kEvergreen,
                                        height: 22.r,
                                      ),
                                    ),
                                  ],
                                ),
                                onTap: () {
                                  setState(() {
                                    updateTable(tableNo, 56, 'HDS20');
                                  });
                                },
                              ),
                            ),
                            Positioned(
                              top: 10.h,
                              left: 130.w,
                              child: InkWell(
                                child: Column(
                                  children: [
                                    Text("HDS21"),
                                    RotatedBox(
                                      quarterTurns: 4,
                                      child: Image.asset(
                                        "assets/chairs/available.png",
                                        color: seats.contains(57)
                                            ? AppColors.kRed
                                            : (table == tableNo && seat == 57)
                                                ? AppColors.kOrange
                                                : AppColors.kEvergreen,
                                        height: 22.r,
                                      ),
                                    ),
                                  ],
                                ),
                                onTap: () {
                                  setState(() {
                                    updateTable(tableNo, 57, 'HDS21');
                                  });
                                },
                              ),
                            ),
                            Positioned(
                              top: 10.h,
                              left: 190.w,
                              child: InkWell(
                                child: Column(
                                  children: [
                                    Text("HDS22"),
                                    RotatedBox(
                                      quarterTurns: 4,
                                      child: Image.asset(
                                        "assets/chairs/available.png",
                                        color: seats.contains(58)
                                            ? AppColors.kRed
                                            : (table == tableNo && seat == 58)
                                                ? AppColors.kOrange
                                                : AppColors.kEvergreen,
                                        height: 22.r,
                                      ),
                                    ),
                                  ],
                                ),
                                onTap: () {
                                  setState(() {
                                    updateTable(tableNo, 58, 'HDS22');
                                  });
                                },
                              ),
                            ),
                            Positioned(
                              top: 135.h,
                              left: 190.w,
                              child: InkWell(
                                child: Column(
                                  children: [
                                    RotatedBox(
                                      quarterTurns: 4,
                                      child: Image.asset(
                                        "assets/chairs/available.png",
                                        color: seats.contains(59)
                                            ? AppColors.kRed
                                            : (table == tableNo && seat == 59)
                                                ? AppColors.kOrange
                                                : AppColors.kEvergreen,
                                        height: 22.r,
                                      ),
                                    ),
                                    Text("HDS23"),
                                  ],
                                ),
                                onTap: () {
                                  setState(() {
                                    updateTable(tableNo, 59, 'HDS23');
                                  });
                                },
                              ),
                            ),
                            Positioned(
                              top: 135.h,
                              left: 130.w,
                              child: InkWell(
                                child: Column(
                                  children: [
                                    RotatedBox(
                                      quarterTurns: 4,
                                      child: Image.asset(
                                        "assets/chairs/available.png",
                                        color: seats.contains(60)
                                            ? AppColors.kRed
                                            : (table == tableNo && seat == 60)
                                                ? AppColors.kOrange
                                                : AppColors.kEvergreen,
                                        height: 22.r,
                                      ),
                                    ),
                                    Text("HDS24"),
                                  ],
                                ),
                                onTap: () {
                                  setState(() {
                                    updateTable(tableNo, 60, 'HDS24');
                                  });
                                },
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 10.92.h,
                      ),
                      Row(
                        children: [
                          Container(
                            height: 15.61,
                            width: 31.21,
                            margin: const EdgeInsets.only(
                              left: 53.69,
                            ),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              color: const Color(0xFFEA893B),
                            ),
                          ),
                          Container(
                            margin: const EdgeInsets.only(
                              left: 18.73,
                            ),
                            child: Text(
                              "Selected",
                              style: GoogleFonts.lato(
                                textStyle: const TextStyle(
                                    fontSize: 10, fontWeight: FontWeight.w500),
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 15.61,
                      ),

                      Row(
                        children: [
                          Container(
                            height: 15.61,
                            width: 31.21,
                            margin: const EdgeInsets.only(
                              left: 53.69,
                            ),
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                color: AppColors.kEvergreen),
                          ),
                          Container(
                            margin: const EdgeInsets.only(
                              left: 18.73,
                            ),
                            child: Text(
                              "Available",
                              style: GoogleFonts.lato(
                                textStyle: const TextStyle(
                                    fontSize: 10, fontWeight: FontWeight.w500),
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 15.61,
                      ),
                      Row(
                        children: [
                          Container(
                            height: 15.61,
                            width: 31.21,
                            margin: const EdgeInsets.only(
                              left: 53.69,
                            ),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              color: const Color(0xFFD14751),
                            ),
                          ),
                          Container(
                            margin: const EdgeInsets.only(
                              left: 18.73,
                            ),
                            child: Text(
                              "Booked",
                              style: GoogleFonts.lato(
                                textStyle: const TextStyle(
                                    fontSize: 10, fontWeight: FontWeight.w500),
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 15,
                      ),
                      Center(
                        child: ElevatedButton(
                          style: ButtonStyle(
                              backgroundColor: MaterialStateProperty.all(
                                  AppColors.kAubergine)),
                          onPressed: () {
                            _performTableBooking(data);
                          },
                          child: const Text('Book'),
                        ),
                      )
                    ],
                  ),
                ),
              ),
            );
          });
        });
  }

  showTabledetails11(
      int tableNo, List<int> seats, Map<String, dynamic> data) async {
    await callAPI();
    return showDialog(
        context: context,
        builder: (context) {
          return StatefulBuilder(
              builder: (BuildContext context, StateSetter setState) {
            return Center(
              child: Card(
                child: Container(
                  height: MediaQuery.of(context).size.height * 0.57,
                  width: MediaQuery.of(context).size.width * 0.9,
                  // margin: const EdgeInsets.only(
                  //   left: 16.09,
                  //   right: 7.09,
                  // ),
                  padding: EdgeInsets.all(20.r),
                  decoration: const BoxDecoration(
                    color: Colors.white,
                  ),
                  child: Column(
                    //     mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      SizedBox(
                        height: 10.h,
                        width: MediaQuery.of(context).size.width,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            // ignore: avoid_unnecessary_containers
                            InkWell(
                              child: Icon(
                                Icons.close_rounded,
                                size: 20.r,
                              ),
                              onTap: () {
                                Navigator.pop(context);
                              },
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 20.6.h,
                      ),
                      Text(
                        "Seat Selection",
                        style: GoogleFonts.lato(
                          textStyle: TextStyle(
                              fontSize: 15.sp, fontWeight: FontWeight.w700),
                        ),
                      ),
                      SizedBox(
                        height: 20.6.h,
                      ),
                      // ignore: sized_box_for_whitespace
                      Container(
                        height: MediaQuery.of(context).size.height * 0.17,
                        width: MediaQuery.of(context).size.width,
                        // color: Colors.lightBlue,
                        // margin: const EdgeInsets.only(
                        //     top: 34.32, left: 48.41, right: 48.41),
                        child: Stack(
                          children: [
                            Center(
                                child: RotatedBox(
                              quarterTurns: 0,
                              child: SvgPicture.asset(
                                  'assets/table/rightangletable.svg',
                                  height: 120.h,
                                  width: 700.w),
                            )),

                            Positioned(
                              top: 74.h,
                              left: 190.w,
                              child: InkWell(
                                child: Column(
                                  children: [
                                    RotatedBox(
                                      quarterTurns: 4,
                                      child: Image.asset(
                                        "assets/chairs/available.png",
                                        color: seats.contains(61)
                                            ? AppColors.kRed
                                            : (table == tableNo && seat == 61)
                                                ? AppColors.kOrange
                                                : AppColors.kEvergreen,
                                        height: 22.r,
                                      ),
                                    ),
                                    Text("HDC1"),
                                  ],
                                ),
                                onTap: () {
                                  setState(() {
                                    updateTable(tableNo, 61, 'HDC1');
                                  });
                                },
                              ),
                            ),

                            Positioned(
                              top: 74.h,
                              left: 80.w,
                              child: InkWell(
                                child: Column(
                                  children: [
                                    RotatedBox(
                                      quarterTurns: 4,
                                      child: Image.asset(
                                        "assets/chairs/available.png",
                                        color: seats.contains(62)
                                            ? AppColors.kRed
                                            : (table == tableNo && seat == 62)
                                                ? AppColors.kOrange
                                                : AppColors.kEvergreen,
                                        height: 22.r,
                                      ),
                                    ),
                                    Text("HDC2"),
                                  ],
                                ),
                                onTap: () {
                                  setState(() {
                                    updateTable(tableNo, 62, 'HDC2');
                                  });
                                },
                              ),
                            ),

                            // Positioned(
                            //   top: 50.h,
                            //   left: 80.w,
                            //   child: InkWell(
                            //     child: Column(
                            //       children: [
                            //         Text("HDC3"),
                            //         RotatedBox(
                            //           quarterTurns: 4,
                            //           child: Image.asset(
                            //             "assets/chairs/available.png",
                            //             color: seats.contains(63)
                            //                 ? AppColors.kRed
                            //                 : (table == tableNo && seat == 63)
                            //                     ? AppColors.kOrange
                            //                     : AppColors.kEvergreen,
                            //             height: 22.r,
                            //           ),
                            //         ),
                            //       ],
                            //     ),
                            //     onTap: () {
                            //       setState(() {
                            //         updateTable(tableNo, 63);
                            //       });
                            //     },
                            //   ),
                            // ),

                            Positioned(
                              top: 20.h,
                              left: 80.w,
                              child: InkWell(
                                child: Column(
                                  children: [
                                    RotatedBox(
                                      quarterTurns: 4,
                                      child: Image.asset(
                                        "assets/chairs/available.png",
                                        color: seats.contains(63)
                                            ? AppColors.kRed
                                            : (table == tableNo && seat == 63)
                                                ? AppColors.kOrange
                                                : AppColors.kEvergreen,
                                        height: 22.r,
                                      ),
                                    ),
                                    Text("HDC3"),
                                  ],
                                ),
                                onTap: () {
                                  setState(() {
                                    updateTable(tableNo, 63, 'HDC3');
                                  });
                                },
                              ),
                            ),

                            Positioned(
                              top: 20.h,
                              left: 190.w,
                              child: InkWell(
                                child: Column(
                                  children: [
                                    RotatedBox(
                                      quarterTurns: 4,
                                      child: Image.asset(
                                        "assets/chairs/available.png",
                                        color: seats.contains(64)
                                            ? AppColors.kRed
                                            : (table == tableNo && seat == 64)
                                                ? AppColors.kOrange
                                                : AppColors.kEvergreen,
                                        height: 22.r,
                                      ),
                                    ),
                                    Text("HDC4"),
                                  ],
                                ),
                                onTap: () {
                                  setState(() {
                                    updateTable(tableNo, 64, 'HDC4');
                                  });
                                },
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 10.92.h,
                      ),
                      Row(
                        children: [
                          Container(
                            height: 15.61,
                            width: 31.21,
                            margin: const EdgeInsets.only(
                              left: 53.69,
                            ),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              color: const Color(0xFFEA893B),
                            ),
                          ),
                          Container(
                            margin: const EdgeInsets.only(
                              left: 18.73,
                            ),
                            child: Text(
                              "Selected",
                              style: GoogleFonts.lato(
                                textStyle: const TextStyle(
                                    fontSize: 10, fontWeight: FontWeight.w500),
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 15.61,
                      ),

                      Row(
                        children: [
                          Container(
                            height: 15.61,
                            width: 31.21,
                            margin: const EdgeInsets.only(
                              left: 53.69,
                            ),
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                color: AppColors.kEvergreen),
                          ),
                          Container(
                            margin: const EdgeInsets.only(
                              left: 18.73,
                            ),
                            child: Text(
                              "Available",
                              style: GoogleFonts.lato(
                                textStyle: const TextStyle(
                                    fontSize: 10, fontWeight: FontWeight.w500),
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 15.61,
                      ),
                      Row(
                        children: [
                          Container(
                            height: 15.61,
                            width: 31.21,
                            margin: const EdgeInsets.only(
                              left: 53.69,
                            ),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              color: const Color(0xFFD14751),
                            ),
                          ),
                          Container(
                            margin: const EdgeInsets.only(
                              left: 18.73,
                            ),
                            child: Text(
                              "Booked",
                              style: GoogleFonts.lato(
                                textStyle: const TextStyle(
                                    fontSize: 10, fontWeight: FontWeight.w500),
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 15,
                      ),
                      Center(
                        child: ElevatedButton(
                          style: ButtonStyle(
                              backgroundColor: MaterialStateProperty.all(
                                  AppColors.kAubergine)),
                          onPressed: () {
                            _performTableBooking(data);
                          },
                          child: const Text('Book'),
                        ),
                      )
                    ],
                  ),
                ),
              ),
            );
          });
        });
  }

  showTabledetails12(
      int tableNo, List<int> seats, Map<String, dynamic> data) async {
    await callAPI();
    return showDialog(
        context: context,
        builder: (context) {
          return StatefulBuilder(
              builder: (BuildContext context, StateSetter setState) {
            return Center(
              child: Card(
                child: Container(
                  height: MediaQuery.of(context).size.height * 0.57,
                  width: MediaQuery.of(context).size.width * 0.9,
                  // margin: const EdgeInsets.only(
                  //   left: 16.09,
                  //   right: 7.09,
                  // ),
                  padding: EdgeInsets.all(20.r),
                  decoration: const BoxDecoration(
                    color: Colors.white,
                  ),
                  child: Column(
                    //     mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      SizedBox(
                        height: 10.h,
                        width: MediaQuery.of(context).size.width,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            // ignore: avoid_unnecessary_containers
                            InkWell(
                              child: Icon(
                                Icons.close_rounded,
                                size: 20.r,
                              ),
                              onTap: () {
                                Navigator.pop(context);
                              },
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 20.6.h,
                      ),
                      Text(
                        "Seat Selection",
                        style: GoogleFonts.lato(
                          textStyle: TextStyle(
                              fontSize: 15.sp, fontWeight: FontWeight.w700),
                        ),
                      ),
                      SizedBox(
                        height: 20.6.h,
                      ),
                      // ignore: sized_box_for_whitespace
                      Container(
                        height: MediaQuery.of(context).size.height * 0.17,
                        width: MediaQuery.of(context).size.width,
                        // color: Colors.lightBlue,
                        // margin: const EdgeInsets.only(
                        //     top: 34.32, left: 48.41, right: 48.41),
                        child: Stack(
                          children: [
                            Center(
                                child: RotatedBox(
                              quarterTurns: 0,
                              child: SvgPicture.asset(
                                  'assets/table/rightangletable.svg',
                                  height: 120.h,
                                  width: 700.w),
                            )),

                            Positioned(
                              top: 74.h,
                              left: 190.w,
                              child: InkWell(
                                child: Column(
                                  children: [
                                    RotatedBox(
                                      quarterTurns: 4,
                                      child: Image.asset(
                                        "assets/chairs/available.png",
                                        color: seats.contains(65)
                                            ? AppColors.kRed
                                            : (table == tableNo && seat == 65)
                                                ? AppColors.kOrange
                                                : AppColors.kEvergreen,
                                        height: 22.r,
                                      ),
                                    ),
                                    Text("HDC5"),
                                  ],
                                ),
                                onTap: () {
                                  setState(() {
                                    updateTable(tableNo, 65, 'HDC5');
                                  });
                                },
                              ),
                            ),

                            Positioned(
                              top: 74.h,
                              left: 80.w,
                              child: InkWell(
                                child: Column(
                                  children: [
                                    RotatedBox(
                                      quarterTurns: 4,
                                      child: Image.asset(
                                        "assets/chairs/available.png",
                                        color: seats.contains(66)
                                            ? AppColors.kRed
                                            : (table == tableNo && seat == 66)
                                                ? AppColors.kOrange
                                                : AppColors.kEvergreen,
                                        height: 22.r,
                                      ),
                                    ),
                                    Text("HDC6"),
                                  ],
                                ),
                                onTap: () {
                                  setState(() {
                                    updateTable(tableNo, 66, 'HDC6');
                                  });
                                },
                              ),
                            ),

                            // Positioned(
                            //   top: 50.h,
                            //   left: 80.w,
                            //   child: InkWell(
                            //     child: Column(
                            //       children: [
                            //         Text("HDC3"),
                            //         RotatedBox(
                            //           quarterTurns: 4,
                            //           child: Image.asset(
                            //             "assets/chairs/available.png",
                            //             color: seats.contains(63)
                            //                 ? AppColors.kRed
                            //                 : (table == tableNo && seat == 63)
                            //                     ? AppColors.kOrange
                            //                     : AppColors.kEvergreen,
                            //             height: 22.r,
                            //           ),
                            //         ),
                            //       ],
                            //     ),
                            //     onTap: () {
                            //       setState(() {
                            //         updateTable(tableNo, 63);
                            //       });
                            //     },
                            //   ),
                            // ),

                            Positioned(
                              top: 20.h,
                              left: 80.w,
                              child: InkWell(
                                child: Column(
                                  children: [
                                    RotatedBox(
                                      quarterTurns: 4,
                                      child: Image.asset(
                                        "assets/chairs/available.png",
                                        color: seats.contains(67)
                                            ? AppColors.kRed
                                            : (table == tableNo && seat == 67)
                                                ? AppColors.kOrange
                                                : AppColors.kEvergreen,
                                        height: 22.r,
                                      ),
                                    ),
                                    Text("HDC7"),
                                  ],
                                ),
                                onTap: () {
                                  setState(() {
                                    updateTable(tableNo, 67, 'HDC7');
                                  });
                                },
                              ),
                            ),

                            Positioned(
                              top: 20.h,
                              left: 190.w,
                              child: InkWell(
                                child: Column(
                                  children: [
                                    RotatedBox(
                                      quarterTurns: 4,
                                      child: Image.asset(
                                        "assets/chairs/available.png",
                                        color: seats.contains(68)
                                            ? AppColors.kRed
                                            : (table == tableNo && seat == 68)
                                                ? AppColors.kOrange
                                                : AppColors.kEvergreen,
                                        height: 22.r,
                                      ),
                                    ),
                                    Text("HDC8"),
                                  ],
                                ),
                                onTap: () {
                                  setState(() {
                                    updateTable(tableNo, 68, 'HDC8');
                                  });
                                },
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 10.92.h,
                      ),
                      Row(
                        children: [
                          Container(
                            height: 15.61,
                            width: 31.21,
                            margin: const EdgeInsets.only(
                              left: 53.69,
                            ),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              color: const Color(0xFFEA893B),
                            ),
                          ),
                          Container(
                            margin: const EdgeInsets.only(
                              left: 18.73,
                            ),
                            child: Text(
                              "Selected",
                              style: GoogleFonts.lato(
                                textStyle: const TextStyle(
                                    fontSize: 10, fontWeight: FontWeight.w500),
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 15.61,
                      ),

                      Row(
                        children: [
                          Container(
                            height: 15.61,
                            width: 31.21,
                            margin: const EdgeInsets.only(
                              left: 53.69,
                            ),
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                color: AppColors.kEvergreen),
                          ),
                          Container(
                            margin: const EdgeInsets.only(
                              left: 18.73,
                            ),
                            child: Text(
                              "Available",
                              style: GoogleFonts.lato(
                                textStyle: const TextStyle(
                                    fontSize: 10, fontWeight: FontWeight.w500),
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 15.61,
                      ),
                      Row(
                        children: [
                          Container(
                            height: 15.61,
                            width: 31.21,
                            margin: const EdgeInsets.only(
                              left: 53.69,
                            ),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              color: const Color(0xFFD14751),
                            ),
                          ),
                          Container(
                            margin: const EdgeInsets.only(
                              left: 18.73,
                            ),
                            child: Text(
                              "Booked",
                              style: GoogleFonts.lato(
                                textStyle: const TextStyle(
                                    fontSize: 10, fontWeight: FontWeight.w500),
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 15,
                      ),
                      Center(
                        child: ElevatedButton(
                          style: ButtonStyle(
                              backgroundColor: MaterialStateProperty.all(
                                  AppColors.kAubergine)),
                          onPressed: () {
                            _performTableBooking(data);
                          },
                          child: const Text('Book'),
                        ),
                      )
                    ],
                  ),
                ),
              ),
            );
          });
        });
  }

  showTabledetails13(
      int tableNo, List<int> seats, Map<String, dynamic> data) async {
    await callAPI();
    return showDialog(
        context: context,
        builder: (context) {
          return StatefulBuilder(
              builder: (BuildContext context, StateSetter setState) {
            return Center(
              child: Card(
                child: Container(
                  height: MediaQuery.of(context).size.height * 0.57,
                  width: MediaQuery.of(context).size.width * 0.9,
                  // margin: const EdgeInsets.only(
                  //   left: 16.09,
                  //   right: 7.09,
                  // ),
                  padding: EdgeInsets.all(20.r),
                  decoration: const BoxDecoration(
                    color: Colors.white,
                  ),
                  child: Column(
                    //     mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      SizedBox(
                        height: 10.h,
                        width: MediaQuery.of(context).size.width,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            // ignore: avoid_unnecessary_containers
                            InkWell(
                              child: Icon(
                                Icons.close_rounded,
                                size: 20.r,
                              ),
                              onTap: () {
                                Navigator.pop(context);
                              },
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 20.6.h,
                      ),
                      Text(
                        "Seat Selection",
                        style: GoogleFonts.lato(
                          textStyle: TextStyle(
                              fontSize: 15.sp, fontWeight: FontWeight.w700),
                        ),
                      ),
                      SizedBox(
                        height: 20.6.h,
                      ),
                      // ignore: sized_box_for_whitespace
                      Container(
                        height: MediaQuery.of(context).size.height * 0.17,
                        width: MediaQuery.of(context).size.width,
                        // color: Colors.lightBlue,
                        // margin: const EdgeInsets.only(
                        //     top: 34.32, left: 48.41, right: 48.41),
                        child: Stack(
                          children: [
                            Center(
                                child: RotatedBox(
                              quarterTurns: 0,
                              child: SvgPicture.asset(
                                  'assets/table/rightangletable.svg',
                                  height: 120.h,
                                  width: 700.w),
                            )),

                            Positioned(
                              top: 74.h,
                              left: 190.w,
                              child: InkWell(
                                child: Column(
                                  children: [
                                    RotatedBox(
                                      quarterTurns: 4,
                                      child: Image.asset(
                                        "assets/chairs/available.png",
                                        color: seats.contains(69)
                                            ? AppColors.kRed
                                            : (table == tableNo && seat == 69)
                                                ? AppColors.kOrange
                                                : AppColors.kEvergreen,
                                        height: 22.r,
                                      ),
                                    ),
                                    Text("HDC9"),
                                  ],
                                ),
                                onTap: () {
                                  setState(() {
                                    updateTable(tableNo, 69, 'HDC9');
                                  });
                                },
                              ),
                            ),

                            Positioned(
                              top: 74.h,
                              left: 80.w,
                              child: InkWell(
                                child: Column(
                                  children: [
                                    RotatedBox(
                                      quarterTurns: 4,
                                      child: Image.asset(
                                        "assets/chairs/available.png",
                                        color: seats.contains(70)
                                            ? AppColors.kRed
                                            : (table == tableNo && seat == 70)
                                                ? AppColors.kOrange
                                                : AppColors.kEvergreen,
                                        height: 22.r,
                                      ),
                                    ),
                                    Text("HDC10"),
                                  ],
                                ),
                                onTap: () {
                                  setState(() {
                                    updateTable(tableNo, 70, 'HDC10');
                                  });
                                },
                              ),
                            ),

                            // Positioned(
                            //   top: 50.h,
                            //   left: 80.w,
                            //   child: InkWell(
                            //     child: Column(
                            //       children: [
                            //         Text("HDC3"),
                            //         RotatedBox(
                            //           quarterTurns: 4,
                            //           child: Image.asset(
                            //             "assets/chairs/available.png",
                            //             color: seats.contains(63)
                            //                 ? AppColors.kRed
                            //                 : (table == tableNo && seat == 63)
                            //                     ? AppColors.kOrange
                            //                     : AppColors.kEvergreen,
                            //             height: 22.r,
                            //           ),
                            //         ),
                            //       ],
                            //     ),
                            //     onTap: () {
                            //       setState(() {
                            //         updateTable(tableNo, 63);
                            //       });
                            //     },
                            //   ),
                            // ),

                            Positioned(
                              top: 20.h,
                              left: 80.w,
                              child: InkWell(
                                child: Column(
                                  children: [
                                    RotatedBox(
                                      quarterTurns: 4,
                                      child: Image.asset(
                                        "assets/chairs/available.png",
                                        color: seats.contains(71)
                                            ? AppColors.kRed
                                            : (table == tableNo && seat == 71)
                                                ? AppColors.kOrange
                                                : AppColors.kEvergreen,
                                        height: 22.r,
                                      ),
                                    ),
                                    Text("HDC11"),
                                  ],
                                ),
                                onTap: () {
                                  setState(() {
                                    updateTable(tableNo, 71, 'HDC11');
                                  });
                                },
                              ),
                            ),

                            Positioned(
                              top: 20.h,
                              left: 190.w,
                              child: InkWell(
                                child: Column(
                                  children: [
                                    RotatedBox(
                                      quarterTurns: 4,
                                      child: Image.asset(
                                        "assets/chairs/available.png",
                                        color: seats.contains(72)
                                            ? AppColors.kRed
                                            : (table == tableNo && seat == 72)
                                                ? AppColors.kOrange
                                                : AppColors.kEvergreen,
                                        height: 22.r,
                                      ),
                                    ),
                                    Text("HDC12"),
                                  ],
                                ),
                                onTap: () {
                                  setState(() {
                                    updateTable(tableNo, 72, 'HDC12');
                                  });
                                },
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 10.92.h,
                      ),
                      Row(
                        children: [
                          Container(
                            height: 15.61,
                            width: 31.21,
                            margin: const EdgeInsets.only(
                              left: 53.69,
                            ),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              color: const Color(0xFFEA893B),
                            ),
                          ),
                          Container(
                            margin: const EdgeInsets.only(
                              left: 18.73,
                            ),
                            child: Text(
                              "Selected",
                              style: GoogleFonts.lato(
                                textStyle: const TextStyle(
                                    fontSize: 10, fontWeight: FontWeight.w500),
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 15.61,
                      ),

                      Row(
                        children: [
                          Container(
                            height: 15.61,
                            width: 31.21,
                            margin: const EdgeInsets.only(
                              left: 53.69,
                            ),
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                color: AppColors.kEvergreen),
                          ),
                          Container(
                            margin: const EdgeInsets.only(
                              left: 18.73,
                            ),
                            child: Text(
                              "Available",
                              style: GoogleFonts.lato(
                                textStyle: const TextStyle(
                                    fontSize: 10, fontWeight: FontWeight.w500),
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 15.61,
                      ),
                      Row(
                        children: [
                          Container(
                            height: 15.61,
                            width: 31.21,
                            margin: const EdgeInsets.only(
                              left: 53.69,
                            ),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              color: const Color(0xFFD14751),
                            ),
                          ),
                          Container(
                            margin: const EdgeInsets.only(
                              left: 18.73,
                            ),
                            child: Text(
                              "Booked",
                              style: GoogleFonts.lato(
                                textStyle: const TextStyle(
                                    fontSize: 10, fontWeight: FontWeight.w500),
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 15,
                      ),
                      Center(
                        child: ElevatedButton(
                          style: ButtonStyle(
                              backgroundColor: MaterialStateProperty.all(
                                  AppColors.kAubergine)),
                          onPressed: () {
                            _performTableBooking(data);
                          },
                          child: const Text('Book'),
                        ),
                      )
                    ],
                  ),
                ),
              ),
            );
          });
        });
  }

  showTabledetails14(
      int tableNo, List<int> seats, Map<String, dynamic> data) async {
    await callAPI();
    return showDialog(
        context: context,
        builder: (context) {
          return StatefulBuilder(
              builder: (BuildContext context, StateSetter setState) {
            return Center(
              child: Card(
                child: Container(
                  height: MediaQuery.of(context).size.height * 0.57,
                  width: MediaQuery.of(context).size.width * 0.9,
                  // margin: const EdgeInsets.only(
                  //   left: 16.09,
                  //   right: 7.09,
                  // ),
                  padding: EdgeInsets.all(20.r),
                  decoration: const BoxDecoration(
                    color: Colors.white,
                  ),
                  child: Column(
                    //     mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      SizedBox(
                        height: 10.h,
                        width: MediaQuery.of(context).size.width,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            // ignore: avoid_unnecessary_containers
                            InkWell(
                              child: Icon(
                                Icons.close_rounded,
                                size: 20.r,
                              ),
                              onTap: () {
                                Navigator.pop(context);
                              },
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 20.6.h,
                      ),
                      Text(
                        "Seat Selection",
                        style: GoogleFonts.lato(
                          textStyle: TextStyle(
                              fontSize: 15.sp, fontWeight: FontWeight.w700),
                        ),
                      ),
                      SizedBox(
                        height: 20.6.h,
                      ),
                      // ignore: sized_box_for_whitespace
                      Container(
                        height: MediaQuery.of(context).size.height * 0.17,
                        width: MediaQuery.of(context).size.width,
                        // color: Colors.lightBlue,
                        // margin: const EdgeInsets.only(
                        //     top: 34.32, left: 48.41, right: 48.41),
                        child: Stack(
                          children: [
                            Center(
                                child: RotatedBox(
                              quarterTurns: 0,
                              child: SvgPicture.asset(
                                  'assets/table/rightangletable.svg',
                                  height: 120.h,
                                  width: 700.w),
                            )),

                            Positioned(
                              top: 74.h,
                              left: 190.w,
                              child: InkWell(
                                child: Column(
                                  children: [
                                    RotatedBox(
                                      quarterTurns: 4,
                                      child: Image.asset(
                                        "assets/chairs/available.png",
                                        color: seats.contains(73)
                                            ? AppColors.kRed
                                            : (table == tableNo && seat == 73)
                                                ? AppColors.kOrange
                                                : AppColors.kEvergreen,
                                        height: 22.r,
                                      ),
                                    ),
                                    Text("HDC13"),
                                  ],
                                ),
                                onTap: () {
                                  setState(() {
                                    updateTable(tableNo, 73, 'HDC13');
                                  });
                                },
                              ),
                            ),

                            Positioned(
                              top: 74.h,
                              left: 80.w,
                              child: InkWell(
                                child: Column(
                                  children: [
                                    RotatedBox(
                                      quarterTurns: 4,
                                      child: Image.asset(
                                        "assets/chairs/available.png",
                                        color: seats.contains(74)
                                            ? AppColors.kRed
                                            : (table == tableNo && seat == 74)
                                                ? AppColors.kOrange
                                                : AppColors.kEvergreen,
                                        height: 22.r,
                                      ),
                                    ),
                                    Text("HDC14"),
                                  ],
                                ),
                                onTap: () {
                                  setState(() {
                                    updateTable(tableNo, 74, 'HDC14');
                                  });
                                },
                              ),
                            ),

                            // Positioned(
                            //   top: 50.h,
                            //   left: 80.w,
                            //   child: InkWell(
                            //     child: Column(
                            //       children: [
                            //         Text("HDC3"),
                            //         RotatedBox(
                            //           quarterTurns: 4,
                            //           child: Image.asset(
                            //             "assets/chairs/available.png",
                            //             color: seats.contains(63)
                            //                 ? AppColors.kRed
                            //                 : (table == tableNo && seat == 63)
                            //                     ? AppColors.kOrange
                            //                     : AppColors.kEvergreen,
                            //             height: 22.r,
                            //           ),
                            //         ),
                            //       ],
                            //     ),
                            //     onTap: () {
                            //       setState(() {
                            //         updateTable(tableNo, 63);
                            //       });
                            //     },
                            //   ),
                            // ),

                            Positioned(
                              top: 20.h,
                              left: 80.w,
                              child: InkWell(
                                child: Column(
                                  children: [
                                    RotatedBox(
                                      quarterTurns: 4,
                                      child: Image.asset(
                                        "assets/chairs/available.png",
                                        color: seats.contains(75)
                                            ? AppColors.kRed
                                            : (table == tableNo && seat == 75)
                                                ? AppColors.kOrange
                                                : AppColors.kEvergreen,
                                        height: 22.r,
                                      ),
                                    ),
                                    Text("HDC15"),
                                  ],
                                ),
                                onTap: () {
                                  setState(() {
                                    updateTable(tableNo, 75, 'HDC15');
                                  });
                                },
                              ),
                            ),

                            Positioned(
                              top: 20.h,
                              left: 190.w,
                              child: InkWell(
                                child: Column(
                                  children: [
                                    RotatedBox(
                                      quarterTurns: 4,
                                      child: Image.asset(
                                        "assets/chairs/available.png",
                                        color: seats.contains(76)
                                            ? AppColors.kRed
                                            : (table == tableNo && seat == 76)
                                                ? AppColors.kOrange
                                                : AppColors.kEvergreen,
                                        height: 22.r,
                                      ),
                                    ),
                                    Text("HDC16"),
                                  ],
                                ),
                                onTap: () {
                                  setState(() {
                                    updateTable(tableNo, 76, 'HDC16');
                                  });
                                },
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 10.92.h,
                      ),
                      Row(
                        children: [
                          Container(
                            height: 15.61,
                            width: 31.21,
                            margin: const EdgeInsets.only(
                              left: 53.69,
                            ),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              color: const Color(0xFFEA893B),
                            ),
                          ),
                          Container(
                            margin: const EdgeInsets.only(
                              left: 18.73,
                            ),
                            child: Text(
                              "Selected",
                              style: GoogleFonts.lato(
                                textStyle: const TextStyle(
                                    fontSize: 10, fontWeight: FontWeight.w500),
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 15.61,
                      ),

                      Row(
                        children: [
                          Container(
                            height: 15.61,
                            width: 31.21,
                            margin: const EdgeInsets.only(
                              left: 53.69,
                            ),
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                color: AppColors.kEvergreen),
                          ),
                          Container(
                            margin: const EdgeInsets.only(
                              left: 18.73,
                            ),
                            child: Text(
                              "Available",
                              style: GoogleFonts.lato(
                                textStyle: const TextStyle(
                                    fontSize: 10, fontWeight: FontWeight.w500),
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 15.61,
                      ),
                      Row(
                        children: [
                          Container(
                            height: 15.61,
                            width: 31.21,
                            margin: const EdgeInsets.only(
                              left: 53.69,
                            ),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              color: const Color(0xFFD14751),
                            ),
                          ),
                          Container(
                            margin: const EdgeInsets.only(
                              left: 18.73,
                            ),
                            child: Text(
                              "Booked",
                              style: GoogleFonts.lato(
                                textStyle: const TextStyle(
                                    fontSize: 10, fontWeight: FontWeight.w500),
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 15,
                      ),
                      Center(
                        child: ElevatedButton(
                          style: ButtonStyle(
                              backgroundColor: MaterialStateProperty.all(
                                  AppColors.kAubergine)),
                          onPressed: () {
                            _performTableBooking(data);
                          },
                          child: const Text('Book'),
                        ),
                      )
                    ],
                  ),
                ),
              ),
            );
          });
        });
  }

  showTabledetails15(
      int tableNo, List<int> seats, Map<String, dynamic> data) async {
    await callAPI();
    return showDialog(
        context: context,
        builder: (context) {
          return StatefulBuilder(
              builder: (BuildContext context, StateSetter setState) {
            return Center(
              child: Card(
                child: Container(
                  height: MediaQuery.of(context).size.height * 0.57,
                  width: MediaQuery.of(context).size.width * 0.9,
                  // margin: const EdgeInsets.only(
                  //   left: 16.09,
                  //   right: 7.09,
                  // ),
                  padding: EdgeInsets.all(20.r),
                  decoration: const BoxDecoration(
                    color: Colors.white,
                  ),
                  child: Column(
                    //     mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      SizedBox(
                        height: 10.h,
                        width: MediaQuery.of(context).size.width,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            // ignore: avoid_unnecessary_containers
                            InkWell(
                              child: Icon(
                                Icons.close_rounded,
                                size: 20.r,
                              ),
                              onTap: () {
                                Navigator.pop(context);
                              },
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 20.6.h,
                      ),
                      Text(
                        "Seat Selection",
                        style: GoogleFonts.lato(
                          textStyle: TextStyle(
                              fontSize: 15.sp, fontWeight: FontWeight.w700),
                        ),
                      ),
                      SizedBox(
                        height: 20.6.h,
                      ),
                      // ignore: sized_box_for_whitespace
                      Container(
                        height: MediaQuery.of(context).size.height * 0.17,
                        width: MediaQuery.of(context).size.width,
                        // color: Colors.lightBlue,
                        // margin: const EdgeInsets.only(
                        //     top: 34.32, left: 48.41, right: 48.41),
                        child: Stack(
                          children: [
                            Center(
                                child: RotatedBox(
                              quarterTurns: 0,
                              child: SvgPicture.asset(
                                  'assets/table/rightangletable.svg',
                                  height: 120.h,
                                  width: 700.w),
                            )),
                            Positioned(
                              top: 74.h,
                              left: 190.w,
                              child: InkWell(
                                child: Column(
                                  children: [
                                    RotatedBox(
                                      quarterTurns: 4,
                                      child: Image.asset(
                                        "assets/chairs/available.png",
                                        color: seats.contains(77)
                                            ? AppColors.kRed
                                            : (table == tableNo && seat == 77)
                                                ? AppColors.kOrange
                                                : AppColors.kEvergreen,
                                        height: 22.r,
                                      ),
                                    ),
                                    Text("HDC17"),
                                  ],
                                ),
                                onTap: () {
                                  setState(() {
                                    updateTable(tableNo, 77, 'HDC17');
                                  });
                                },
                              ),
                            ),
                            Positioned(
                              top: 74.h,
                              left: 80.w,
                              child: InkWell(
                                child: Column(
                                  children: [
                                    RotatedBox(
                                      quarterTurns: 4,
                                      child: Image.asset(
                                        "assets/chairs/available.png",
                                        color: seats.contains(78)
                                            ? AppColors.kRed
                                            : (table == tableNo && seat == 78)
                                                ? AppColors.kOrange
                                                : AppColors.kEvergreen,
                                        height: 22.r,
                                      ),
                                    ),
                                    Text("HDC18"),
                                  ],
                                ),
                                onTap: () {
                                  setState(() {
                                    updateTable(tableNo, 78, 'HDC18');
                                  });
                                },
                              ),
                            ),
                            Positioned(
                              top: 20.h,
                              left: 80.w,
                              child: InkWell(
                                child: Column(
                                  children: [
                                    RotatedBox(
                                      quarterTurns: 4,
                                      child: Image.asset(
                                        "assets/chairs/available.png",
                                        color: seats.contains(79)
                                            ? AppColors.kRed
                                            : (table == tableNo && seat == 79)
                                                ? AppColors.kOrange
                                                : AppColors.kEvergreen,
                                        height: 22.r,
                                      ),
                                    ),
                                    Text("HDC19"),
                                  ],
                                ),
                                onTap: () {
                                  setState(() {
                                    updateTable(tableNo, 79, 'HDC19');
                                  });
                                },
                              ),
                            ),
                            Positioned(
                              top: 20.h,
                              left: 190.w,
                              child: InkWell(
                                child: Column(
                                  children: [
                                    RotatedBox(
                                      quarterTurns: 4,
                                      child: Image.asset(
                                        "assets/chairs/available.png",
                                        color: seats.contains(80)
                                            ? AppColors.kRed
                                            : (table == tableNo && seat == 80)
                                                ? AppColors.kOrange
                                                : AppColors.kEvergreen,
                                        height: 22.r,
                                      ),
                                    ),
                                    Text("HDC20"),
                                  ],
                                ),
                                onTap: () {
                                  setState(() {
                                    updateTable(tableNo, 80, 'HDC20');
                                  });
                                },
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 10.92.h,
                      ),
                      Row(
                        children: [
                          Container(
                            height: 15.61,
                            width: 31.21,
                            margin: const EdgeInsets.only(
                              left: 53.69,
                            ),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              color: const Color(0xFFEA893B),
                            ),
                          ),
                          Container(
                            margin: const EdgeInsets.only(
                              left: 18.73,
                            ),
                            child: Text(
                              "Selected",
                              style: GoogleFonts.lato(
                                textStyle: const TextStyle(
                                    fontSize: 10, fontWeight: FontWeight.w500),
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 15.61,
                      ),

                      Row(
                        children: [
                          Container(
                            height: 15.61,
                            width: 31.21,
                            margin: const EdgeInsets.only(
                              left: 53.69,
                            ),
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                color: AppColors.kEvergreen),
                          ),
                          Container(
                            margin: const EdgeInsets.only(
                              left: 18.73,
                            ),
                            child: Text(
                              "Available",
                              style: GoogleFonts.lato(
                                textStyle: const TextStyle(
                                    fontSize: 10, fontWeight: FontWeight.w500),
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 15.61,
                      ),
                      Row(
                        children: [
                          Container(
                            height: 15.61,
                            width: 31.21,
                            margin: const EdgeInsets.only(
                              left: 53.69,
                            ),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              color: const Color(0xFFD14751),
                            ),
                          ),
                          Container(
                            margin: const EdgeInsets.only(
                              left: 18.73,
                            ),
                            child: Text(
                              "Booked",
                              style: GoogleFonts.lato(
                                textStyle: const TextStyle(
                                    fontSize: 10, fontWeight: FontWeight.w500),
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 15,
                      ),
                      Center(
                        child: ElevatedButton(
                          style: ButtonStyle(
                              backgroundColor: MaterialStateProperty.all(
                                  AppColors.kAubergine)),
                          onPressed: () {
                            _performTableBooking(data);
                          },
                          child: const Text('Book'),
                        ),
                      )
                    ],
                  ),
                ),
              ),
            );
          });
        });
  }

  showTabledetails16(
      int tableNo, List<int> seats, Map<String, dynamic> data) async {
    await callAPI();
    return showDialog(
        context: context,
        builder: (context) {
          return StatefulBuilder(
              builder: (BuildContext context, StateSetter setState) {
            return Center(
              child: Card(
                child: Container(
                  height: MediaQuery.of(context).size.height * 0.57,
                  width: MediaQuery.of(context).size.width * 0.9,
                  // margin: const EdgeInsets.only(
                  //   left: 16.09,
                  //   right: 7.09,
                  // ),
                  padding: EdgeInsets.all(20.r),
                  decoration: const BoxDecoration(
                    color: Colors.white,
                  ),
                  child: Column(
                    //     mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      SizedBox(
                        height: 10.h,
                        width: MediaQuery.of(context).size.width,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            // ignore: avoid_unnecessary_containers
                            InkWell(
                              child: Icon(
                                Icons.close_rounded,
                                size: 20.r,
                              ),
                              onTap: () {
                                Navigator.pop(context);
                              },
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 20.6.h,
                      ),
                      Text(
                        "Seat Selection",
                        style: GoogleFonts.lato(
                          textStyle: TextStyle(
                              fontSize: 15.sp, fontWeight: FontWeight.w700),
                        ),
                      ),
                      SizedBox(
                        height: 20.6.h,
                      ),
                      // ignore: sized_box_for_whitespace
                      Container(
                        height: MediaQuery.of(context).size.height * 0.17,
                        width: MediaQuery.of(context).size.width,
                        // color: Colors.lightBlue,
                        // margin: const EdgeInsets.only(
                        //     top: 34.32, left: 48.41, right: 48.41),
                        child: Stack(
                          children: [
                            Center(
                                child: RotatedBox(
                              quarterTurns: 0,
                              child: SvgPicture.asset(
                                  'assets/table/rightangletable.svg',
                                  height: 120.h,
                                  width: 700.w),
                            )),
                            Positioned(
                              top: 74.h,
                              left: 190.w,
                              child: InkWell(
                                child: Column(
                                  children: [
                                    RotatedBox(
                                      quarterTurns: 4,
                                      child: Image.asset(
                                        "assets/chairs/available.png",
                                        color: seats.contains(81)
                                            ? AppColors.kRed
                                            : (table == tableNo && seat == 81)
                                                ? AppColors.kOrange
                                                : AppColors.kEvergreen,
                                        height: 22.r,
                                      ),
                                    ),
                                    Text("HDC21"),
                                  ],
                                ),
                                onTap: () {
                                  setState(() {
                                    updateTable(tableNo, 81, 'HDC21');
                                  });
                                },
                              ),
                            ),
                            Positioned(
                              top: 74.h,
                              left: 80.w,
                              child: InkWell(
                                child: Column(
                                  children: [
                                    RotatedBox(
                                      quarterTurns: 4,
                                      child: Image.asset(
                                        "assets/chairs/available.png",
                                        color: seats.contains(82)
                                            ? AppColors.kRed
                                            : (table == tableNo && seat == 82)
                                                ? AppColors.kOrange
                                                : AppColors.kEvergreen,
                                        height: 22.r,
                                      ),
                                    ),
                                    Text("HDC22"),
                                  ],
                                ),
                                onTap: () {
                                  setState(() {
                                    updateTable(tableNo, 82, 'HDC22');
                                  });
                                },
                              ),
                            ),
                            Positioned(
                              top: 20.h,
                              left: 80.w,
                              child: InkWell(
                                child: Column(
                                  children: [
                                    RotatedBox(
                                      quarterTurns: 4,
                                      child: Image.asset(
                                        "assets/chairs/available.png",
                                        color: seats.contains(83)
                                            ? AppColors.kRed
                                            : (table == tableNo && seat == 83)
                                                ? AppColors.kOrange
                                                : AppColors.kEvergreen,
                                        height: 22.r,
                                      ),
                                    ),
                                    Text("HDC23"),
                                  ],
                                ),
                                onTap: () {
                                  setState(() {
                                    updateTable(tableNo, 83, 'HDC23');
                                  });
                                },
                              ),
                            ),
                            Positioned(
                              top: 20.h,
                              left: 190.w,
                              child: InkWell(
                                child: Column(
                                  children: [
                                    RotatedBox(
                                      quarterTurns: 4,
                                      child: Image.asset(
                                        "assets/chairs/available.png",
                                        color: seats.contains(84)
                                            ? AppColors.kRed
                                            : (table == tableNo && seat == 84)
                                                ? AppColors.kOrange
                                                : AppColors.kEvergreen,
                                        height: 22.r,
                                      ),
                                    ),
                                    Text("HDC24"),
                                  ],
                                ),
                                onTap: () {
                                  setState(() {
                                    updateTable(tableNo, 84, 'HDC24');
                                  });
                                },
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 10.92.h,
                      ),
                      Row(
                        children: [
                          Container(
                            height: 15.61,
                            width: 31.21,
                            margin: const EdgeInsets.only(
                              left: 53.69,
                            ),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              color: const Color(0xFFEA893B),
                            ),
                          ),
                          Container(
                            margin: const EdgeInsets.only(
                              left: 18.73,
                            ),
                            child: Text(
                              "Selected",
                              style: GoogleFonts.lato(
                                textStyle: const TextStyle(
                                    fontSize: 10, fontWeight: FontWeight.w500),
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 15.61,
                      ),

                      Row(
                        children: [
                          Container(
                            height: 15.61,
                            width: 31.21,
                            margin: const EdgeInsets.only(
                              left: 53.69,
                            ),
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                color: AppColors.kEvergreen),
                          ),
                          Container(
                            margin: const EdgeInsets.only(
                              left: 18.73,
                            ),
                            child: Text(
                              "Available",
                              style: GoogleFonts.lato(
                                textStyle: const TextStyle(
                                    fontSize: 10, fontWeight: FontWeight.w500),
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 15.61,
                      ),
                      Row(
                        children: [
                          Container(
                            height: 15.61,
                            width: 31.21,
                            margin: const EdgeInsets.only(
                              left: 53.69,
                            ),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              color: const Color(0xFFD14751),
                            ),
                          ),
                          Container(
                            margin: const EdgeInsets.only(
                              left: 18.73,
                            ),
                            child: Text(
                              "Booked",
                              style: GoogleFonts.lato(
                                textStyle: const TextStyle(
                                    fontSize: 10, fontWeight: FontWeight.w500),
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 15,
                      ),
                      Center(
                        child: ElevatedButton(
                          style: ButtonStyle(
                              backgroundColor: MaterialStateProperty.all(
                                  AppColors.kAubergine)),
                          onPressed: () {
                            _performTableBooking(data);
                          },
                          child: const Text('Book'),
                        ),
                      )
                    ],
                  ),
                ),
              ),
            );
          });
        });
  }

  showTabledetails17(
      int tableNo, List<int> seats, Map<String, dynamic> data) async {
    await callAPI();
    return showDialog(
        context: context,
        builder: (context) {
          return StatefulBuilder(
              builder: (BuildContext context, StateSetter setState) {
            return Center(
              child: Card(
                child: Container(
                  height: MediaQuery.of(context).size.height * 0.57,
                  width: MediaQuery.of(context).size.width * 0.9,
                  // margin: const EdgeInsets.only(
                  //   left: 16.09,
                  //   right: 7.09,
                  // ),
                  padding: EdgeInsets.all(20.r),
                  decoration: const BoxDecoration(
                    color: Colors.white,
                  ),
                  child: Column(
                    //     mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      SizedBox(
                        height: 10.h,
                        width: MediaQuery.of(context).size.width,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            // ignore: avoid_unnecessary_containers
                            InkWell(
                              child: Icon(
                                Icons.close_rounded,
                                size: 20.r,
                              ),
                              onTap: () {
                                Navigator.pop(context);
                              },
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 20.6.h,
                      ),
                      Text(
                        "Seat Selection",
                        style: GoogleFonts.lato(
                          textStyle: TextStyle(
                              fontSize: 15.sp, fontWeight: FontWeight.w700),
                        ),
                      ),
                      SizedBox(
                        height: 20.6.h,
                      ),
                      // ignore: sized_box_for_whitespace
                      Container(
                        height: MediaQuery.of(context).size.height * 0.17,
                        width: MediaQuery.of(context).size.width,
                        // color: Colors.lightBlue,
                        // margin: const EdgeInsets.only(
                        //     top: 34.32, left: 48.41, right: 48.41),
                        child: Stack(
                          children: [
                            Center(
                                child: RotatedBox(
                              quarterTurns: 0,
                              child: SvgPicture.asset(
                                  'assets/table/rightangletable.svg',
                                  height: 120.h,
                                  width: 700.w),
                            )),
                            Positioned(
                              top: 74.h,
                              left: 190.w,
                              child: InkWell(
                                child: Column(
                                  children: [
                                    RotatedBox(
                                      quarterTurns: 4,
                                      child: Image.asset(
                                        "assets/chairs/available.png",
                                        color: seats.contains(85)
                                            ? AppColors.kRed
                                            : (table == tableNo && seat == 85)
                                                ? AppColors.kOrange
                                                : AppColors.kEvergreen,
                                        height: 22.r,
                                      ),
                                    ),
                                    Text("HDC25"),
                                  ],
                                ),
                                onTap: () {
                                  setState(() {
                                    updateTable(tableNo, 85, 'HDC25');
                                  });
                                },
                              ),
                            ),
                            Positioned(
                              top: 74.h,
                              left: 80.w,
                              child: InkWell(
                                child: Column(
                                  children: [
                                    RotatedBox(
                                      quarterTurns: 4,
                                      child: Image.asset(
                                        "assets/chairs/available.png",
                                        color: seats.contains(86)
                                            ? AppColors.kRed
                                            : (table == tableNo && seat == 86)
                                                ? AppColors.kOrange
                                                : AppColors.kEvergreen,
                                        height: 22.r,
                                      ),
                                    ),
                                    Text("HDC26"),
                                  ],
                                ),
                                onTap: () {
                                  setState(() {
                                    updateTable(tableNo, 86, 'HDC26');
                                  });
                                },
                              ),
                            ),
                            Positioned(
                              top: 20.h,
                              left: 80.w,
                              child: InkWell(
                                child: Column(
                                  children: [
                                    RotatedBox(
                                      quarterTurns: 4,
                                      child: Image.asset(
                                        "assets/chairs/available.png",
                                        color: seats.contains(87)
                                            ? AppColors.kRed
                                            : (table == tableNo && seat == 87)
                                                ? AppColors.kOrange
                                                : AppColors.kEvergreen,
                                        height: 22.r,
                                      ),
                                    ),
                                    Text("HDC27"),
                                  ],
                                ),
                                onTap: () {
                                  setState(() {
                                    updateTable(tableNo, 87, 'HDC27');
                                  });
                                },
                              ),
                            ),
                            Positioned(
                              top: 20.h,
                              left: 190.w,
                              child: InkWell(
                                child: Column(
                                  children: [
                                    RotatedBox(
                                      quarterTurns: 4,
                                      child: Image.asset(
                                        "assets/chairs/available.png",
                                        color: seats.contains(88)
                                            ? AppColors.kRed
                                            : (table == tableNo && seat == 88)
                                                ? AppColors.kOrange
                                                : AppColors.kEvergreen,
                                        height: 22.r,
                                      ),
                                    ),
                                    Text("HDC28"),
                                  ],
                                ),
                                onTap: () {
                                  setState(() {
                                    updateTable(tableNo, 88, 'HDC28');
                                  });
                                },
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 10.92.h,
                      ),
                      Row(
                        children: [
                          Container(
                            height: 15.61,
                            width: 31.21,
                            margin: const EdgeInsets.only(
                              left: 53.69,
                            ),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              color: const Color(0xFFEA893B),
                            ),
                          ),
                          Container(
                            margin: const EdgeInsets.only(
                              left: 18.73,
                            ),
                            child: Text(
                              "Selected",
                              style: GoogleFonts.lato(
                                textStyle: const TextStyle(
                                    fontSize: 10, fontWeight: FontWeight.w500),
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 15.61,
                      ),

                      Row(
                        children: [
                          Container(
                            height: 15.61,
                            width: 31.21,
                            margin: const EdgeInsets.only(
                              left: 53.69,
                            ),
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                color: AppColors.kEvergreen),
                          ),
                          Container(
                            margin: const EdgeInsets.only(
                              left: 18.73,
                            ),
                            child: Text(
                              "Available",
                              style: GoogleFonts.lato(
                                textStyle: const TextStyle(
                                    fontSize: 10, fontWeight: FontWeight.w500),
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 15.61,
                      ),
                      Row(
                        children: [
                          Container(
                            height: 15.61,
                            width: 31.21,
                            margin: const EdgeInsets.only(
                              left: 53.69,
                            ),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              color: const Color(0xFFD14751),
                            ),
                          ),
                          Container(
                            margin: const EdgeInsets.only(
                              left: 18.73,
                            ),
                            child: Text(
                              "Booked",
                              style: GoogleFonts.lato(
                                textStyle: const TextStyle(
                                    fontSize: 10, fontWeight: FontWeight.w500),
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 15,
                      ),
                      Center(
                        child: ElevatedButton(
                          style: ButtonStyle(
                              backgroundColor: MaterialStateProperty.all(
                                  AppColors.kAubergine)),
                          onPressed: () {
                            _performTableBooking(data);
                          },
                          child: const Text('Book'),
                        ),
                      )
                    ],
                  ),
                ),
              ),
            );
          });
        });
  }

  void updateTable(int tableNo, int seatNo, String displayName) {
    setState(() {
      this.tableNo = tableNo;
      this.seatNo = seatNo;
      this.displayName = displayName;
      selectTable(tableNo, seatNo);
    });
  }

  _performTableBooking(Map<String, dynamic> data) {
    if (tableNo == null || seatNo == null) {
      return;
    }
    if (data["selecteddate"] != null &&
        data["todate"] != null &&
        data["fromtime"] != null &&
        data["totime"] != null) {
      TableBookingDataSource()
          .createBooking(
              tableNo: tableNo ?? 0,
              seatNo: seatNo ?? 0,
              startDate: data["selecteddate"],
              endDate: data["todate"],
              floor: _selectedFloor,
              fromTime: data["fromtime"],
              toTime: data["totime"],
              displayname: displayName ?? '')
          .then((value) {
        if (value) {
          Get.back();

          //setState(() {});
          // Navigator.pop(context);

          showDialog(
              context: context,
              barrierDismissible: false,
              useRootNavigator: false,
              builder: (context) {
                return BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 2.5, sigmaY: 2.5),
                  child: Dialog(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20.0)),
                    child: BookingConfirmedWidget(
                        data["fromtime"],
                        data["totime"],
                        tableNo ?? 0,
                        displayName ?? '',
                        data["selecteddate"],
                        _selectedFloor),
                  ),
                );
              }).then((value) {
            Get.offAllNamed("/home");
            // eventBus.fire(HotDeskingInitialEvent());
          });
        } else {
          Get.back();
          // Navigator.pop(context);
        }
      });
    } else {
      showSnackBar(
          context: context,
          message: 'Provide start and end time',
          bgColor: AppColors.kRed);
    }
  }
}
