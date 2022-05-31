import 'dart:convert';
import 'dart:io';
import 'dart:ui';

import 'package:event_bus/event_bus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hot_desking/core/app_colors.dart';
import 'package:hot_desking/core/app_helpers.dart';
import 'package:hot_desking/core/app_theme.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

import '../../../../core/app_urls.dart';
import '../../../floors/level14/level14_layout.dart';
import '../../../floors/level3/level_3_layout.dart';

class HotDeskingScreen extends StatefulWidget {
  const HotDeskingScreen({Key? key}) : super(key: key);

  @override
  State<HotDeskingScreen> createState() => _HotDeskingScreenState();
}

class _HotDeskingScreenState extends State<HotDeskingScreen> {
  List<String> _floorsList = [
    'Floor 3',
    'Floor 14',
  ];

  String _selectedFloor = 'Floor 3';
  int? tableNo, seatNo;

  @override
  void initState() {
    super.initState();
    // eventBus.on<HotDeskingInitialEvent>().listen((event) {
    //   callAPI();
    //   Get.offAllNamed('/root');

    //   // Get.back(closeOverlays: true);
    //   // setState(() {});
    // });
    callAPI();
  }

  callAPI() async {
    var inputDate = DateTime.parse(DateTime.now().toString());
    var outputFormat = DateFormat('dd-MM-yyyy');
    var outputDate = outputFormat.format(inputDate);
    var client = http.Client();
    try {
      var response =
          await client.post(Uri.parse(AppUrl.tableBookedByFloorDateTime),
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
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.kGreyBackground,
      appBar: AppTheme.appBar('Book Desk', context),
      body: SingleChildScrollView(
        // controller: controller,
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 20.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: EdgeInsets.symmetric(vertical: 20.h),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    chairInfo(
                        status: 'Available',
                        imageFile: 'assets/chairs/available.png',
                        color: AppColors.kEvergreen),
                    chairInfo(
                        status: 'Booked',
                        imageFile: 'assets/chairs/booked.png',
                        color: AppColors.kRed),
                    chairInfo(
                        status: 'Selected',
                        imageFile: 'assets/chairs/selected.png',
                        color: AppColors.kOrange),
                    // chairInfo(
                    //     status: 'Available Soon',
                    //     imageFile: 'assets/chairs/available_soon.png',
                    //     color: Colors.grey),
                  ],
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    height: 34.h,
                    width: 152.w,
                    padding:
                        const EdgeInsets.symmetric(vertical: 6, horizontal: 14),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: Colors.white,
                    ),
                    child: DropdownButtonHideUnderline(
                      child: DropdownButton(
                          value: _selectedFloor,
                          style: TextStyle(
                              fontSize: 18.sp,
                              fontWeight: FontWeight.w600,
                              color: Colors.black.withOpacity(0.5)),
                          hint: const Text('Floor'),
                          isExpanded: true,
                          iconEnabledColor: Colors.black.withOpacity(0.5),
                          items: _floorsList.map((String value) {
                            return DropdownMenuItem<String>(
                              value: value,
                              child: Text(
                                value.toString(),
                              ),
                            );
                          }).toList(),
                          onChanged: (String? val) {
                            setState(() {
                              _selectedFloor = val!;
                            });
                          }),
                    ),
                  ),
                  // Text(
                  //     '${AppHelpers.formatDate(widget.date)} ${AppHelpers.formatTime(widget.time)}')
                ],
              ),
              SizedBox(
                height: 29.h,
              ),
              Text(
                '$_selectedFloor',
                style: AppTheme.black500TextStyle(18),
              ),
              _selectedFloor == 'Floor 14'
                  ? Level14Layout(
                      selectedTable: (s) {
                        setState(() {
                          if (s != null) {
                            tableNo = s.tableNo;
                            seatNo = s.seats[0].seatNo;
                          }
                        });
                      },
                    )
                  : Level3Layout(
                      _selectedFloor,
                      selectedTable: (s) {
                        setState(() {
                          if (s != null) {
                            tableNo = s.tableNo;
                            seatNo = s.seats[0].seatNo;
                          }
                        });
                      },
                    ),
            ],
          ),
        ),
      ),
    );
  }

  Row chairInfo(
      {required String status,
      required String imageFile,
      required Color color}) {
    return Row(
      children: [
        Image.asset(
          imageFile,
          height: 24,
          color: color,
        ),
        SizedBox(
          width: 4.w,
        ),
        Text(
          status,
          style: AppTheme.black500TextStyle(12),
        )
      ],
    );
  }
}

class HotDeskingInitialEvent {}

EventBus eventBus = EventBus();
