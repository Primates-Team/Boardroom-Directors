import 'dart:convert';
import 'dart:core';
import 'dart:io';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
// import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
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
  int? tableNo, seatNo;
  String? displayName;

  late Map<int, List<int>> bookedTables;

  final String _selectedFloor = 'Floor 3';
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
          int.parse(element["tableid"]): int.parse(element["seatnumber"])
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
            "floor": widget.selectedFloor,
            "current_time": AppHelpers.formatTime(TimeOfDay.now())
          }));

      List<dynamic> jsondata = jsonDecode(response.body);

      List<Map<int, int>> tableData = [];

      jsondata.forEach((element) {
        Map<int, int> tableSeatDict = {
          int.parse(element["tableid"]): int.parse(element["seatnumber"])
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

    for (var i = 1; i < 8; i++) {
      modifiedTables[i] = [];
      for (var element in bookingController.tableData) {
        if (element.containsKey(i)) {
          modifiedTables[i]?.add(element.values.first);
        }
      }
    }
    callAPI();
    callnext();

    bookedTables = modifiedTables;
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
    return _buildBodyWidget();
  }

  FutureBuilder<List<Map<int, int>>> _buildBodyWidget() {
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
                  width: MediaQuery.of(context).size.width,
                  child: SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Stack(
                        children: [
                          RotatedBox(
                              quarterTurns: 4,
                              child: SvgPicture.asset(
                                "assets/svg/level3/Map3level 3.svg",
                                width: MediaQuery.of(context).size.width,
                                height: 500.h,
                              )),
                          Positioned(
                              top: 38.w,
                              left: 74.w,
                              child: InkWell(
                                child: SvgPicture.asset(
                                  'assets/svg/level3/Frame 44level 3.svg',
                                  width: 70.w,
                                ),
                                onTap: () {
                                  _buildDateSelectionDialog(6);
                                },
                              )),
                          Positioned(
                              top: 40.w,
                              left: 160.w,
                              child: InkWell(
                                child: SvgPicture.asset(
                                  'assets/svg/level3/Frame 45level 3.svg',
                                  width: 70.w,
                                ),
                                onTap: () {
                                  _buildDateSelectionDialog(1);
                                },
                              )),
                          Positioned(
                            top: 200.w,
                            left: 100.w,
                            child: InkWell(
                              child: SvgPicture.asset(
                                'assets/svg/level3/Frame 47level 3.svg',
                                width: 70.w,
                              ),
                              onTap: () {
                                _buildDateSelectionDialog(5);
                              },
                            ),
                          ),
                          Positioned(
                            top: 300.w,
                            left: 100.w,
                            child: InkWell(
                              child: SvgPicture.asset(
                                  'assets/svg/level3/Frame 48level 3.svg',
                                  width: 70.w,
                                  fit: BoxFit.fitWidth),
                              onTap: () {
                                _buildDateSelectionDialog(4);
                              },
                            ),
                          ),
                          Positioned(
                            bottom: 180.w,
                            left: 220.w,
                            child: InkWell(
                              child: SvgPicture.asset(
                                'assets/svg/level3/Frame 49level 3.svg',
                                width: 105.w,
                              ),
                              onTap: () {
                                _buildDateSelectionDialog(3);
                              },
                            ),
                          ),
                          Positioned(
                            top: 40.w,
                            left: 260.w,
                            child: InkWell(
                              child: SvgPicture.asset(
                                'assets/svg/level3/Frame 46level 3.svg',
                                width: 70.w,
                              ),
                              onTap: () {
                                _buildDateSelectionDialog(2);
                              },
                            ),
                          ),
                        ],
                      )),
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

              for (var i = 1; i < 8; i++) {
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
              }
            }),
          );
        });
  }

  showTabledetails3(
      int tableNo, List<int> seats, Map<String, dynamic> data) async {
    return showDialog(
        context: context,
        builder: (context) {
          return StatefulBuilder(builder: (context, setState) {
            return Center(
              child: Card(
                child: Container(
                  height: MediaQuery.of(context).size.height * 0.57,
                  width: MediaQuery.of(context).size.width * 0.9,
                  padding: EdgeInsets.all(20.r),
                  decoration: const BoxDecoration(
                    color: Colors.white,
                  ),
                  child: SingleChildScrollView(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
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
                          child: Stack(
                            children: [
                              Center(
                                  child: SvgPicture.asset(
                                      'assets/table/tableangle.svg',
                                      height: 150.h,
                                      width: 600.w)),
                              Positioned(
                                top: 150.h,
                                left: 125.w,
                                child: InkWell(
                                  child: Column(
                                    children: [
                                      RotatedBox(
                                        quarterTurns: 2,
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
                                      const Text('HDG1')
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
                                top: 80.h,
                                left: 60.w,
                                child: InkWell(
                                  child: Column(
                                    children: [
                                      const Text('HDG2'),
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
                                top: 41.h,
                                left: 100.w,
                                child: InkWell(
                                  onTap: () {
                                    setState(() {
                                      updateTable(tableNo, 3, 'HDG3');
                                    });
                                  },
                                  child: Column(
                                    children: [
                                      const Text('HDG3'),
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
                                    ],
                                  ),
                                ),
                              ),
                              Positioned(
                                left: 145.w,
                                child: InkWell(
                                  onTap: () {
                                    setState(() {
                                      updateTable(tableNo, 4, 'HDG4');
                                    });
                                  },
                                  child: Column(
                                    children: [
                                      const Text('HDG4'),
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
                                    ],
                                  ),
                                ),
                              ),
                              Positioned(
                                top: 71.h,
                                left: 210.w,
                                child: InkWell(
                                  onTap: () {
                                    setState(() {
                                      updateTable(tableNo, 5, 'HDG5');
                                    });
                                  },
                                  child: Column(
                                    children: [
                                      RotatedBox(
                                        quarterTurns: 2,
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
                                      const Text('HDG5'),
                                    ],
                                  ),
                                ),
                              ),
                              Positioned(
                                top: 110.h,
                                left: 175.w,
                                child: InkWell(
                                  child: Column(
                                    children: [
                                      RotatedBox(
                                        quarterTurns: 2,
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
                                      const Text('HDG6'),
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
                          height: 10.h,
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
                                      fontSize: 10,
                                      fontWeight: FontWeight.w500),
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
                                      fontSize: 10,
                                      fontWeight: FontWeight.w500),
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
                                      fontSize: 10,
                                      fontWeight: FontWeight.w500),
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
                            onPressed: () async {
                              if (tableNo == null || seatNo == null) {
                                return;
                              }
                              if (data["selecteddate"] != null &&
                                  data["todate"] != null &&
                                  data["fromtime"] != null &&
                                  data["totime"] != null) {
                                TableBookingDataSource()
                                    .createBooking(
                                        tableNo: tableNo,
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
                                            filter: ImageFilter.blur(
                                                sigmaX: 2.5, sigmaY: 2.5),
                                            child: Dialog(
                                              shape: RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          20.0)),
                                              child: BookingConfirmedWidget(
                                                  data["fromtime"],
                                                  data["totime"],
                                                  tableNo,
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
                                    Navigator.pop(context);
                                  }
                                });
                              } else {
                                showSnackBar(
                                    context: context,
                                    message: 'Provide start and end time',
                                    bgColor: AppColors.kRed);
                              }
                            },
                            child: const Text('Book'),
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              ),
            );
          });
        });
  }

  showTabledetails2(
      int tableNo, List<int> seats, Map<String, dynamic> data) async {
    return showDialog(
        context: context,
        builder: (context) {
          return StatefulBuilder(
              builder: (BuildContext context, StateSetter setState) {
            return Center(
              child: Card(
                child: Container(
                  height: MediaQuery.of(context).size.height * 0.55,
                  width: MediaQuery.of(context).size.width * 0.9,
                  padding: EdgeInsets.all(20.r),
                  decoration: const BoxDecoration(
                    color: Colors.white,
                  ),
                  child: Column(
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
                            const Center(
                              child: Image(
                                  image: AssetImage(
                                      "assets/images/verticalRectangle 143.png")),
                            ),
                            Positioned(
                              top: 78.h,
                              left: 40.w,
                              child: InkWell(
                                child: Row(
                                  children: [
                                    const Text("HDG7"),
                                    RotatedBox(
                                      quarterTurns: 3,
                                      child: Image.asset(
                                        "assets/chairs/available.png",
                                        color: seats.contains(7)
                                            ? AppColors.kRed
                                            : (table == tableNo && seat == 7)
                                                ? AppColors.kOrange
                                                : AppColors.kEvergreen,
                                        height: 30.r,
                                      ),
                                    ),
                                  ],
                                ),
                                onTap: () {
                                  setState(() {
                                    updateTable(tableNo, 7, "HDG7");
                                  });
                                },
                              ),
                            ),
                            Positioned(
                              top: 20.h,
                              left: 40.w,
                              child: InkWell(
                                child: Row(
                                  children: [
                                    const Text("HDG8"),
                                    RotatedBox(
                                      quarterTurns: 3,
                                      child: Image.asset(
                                        "assets/chairs/available.png",
                                        color: seats.contains(8)
                                            ? AppColors.kRed
                                            : (table == tableNo && seat == 8)
                                                ? AppColors.kOrange
                                                : AppColors.kEvergreen,
                                        height: 30.r,
                                      ),
                                    ),
                                  ],
                                ),
                                onTap: () {
                                  setState(() {
                                    updateTable(tableNo, 8, "HDG8");
                                  });
                                  setState(() {});
                                },
                              ),
                            ),
                            Positioned(
                              top: 78.h,
                              left: 195.w,
                              child: InkWell(
                                child: Row(
                                  children: [
                                    RotatedBox(
                                      quarterTurns: 1,
                                      child: Image.asset(
                                        "assets/chairs/available.png",
                                        color: seats.contains(9)
                                            ? AppColors.kRed
                                            : (table == tableNo && seat == 9)
                                                ? AppColors.kOrange
                                                : AppColors.kEvergreen,
                                        height: 30.r,
                                      ),
                                    ),
                                    const Text("HDG9"),
                                  ],
                                ),
                                onTap: () {
                                  setState(() {
                                    updateTable(tableNo, 9, "HDG9");
                                  });
                                },
                              ),
                            ),
                            Positioned(
                              top: 20.h,
                              left: 195.w,
                              child: InkWell(
                                child: Row(
                                  children: [
                                    RotatedBox(
                                      quarterTurns: 1,
                                      child: Image.asset(
                                        "assets/chairs/available.png",
                                        color: seats.contains(10)
                                            ? AppColors.kRed
                                            : (table == tableNo && seat == 10)
                                                ? AppColors.kOrange
                                                : AppColors.kEvergreen,
                                        height: 30.r,
                                      ),
                                    ),
                                    const Text("HDG10"),
                                  ],
                                ),
                                onTap: () {
                                  setState(() {
                                    updateTable(tableNo, 10, "HDG10");
                                  });
                                },
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 31.92.h,
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
                              color: AppColors.kEvergreen,
                            ),
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
                            if (tableNo == null || seatNo == null) {
                              return;
                            }
                            if (data["selecteddate"] != null &&
                                data["todate"] != null &&
                                data["fromtime"] != null &&
                                data["totime"] != null) {
                              TableBookingDataSource()
                                  .createBooking(
                                      tableNo: tableNo,
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
                                          filter: ImageFilter.blur(
                                              sigmaX: 2.5, sigmaY: 2.5),
                                          child: Dialog(
                                            shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(
                                                        20.0)),
                                            child: BookingConfirmedWidget(
                                                data["fromtime"],
                                                data["totime"],
                                                tableNo,
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
                                  Navigator.pop(context);
                                }
                              });
                            } else {
                              showSnackBar(
                                  context: context,
                                  message: 'Provide start and end time',
                                  bgColor: AppColors.kRed);
                            }
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

  showTabledetails1(
      int tableNo, List<int> seats, Map<String, dynamic> data) async {
    return showDialog(
        context: context,
        builder: (context) {
          return StatefulBuilder(
              builder: (BuildContext context, StateSetter setState) {
            return Center(
              child: Card(
                child: Container(
                  height: MediaQuery.of(context).size.height * 0.55,
                  width: MediaQuery.of(context).size.width * 0.9,
                  padding: EdgeInsets.all(20.r),
                  decoration: const BoxDecoration(
                    color: Colors.white,
                  ),
                  child: Column(
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
                            const Center(
                              child: Image(
                                  image: AssetImage(
                                      "assets/images/verticalRectangle 143.png")),
                            ),
                            Positioned(
                              top: 78.h,
                              left: 40.w,
                              child: InkWell(
                                child: Row(
                                  children: [
                                    const Text("HDG11"),
                                    RotatedBox(
                                      quarterTurns: 3,
                                      child: Image.asset(
                                        "assets/chairs/available.png",
                                        color: seats.contains(11)
                                            ? AppColors.kRed
                                            : (table == tableNo && seat == 11)
                                                ? AppColors.kOrange
                                                : AppColors.kEvergreen,
                                        height: 30.r,
                                      ),
                                    ),
                                  ],
                                ),
                                onTap: () {
                                  setState(() {
                                    updateTable(tableNo, 11, "HDG11");
                                  });
                                },
                              ),
                            ),
                            Positioned(
                              top: 20.h,
                              left: 40.w,
                              child: InkWell(
                                child: Row(
                                  children: [
                                    const Text("HDG12"),
                                    RotatedBox(
                                      quarterTurns: 3,
                                      child: Image.asset(
                                        "assets/chairs/available.png",
                                        color: seats.contains(12)
                                            ? AppColors.kRed
                                            : (table == tableNo && seat == 12)
                                                ? AppColors.kOrange
                                                : AppColors.kEvergreen,
                                        height: 30.r,
                                      ),
                                    ),
                                  ],
                                ),
                                onTap: () {
                                  setState(() {
                                    updateTable(tableNo, 12, "HDG12");
                                  });
                                  setState(() {});
                                },
                              ),
                            ),
                            Positioned(
                              top: 78.h,
                              left: 195.w,
                              child: InkWell(
                                child: Row(
                                  children: [
                                    RotatedBox(
                                      quarterTurns: 1,
                                      child: Image.asset(
                                        "assets/chairs/available.png",
                                        color: seats.contains(13)
                                            ? AppColors.kRed
                                            : (table == tableNo && seat == 13)
                                                ? AppColors.kOrange
                                                : AppColors.kEvergreen,
                                        height: 30.r,
                                      ),
                                    ),
                                    const Text("HDG13"),
                                  ],
                                ),
                                onTap: () {
                                  setState(() {
                                    updateTable(tableNo, 13, "HDG13");
                                  });
                                },
                              ),
                            ),
                            Positioned(
                              top: 20.h,
                              left: 195.w,
                              child: InkWell(
                                child: Row(
                                  children: [
                                    RotatedBox(
                                      quarterTurns: 1,
                                      child: Image.asset(
                                        "assets/chairs/available.png",
                                        color: seats.contains(14)
                                            ? AppColors.kRed
                                            : (table == tableNo && seat == 14)
                                                ? AppColors.kOrange
                                                : AppColors.kEvergreen,
                                        height: 30.r,
                                      ),
                                    ),
                                    const Text("HDG14"),
                                  ],
                                ),
                                onTap: () {
                                  setState(() {
                                    updateTable(tableNo, 14, "HDG14");
                                  });
                                },
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 31.92.h,
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
                              color: AppColors.kEvergreen,
                            ),
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
                            if (tableNo == null || seatNo == null) {
                              return;
                            }
                            if (data["selecteddate"] != null &&
                                data["todate"] != null &&
                                data["fromtime"] != null &&
                                data["totime"] != null) {
                              TableBookingDataSource()
                                  .createBooking(
                                      tableNo: tableNo,
                                      seatNo: seatNo ?? 0,
                                      startDate: data["selecteddate"],
                                      endDate: data["todate"],
                                      floor: _selectedFloor,
                                      fromTime: data["fromtime"],
                                      toTime: data["totime"],
                                      displayname: displayName ?? '')
                                  .then((value) {
                                Get.back();
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
                                          filter: ImageFilter.blur(
                                              sigmaX: 2.5, sigmaY: 2.5),
                                          child: Dialog(
                                            shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(
                                                        20.0)),
                                            child: BookingConfirmedWidget(
                                                data["fromtime"],
                                                data["totime"],
                                                tableNo,
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
                                  Navigator.pop(context);
                                  showSnackBar(
                                      context: context,
                                      message: 'Something went wrong',
                                      bgColor: AppColors.kRed);
                                }
                              });
                            } else {
                              showSnackBar(
                                  context: context,
                                  message: 'Provide start and end time',
                                  bgColor: AppColors.kRed);
                            }
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
    return showDialog(
        context: context,
        builder: (context) {
          return StatefulBuilder(
              builder: (BuildContext context, StateSetter setState) {
            return Center(
              child: Card(
                child: Container(
                  height: MediaQuery.of(context).size.height * 0.55,
                  width: MediaQuery.of(context).size.width * 0.9,
                  padding: EdgeInsets.all(20.r),
                  decoration: const BoxDecoration(
                    color: Colors.white,
                  ),
                  child: Column(
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
                            const Center(
                              child: Image(
                                  image: AssetImage(
                                      "assets/images/verticalRectangle 143.png")),
                            ),
                            Positioned(
                              top: 78.h,
                              left: 40.w,
                              child: InkWell(
                                child: Row(
                                  children: [
                                    const Text("HDS1"),
                                    RotatedBox(
                                      quarterTurns: 3,
                                      child: Image.asset(
                                        "assets/chairs/available.png",
                                        color: seats.contains(1)
                                            ? AppColors.kRed
                                            : (table == tableNo && seat == 1)
                                                ? AppColors.kOrange
                                                : AppColors.kEvergreen,
                                        height: 30.r,
                                      ),
                                    ),
                                  ],
                                ),
                                onTap: () {
                                  setState(() {
                                    updateTable(tableNo, 1, 'HDS1');
                                  });
                                },
                              ),
                            ),
                            Positioned(
                              top: 20.h,
                              left: 40.w,
                              child: InkWell(
                                child: Row(
                                  children: [
                                    const Text("HDS2"),
                                    RotatedBox(
                                      quarterTurns: 3,
                                      child: Image.asset(
                                        "assets/chairs/available.png",
                                        color: seats.contains(16)
                                            ? AppColors.kRed
                                            : (table == tableNo && seat == 2)
                                                ? AppColors.kOrange
                                                : AppColors.kEvergreen,
                                        height: 30.r,
                                      ),
                                    ),
                                  ],
                                ),
                                onTap: () {
                                  setState(() {
                                    updateTable(tableNo, 2, 'HDS2');
                                  });
                                  setState(() {});
                                },
                              ),
                            ),
                            Positioned(
                              top: 78.h,
                              left: 195.w,
                              child: InkWell(
                                child: Row(
                                  children: [
                                    RotatedBox(
                                      quarterTurns: 1,
                                      child: Image.asset(
                                        "assets/chairs/available.png",
                                        color: seats.contains(17)
                                            ? AppColors.kRed
                                            : (table == tableNo && seat == 3)
                                                ? AppColors.kOrange
                                                : AppColors.kEvergreen,
                                        height: 30.r,
                                      ),
                                    ),
                                    const Text("HDS3"),
                                  ],
                                ),
                                onTap: () {
                                  setState(() {
                                    updateTable(tableNo, 3, 'HDS3');
                                  });
                                },
                              ),
                            ),
                            Positioned(
                              top: 20.h,
                              left: 195.w,
                              child: InkWell(
                                child: Row(
                                  children: [
                                    RotatedBox(
                                      quarterTurns: 1,
                                      child: Image.asset(
                                        "assets/chairs/available.png",
                                        color: seats.contains(18)
                                            ? AppColors.kRed
                                            : (table == tableNo && seat == 4)
                                                ? AppColors.kOrange
                                                : AppColors.kEvergreen,
                                        height: 30.r,
                                      ),
                                    ),
                                    const Text("HDS4"),
                                  ],
                                ),
                                onTap: () {
                                  setState(() {
                                    updateTable(tableNo, 4, 'HDS4');
                                  });
                                },
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 31.92.h,
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
                              color: AppColors.kEvergreen,
                            ),
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
                            if (tableNo == null || seatNo == null) {
                              return;
                            }
                            if (data["selecteddate"] != null &&
                                data["todate"] != null &&
                                data["fromtime"] != null &&
                                data["totime"] != null) {
                              TableBookingDataSource()
                                  .createBooking(
                                      tableNo: tableNo,
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
                                          filter: ImageFilter.blur(
                                              sigmaX: 2.5, sigmaY: 2.5),
                                          child: Dialog(
                                            shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(
                                                        20.0)),
                                            child: BookingConfirmedWidget(
                                                data["fromtime"],
                                                data["totime"],
                                                tableNo,
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
                                  Navigator.pop(context);
                                }
                              });
                            } else {
                              showSnackBar(
                                  context: context,
                                  message: 'Provide start and end time',
                                  bgColor: AppColors.kRed);
                            }
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
    return showDialog(
        context: context,
        builder: (context) {
          return StatefulBuilder(
              builder: (BuildContext context, StateSetter setState) {
            return Center(
              child: Card(
                child: Container(
                  height: MediaQuery.of(context).size.height * 0.55,
                  width: MediaQuery.of(context).size.width * 0.9,
                  padding: EdgeInsets.all(20.r),
                  decoration: const BoxDecoration(
                    color: Colors.white,
                  ),
                  child: Column(
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
                                  'assets/table/horizontalrectangle.svg',
                                  height: 80.h,
                                  width: 400.w),
                            )),
                            Positioned(
                              top: 110.h,
                              left: 60.w,
                              child: InkWell(
                                child: Row(
                                  children: [
                                    const Text("HDP9"),
                                    RotatedBox(
                                      quarterTurns: 2,
                                      child: Image.asset(
                                        "assets/chairs/available.png",
                                        color: seats.contains(19)
                                            ? AppColors.kRed
                                            : (table == tableNo && seat == 19)
                                                ? AppColors.kOrange
                                                : AppColors.kEvergreen,
                                        height: 30.r,
                                      ),
                                    ),
                                  ],
                                ),
                                onTap: () {
                                  setState(() {
                                    updateTable(tableNo, 19, 'HDP9');
                                  });
                                },
                              ),
                            ),
                            Positioned(
                              top: 0.h,
                              left: 50.w,
                              child: InkWell(
                                child: Row(
                                  children: [
                                    const Text("HDP10"),
                                    RotatedBox(
                                      quarterTurns: 4,
                                      child: Image.asset(
                                        "assets/chairs/available.png",
                                        color: seats.contains(20)
                                            ? AppColors.kRed
                                            : (table == tableNo && seat == 20)
                                                ? AppColors.kOrange
                                                : AppColors.kEvergreen,
                                        height: 30.r,
                                      ),
                                    ),
                                  ],
                                ),
                                onTap: () {
                                  setState(() {
                                    updateTable(tableNo, 20, 'HDP10');
                                  });
                                  setState(() {});
                                },
                              ),
                            ),
                            Positioned(
                              top: 110.h,
                              left: 185.w,
                              child: InkWell(
                                child: Row(
                                  children: [
                                    RotatedBox(
                                      quarterTurns: 2,
                                      child: Image.asset(
                                        "assets/chairs/available.png",
                                        color: seats.contains(21)
                                            ? AppColors.kRed
                                            : (table == tableNo && seat == 21)
                                                ? AppColors.kOrange
                                                : AppColors.kEvergreen,
                                        height: 30.r,
                                      ),
                                    ),
                                    const Text("HDP11"),
                                  ],
                                ),
                                onTap: () {
                                  setState(() {
                                    updateTable(tableNo, 21, 'HDP11');
                                  });
                                },
                              ),
                            ),
                            Positioned(
                              top: 0.h,
                              left: 185.w,
                              child: InkWell(
                                child: Row(
                                  children: [
                                    RotatedBox(
                                      quarterTurns: 4,
                                      child: Image.asset(
                                        "assets/chairs/available.png",
                                        color: seats.contains(22)
                                            ? AppColors.kRed
                                            : (table == tableNo && seat == 22)
                                                ? AppColors.kOrange
                                                : AppColors.kEvergreen,
                                        height: 30.r,
                                      ),
                                    ),
                                    const Text("HDP12"),
                                  ],
                                ),
                                onTap: () {
                                  setState(() {
                                    updateTable(tableNo, 22, 'HDP12');
                                  });
                                },
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 31.92.h,
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
                              color: AppColors.kEvergreen,
                            ),
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
                            if (tableNo == null || seatNo == null) {
                              return;
                            }
                            if (data["selecteddate"] != null &&
                                data["todate"] != null &&
                                data["fromtime"] != null &&
                                data["totime"] != null) {
                              TableBookingDataSource()
                                  .createBooking(
                                      tableNo: tableNo,
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
                                          filter: ImageFilter.blur(
                                              sigmaX: 2.5, sigmaY: 2.5),
                                          child: Dialog(
                                            shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(
                                                        20.0)),
                                            child: BookingConfirmedWidget(
                                                data["fromtime"],
                                                data["totime"],
                                                tableNo,
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
                                  Navigator.pop(context);
                                }
                              });
                            } else {
                              showSnackBar(
                                  context: context,
                                  message: 'Provide start and end time',
                                  bgColor: AppColors.kRed);
                            }
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
    return showDialog(
        context: context,
        builder: (context) {
          return StatefulBuilder(
              builder: (BuildContext context, StateSetter setState) {
            return Center(
              child: Card(
                child: Container(
                  height: MediaQuery.of(context).size.height * 0.55,
                  width: MediaQuery.of(context).size.width * 0.9,
                  padding: EdgeInsets.all(20.r),
                  decoration: const BoxDecoration(
                    color: Colors.white,
                  ),
                  child: Column(
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
                                  'assets/table/horizontalrectangle.svg',
                                  height: 80.h,
                                  width: 400.w),
                            )),
                            Positioned(
                              top: 110.h,
                              left: 60.w,
                              child: InkWell(
                                child: Row(
                                  children: [
                                    const Text("HDP5"),
                                    RotatedBox(
                                      quarterTurns: 2,
                                      child: Image.asset(
                                        "assets/chairs/available.png",
                                        color: seats.contains(23)
                                            ? AppColors.kRed
                                            : (table == tableNo && seat == 23)
                                                ? AppColors.kOrange
                                                : AppColors.kEvergreen,
                                        height: 30.r,
                                      ),
                                    ),
                                  ],
                                ),
                                onTap: () {
                                  setState(() {
                                    updateTable(tableNo, 23, 'HDP5');
                                  });
                                },
                              ),
                            ),
                            Positioned(
                              top: 0.h,
                              left: 50.w,
                              child: InkWell(
                                child: Row(
                                  children: [
                                    const Text("HDP6"),
                                    RotatedBox(
                                      quarterTurns: 4,
                                      child: Image.asset(
                                        "assets/chairs/available.png",
                                        color: seats.contains(24)
                                            ? AppColors.kRed
                                            : (table == tableNo && seat == 24)
                                                ? AppColors.kOrange
                                                : AppColors.kEvergreen,
                                        height: 30.r,
                                      ),
                                    ),
                                  ],
                                ),
                                onTap: () {
                                  setState(() {
                                    updateTable(tableNo, 24, 'HDP6');
                                  });
                                  setState(() {});
                                },
                              ),
                            ),
                            Positioned(
                              top: 110.h,
                              left: 185.w,
                              child: InkWell(
                                child: Row(
                                  children: [
                                    RotatedBox(
                                      quarterTurns: 2,
                                      child: Image.asset(
                                        "assets/chairs/available.png",
                                        color: seats.contains(25)
                                            ? AppColors.kRed
                                            : (table == tableNo && seat == 25)
                                                ? AppColors.kOrange
                                                : AppColors.kEvergreen,
                                        height: 30.r,
                                      ),
                                    ),
                                    const Text("HDP7"),
                                  ],
                                ),
                                onTap: () {
                                  setState(() {
                                    updateTable(tableNo, 25, 'HDP7');
                                  });
                                },
                              ),
                            ),
                            Positioned(
                              top: 0.h,
                              left: 185.w,
                              child: InkWell(
                                child: Row(
                                  children: [
                                    RotatedBox(
                                      quarterTurns: 4,
                                      child: Image.asset(
                                        "assets/chairs/available.png",
                                        color: seats.contains(26)
                                            ? AppColors.kRed
                                            : (table == tableNo && seat == 26)
                                                ? AppColors.kOrange
                                                : AppColors.kEvergreen,
                                        height: 30.r,
                                      ),
                                    ),
                                    const Text("HDP8"),
                                  ],
                                ),
                                onTap: () {
                                  setState(() {
                                    updateTable(tableNo, 26, 'HDP8');
                                  });
                                },
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 31.92.h,
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
                              color: AppColors.kEvergreen,
                            ),
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
                            if (tableNo == null || seatNo == null) {
                              return;
                            }
                            if (data["selecteddate"] != null &&
                                data["todate"] != null &&
                                data["fromtime"] != null &&
                                data["totime"] != null) {
                              TableBookingDataSource()
                                  .createBooking(
                                      tableNo: tableNo,
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
                                          filter: ImageFilter.blur(
                                              sigmaX: 2.5, sigmaY: 2.5),
                                          child: Dialog(
                                            shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(
                                                        20.0)),
                                            child: BookingConfirmedWidget(
                                                data["fromtime"],
                                                data["totime"],
                                                tableNo,
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
                                  Navigator.pop(context);
                                }
                              });
                            } else {
                              showSnackBar(
                                  context: context,
                                  message: 'Provide start and end time',
                                  bgColor: AppColors.kRed);
                            }
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
}
