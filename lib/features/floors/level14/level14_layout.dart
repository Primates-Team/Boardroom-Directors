import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
// import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hot_desking/core/app_colors.dart';
import 'package:hot_desking/core/app_helpers.dart';
import 'package:hot_desking/core/widgets/show_snackbar.dart';
import 'package:hot_desking/features/booking/data/models/table_model.dart';
import 'package:hot_desking/features/booking/widgets/time_slot_dialog.dart';

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
  late Map<int, List<int>> bookedTables;

  List<Map<int, int>> tableData = bookingController.tableData;
  String _selectedFloor = 'Floor 14';
  Map<int, List<int>> modifiedTables = {};

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
    return SizedBox(
      height: height,
      width: width,
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Stack(
          children: [
            RotatedBox(
                quarterTurns: 4,
                child: Image.asset("assets/level14/Frame 15.png")
                // SvgPicture.asset(
                //   'assets/Svg_images/Frame-4.svg',
                //   height: 1000.h,
                //   width: width,
                // ),
                ),
            Positioned(
                top: 60.h,
                left: 250.w,
                child: InkWell(
                  child: Image.asset('assets/chairs/Group 493.png',
                      width: 100.w, height: 100.h, fit: BoxFit.fitWidth),
                  onTap: () {
                    showTabledetails(1, bookedTables[1] ?? []);
                  },
                )),
            Positioned(
                top: 60.h,
                left: 350.w,
                child: InkWell(
                  child: Image.asset('assets/chairs/Group 493.png',
                      width: 100.w, height: 100.h, fit: BoxFit.fitWidth),
                  onTap: () {
                    showTabledetails(2, bookedTables[2] ?? []);
                  },
                )),
            Positioned(
                top: 60.h,
                left: 460.w,
                child: InkWell(
                  child: RotatedBox(
                    quarterTurns: 3,
                    child: Image.asset('assets/chairs/Group 497.png',
                        width: 80.w, height: 80.h, fit: BoxFit.fitWidth),
                  ),
                  onTap: () {
                    showTabledetails(3, bookedTables[3] ?? []);
                  },
                )),
            Positioned(
                top: 60.h,
                left: 550.w,
                child: InkWell(
                  child: RotatedBox(
                    quarterTurns: 3,
                    child: Image.asset('assets/chairs/Group 497.png',
                        width: 80.w, height: 80.h, fit: BoxFit.fitWidth),
                  ),
                  onTap: () {
                    showTabledetails(4, bookedTables[4] ?? []);
                  },
                )),
            Positioned(
                top: 60.h,
                left: 635.w,
                child: InkWell(
                  child: Image.asset('assets/chairs/Group 495.png',
                      width: 100.w, height: 100.h, fit: BoxFit.fitWidth),
                  onTap: () {
                    showTabledetails(5, bookedTables[5] ?? []);
                  },
                )),
            Positioned(
                top: 60.h,
                left: 730.w,
                child: InkWell(
                  child: Image.asset('assets/chairs/Group 495.png',
                      width: 100.w, height: 100.h, fit: BoxFit.fitWidth),
                  onTap: () {
                    showTabledetails(6, bookedTables[6] ?? []);
                  },
                )),
          ],
        ),
      ),
    );
  }

  showTabledetails(int tableNo, List<int> seats) async {
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
                                child: Image.asset(
                                    'assets/level3/Rectangle 146.png',
                                    height: 50.h,
                                    width: 400.w)

                                // Image(
                                //     image: AssetImage(
                                //         "assets/chairs/table.png",)),
                                ),

                            //

                            //
                            Positioned(
                              top: 94.h,
                              left: 80.w,
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
                                    Text('1')
                                  ],
                                ),
                                onTap: () {
                                  setState(() {
                                    updateTable(tableNo, 1);
                                  });
                                },
                              ),
                            ),

                            Positioned(
                              // top: 1.h,
                              left: 80.w,
                              child: InkWell(
                                child: Column(
                                  children: [
                                    Text('2'),
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
                                    updateTable(tableNo, 2);
                                  });
                                },
                              ),
                            ),

                            Positioned(
                              //   top: 10.h,
                              left: 139.w,
                              child: InkWell(
                                child: Column(
                                  children: [
                                    Text('3'),
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
                                onTap: () {
                                  setState(() {
                                    updateTable(tableNo, 3);
                                  });
                                },
                              ),
                            ),

                            Positioned(
                              //   top: 10.h,
                              left: 200.w,
                              child: InkWell(
                                child: Column(
                                  children: [
                                    Text('4'),
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
                                onTap: () {
                                  setState(() {
                                    updateTable(tableNo, 4);
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
                              top: 94.h,
                              left: 200.w,
                              child: InkWell(
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
                                    Text('5'),
                                  ],
                                ),
                                onTap: () {
                                  setState(() {
                                    updateTable(tableNo, 5);
                                  });
                                },
                              ),
                            ),
                            Positioned(
                              top: 94.h,
                              left: 139.w,
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
                                    Text('6'),
                                  ],
                                ),
                                onTap: () {
                                  setState(() {
                                    updateTable(tableNo, 6);
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
                      // Row(
                      //   children: [
                      //     Container(
                      //       height: 15.61,
                      //       width: 31.21,
                      //       margin: const EdgeInsets.only(
                      //         left: 53.69,
                      //       ),
                      //       decoration: BoxDecoration(
                      //         borderRadius: BorderRadius.circular(10),
                      //         color: Colors.grey,
                      //       ),
                      //     ),
                      //     Container(
                      //       margin: const EdgeInsets.only(
                      //         left: 18.73,
                      //       ),
                      //       child: Text(
                      //         "Available Soon",
                      //         style: GoogleFonts.lato(
                      //           textStyle: const TextStyle(
                      //               fontSize: 10, fontWeight: FontWeight.w500),
                      //         ),
                      //       ),
                      //     ),
                      //   ],
                      // ),
                      // const SizedBox(
                      //   height: 15.61,
                      // ),
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
                            if (tableNo != null && seatNo != null) {
                              Get.back();
                              showDialog(
                                  context: context,
                                  builder: (context) {
                                    return BackdropFilter(
                                      filter: ImageFilter.blur(
                                          sigmaX: 2.5, sigmaY: 2.5),
                                      child: Dialog(
                                        shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(20.0)),
                                        child: TimeSlotDialog(
                                          tableNo: tableNo,
                                          seatNo: seatNo!,
                                          date: DateTime.now(),
                                          startTime: TimeOfDay.now(),
                                          floor: _selectedFloor,
                                        ),
                                      ),
                                    );
                                  });
                            } else {
                              showSnackBar(
                                  context: context, message: 'Select Seat');
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

  showTabledetails1(int tableNo, List<int> seats) async {
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
                      // ignore: sized_box_for_whitespace
                      Container(
                        height: MediaQuery.of(context).size.height * 0.16,
                        width: MediaQuery.of(context).size.width,
                        // color: Colors.lightBlue,
                        // margin: const EdgeInsets.only(
                        //     top: 34.32, left: 48.41, right: 48.41),
                        child: Stack(
                          children: [
                            Center(
                                child: Image.asset(
                              'assets/level3/Rectangle 146.png',
                            )

                                // Image(
                                //     image: AssetImage(
                                //         "assets/chairs/table.png",)),
                                ),
                            Positioned(
                              top: 10.h,
                              left: 80.w,
                              child: InkWell(
                                child: RotatedBox(
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
                                onTap: () => updateTable(tableNo, 1),
                              ),
                            ),
                            Positioned(
                              top: 10.h,
                              left: 139.w,
                              child: InkWell(
                                child: RotatedBox(
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
                                onTap: () => updateTable(tableNo, 2),
                              ),
                            ),
                            Positioned(
                              top: 100.h,
                              left: 80.w,
                              child: InkWell(
                                child: RotatedBox(
                                  quarterTurns: 2,
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
                                onTap: () => updateTable(tableNo, 3),
                              ),
                            ),
                            // Positioned(
                            //   top: 60.h,
                            //   left: 15.w,
                            //   child: InkWell(
                            //     child: RotatedBox(
                            //       quarterTurns: 3,
                            //       child: Image.asset(
                            //         "assets/chairs/available.png",
                            //         color: seats.contains(7)
                            //             ? AppColors.kRed
                            //             : (table == tableNo && seat == 7)
                            //                 ? AppColors.kOrange
                            //                 : AppColors.kEvergreen,
                            //         height: 22.r,
                            //       ),
                            //     ),
                            //     onTap: () => selectTable(tableNo, 7),
                            //   ),
                            // ),
                            // Positioned(
                            //   top: 60.h,
                            //   right: 19.w,
                            //   child: InkWell(
                            //     child: RotatedBox(
                            //       quarterTurns: 1,
                            //       child: Image.asset(
                            //         "assets/chairs/available.png",
                            //         color: seats.contains(4)
                            //             ? AppColors.kRed
                            //             : (table == tableNo && seat == 4)
                            //                 ? AppColors.kOrange
                            //                 : AppColors.kEvergreen,
                            //         height: 22.r,
                            //       ),
                            //     ),
                            //     onTap: () => selectTable(tableNo, 4),
                            //   ),
                            // ),
                            Positioned(
                              top: 10.h,
                              left: 200.w,
                              child: InkWell(
                                child: RotatedBox(
                                  quarterTurns: 4,
                                  child:
                                      Image.asset("assets/chairs/available.png",
                                          color: seats.contains(5)
                                              ? AppColors.kRed
                                              : (table == tableNo && seat == 5)
                                                  ? AppColors.kOrange
                                                  : AppColors.kEvergreen,
                                          height: 22.r),
                                ),
                                onTap: () => updateTable(tableNo, 5),
                              ),
                            ),
                            Positioned(
                              top: 100.h,
                              left: 139.w,
                              child: InkWell(
                                child: RotatedBox(
                                  quarterTurns: 2,
                                  child:
                                      Image.asset("assets/chairs/available.png",
                                          color: seats.contains(5)
                                              ? AppColors.kRed
                                              : (table == tableNo && seat == 5)
                                                  ? AppColors.kOrange
                                                  : AppColors.kEvergreen,
                                          height: 22.r),
                                ),
                                onTap: () => updateTable(tableNo, 5),
                              ),
                            ),
                            Positioned(
                              top: 100.h,
                              left: 200.w,
                              child: InkWell(
                                child: RotatedBox(
                                  quarterTurns: 2,
                                  child:
                                      Image.asset("assets/chairs/available.png",
                                          color: seats.contains(6)
                                              ? AppColors.kRed
                                              : (table == tableNo && seat == 6)
                                                  ? AppColors.kOrange
                                                  : AppColors.kEvergreen,
                                          height: 22.r),
                                ),
                                onTap: () => updateTable(tableNo, 6),
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
                              color: Colors.grey,
                            ),
                          ),
                          Container(
                            margin: const EdgeInsets.only(
                              left: 18.73,
                            ),
                            child: Text(
                              "Available Soon",
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
                            if (tableNo != null && seatNo != null) {
                              showDialog(
                                  context: context,
                                  builder: (context) {
                                    return BackdropFilter(
                                      filter: ImageFilter.blur(
                                          sigmaX: 2.5, sigmaY: 2.5),
                                      child: Dialog(
                                        shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(20.0)),
                                        child: TimeSlotDialog(
                                          tableNo: tableNo,
                                          seatNo: seatNo!,
                                          date: DateTime.now(),
                                          startTime: TimeOfDay.now(),
                                          floor: _selectedFloor,
                                        ),
                                      ),
                                    );
                                  });
                            } else {
                              showSnackBar(
                                  context: context, message: 'Select Seat');
                            }
                          },
                          child: const Text('Next Screen'),
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
              onTap: () => updateTable(tableNo, 2),
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
              onTap: () => updateTable(tableNo, 3),
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
              onTap: () => updateTable(tableNo, 1),
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
              onTap: () => updateTable(tableNo, 4),
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
                onTap: () => updateTable(tableNo, 6),
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
                onTap: () => updateTable(tableNo, 1),
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
                onTap: () => updateTable(tableNo, 4),
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
                onTap: () => updateTable(tableNo, 3),
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
                onTap: () => updateTable(tableNo, 5),
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
                onTap: () => updateTable(tableNo, 2),
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
                onTap: () => updateTable(tableNo, 6),
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
                onTap: () => updateTable(tableNo, 1),
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
                onTap: () => updateTable(tableNo, 4),
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
                onTap: () => updateTable(tableNo, 3),
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
                onTap: () => updateTable(tableNo, 5),
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
                onTap: () => updateTable(tableNo, 2),
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
                onTap: () => updateTable(tableNo, 6),
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
                onTap: () => updateTable(tableNo, 1),
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
                onTap: () => updateTable(tableNo, 4),
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
                onTap: () => updateTable(tableNo, 3),
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
                onTap: () => updateTable(tableNo, 5),
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
                onTap: () => updateTable(tableNo, 2),
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
                onTap: () => updateTable(tableNo, 6),
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
                onTap: () => updateTable(tableNo, 1),
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
                onTap: () => updateTable(tableNo, 4),
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
                onTap: () => updateTable(tableNo, 3),
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
                onTap: () => updateTable(tableNo, 5),
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
                onTap: () => updateTable(tableNo, 2),
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

  void updateTable(int tableNo, int seatNo) {
    setState(() {
      this.tableNo = tableNo;
      this.seatNo = seatNo;
      selectTable(tableNo, seatNo);
    });
  }
}
