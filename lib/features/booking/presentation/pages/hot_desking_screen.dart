import 'dart:ui';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hot_desking/core/app_colors.dart';
import 'package:hot_desking/core/app_theme.dart';
import 'package:hot_desking/core/widgets/show_snackbar.dart';
import 'package:hot_desking/features/floors/level14/level14_layout.dart';
import 'package:hot_desking/features/floors/level3/level_3_layout.dart';
import 'package:hot_desking/features/booking/widgets/time_slot_dialog.dart';

import '../../../../core/app_urls.dart';

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
    callAPI();
  }


  callAPI() async {
    var client = http.Client();
    try {
      var response = await client.post(Uri.parse(AppUrl.tableBookedByFloor),body: {
        "selecteddate":"${DateTime.now().day}-${DateTime.now().month}-${DateTime.now().year}",
        "floor":_selectedFloor
      });

      print(response.body);
    } catch (e) {

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
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    chairInfo(
                        status: 'Avaiable',
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
                    chairInfo(
                        status: 'Avaiable Soon',
                        imageFile: 'assets/chairs/available_soon.png',
                        color: Colors.grey),
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
                        if (s != null) {
                          tableNo = s.tableNo;
                          seatNo = s.seats[0].seatNo;
                        }
                      },
                    )
                  : Level3Layout(
                      selectedTable: (s) {
                        if (s != null) {
                          tableNo = s.tableNo;
                          seatNo = s.seats[0].seatNo;
                        }
                      },
                    ),
              Center(
                child: ElevatedButton(
                  style: ButtonStyle(
                      backgroundColor:
                          MaterialStateProperty.all(AppColors.kAubergine)),
                  onPressed: () {
                    if (tableNo != null && seatNo != null) {
                      showDialog(
                          context: context,
                          builder: (context) {
                            return BackdropFilter(
                              filter:
                                  ImageFilter.blur(sigmaX: 2.5, sigmaY: 2.5),
                              child: Dialog(
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(20.0)),
                                child: TimeSlotDialog(
                                  tableNo: tableNo!,
                                  seatNo: seatNo!,
                                  date: DateTime.now(),
                                  startTime: TimeOfDay.now(),
                                ),
                              ),
                            );
                          });
                    } else {
                      showSnackBar(context: context, message: 'Select Seat');
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
