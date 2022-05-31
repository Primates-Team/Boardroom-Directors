import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:hot_desking/core/app_helpers.dart';
import 'package:hot_desking/core/app_theme.dart';
import 'package:hot_desking/core/widgets/show_snackbar.dart';
import 'package:hot_desking/features/booking/data/datasource/table_booking_datasource.dart';

import '../../../core/app_colors.dart';
import '../presentation/pages/hot_desking_screen.dart';
import 'booking_confirmed_dialog.dart';
import 'confirm_button.dart';

class TimeSlotDialog extends StatefulWidget {
  final int tableNo;
  final int seatNo;
  final DateTime date;
  final TimeOfDay startTime;
  final String floor;
  const TimeSlotDialog(
      {Key? key,
      required this.date,
      required this.startTime,
      required this.tableNo,
      required this.seatNo,
      required this.floor})
      : super(key: key);

  @override
  State<TimeSlotDialog> createState() => _TimeSlotDialogState();
}

class _TimeSlotDialogState extends State<TimeSlotDialog> {
  DateTime? startdate = DateTime.now();
  DateTime? endDate = DateTime.now();

  Widget textWidget(String title) {
    return SizedBox(
      height: 37.h,
      child: Center(
        child: Text(
          title,
          style: AppTheme.labelTextStyle,
        ),
      ),
    );
  }

  TimeOfDay? startTime, endTime;
  @override
  void initState() {
    startdate = widget.date;
    startTime = widget.startTime;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 300.h,
      width: 326.w,
      padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 15.h),
      decoration: AppTheme.boxDecoration,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          // Text(
          //   'Table 1',
          //   style: AppTheme.labelTextStyle,
          // ),
          SizedBox(
            height: 19.h,
          ),
          Row(
            children: [
              Expanded(
                flex: 1,
                child: Column(
                  children: [
                    textWidget('Start Date'),
                    textWidget('End Date'),
                    textWidget('Start'),
                    textWidget('End'),
                  ],
                ),
              ),
              Expanded(
                flex: 2,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      height: 27.h,
                      width: 157.w,
                      margin: EdgeInsets.symmetric(vertical: 4.5.h),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: InkWell(
                          onTap: () {
                            showDatePicker(
                                    context: context,
                                    initialDate: widget.date,
                                    firstDate: DateTime.now(),
                                    lastDate: DateTime.now()
                                        .add(const Duration(days: 90)))
                                .then((value) {
                              if (value == null) return;
                              setState(() {
                                startdate = value;
                                endDate = null;
                              });
                            });
                          },
                          child: Center(
                            child: Text(
                              startdate != null
                                  ? AppHelpers.formatDate(startdate!)
                                  : '',
                              style: AppTheme.hintTextStyle,
                            ),
                          )),
                    ),
                    Container(
                      height: 27.h,
                      width: 157.w,
                      margin: EdgeInsets.symmetric(vertical: 4.5.h),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: InkWell(
                          onTap: () {
                            if (startdate != null) {
                              showDatePicker(
                                      context: context,
                                      initialDate: startdate!,
                                      firstDate: startdate!,
                                      lastDate: startdate!
                                          .add(const Duration(days: 90)))
                                  .then((value) {
                                if (value == null) return;
                                setState(() {
                                  endDate = value;
                                });
                              });
                            } else {
                              showSnackBar(
                                  context: context,
                                  message: "Select Start Date");
                            }
                          },
                          child: Center(
                            child: Text(
                              endDate != null
                                  ? AppHelpers.formatDate(endDate!)
                                  : '',
                              style: AppTheme.hintTextStyle,
                            ),
                          )),
                    ),

                    // Container(
                    //   height: 27.h,
                    //   width: 157.w,
                    //   margin: EdgeInsets.symmetric(vertical: 4.5.h),
                    //   decoration: BoxDecoration(
                    //     color: Colors.white,
                    //     borderRadius: BorderRadius.circular(10),
                    //   ),
                    //   child: Center(
                    //     child: Text(
                    //       AppHelpers.formatTime(widget.startTime),
                    //       style: AppTheme.hintTextStyle,
                    //     ),
                    //   ),
                    // ),
                    Container(
                      height: 27.h,
                      width: 157.w,
                      margin: EdgeInsets.symmetric(vertical: 4.5.h),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: InkWell(
                        onTap: () {
                          AppHelpers.showCupertinoTimePicker(context, (value) {
                            ScaffoldMessenger.of(context).hideCurrentSnackBar();
                            ScaffoldMessenger.of(context).clearSnackBars();
                            if (startdate?.day == DateTime.now().day) {
                              if (value.isBefore(DateTime.now())) {
                                showSnackBar(
                                    context: context,
                                    message: "Can't Select the date",
                                    bgColor: Colors.red);
                              } else {
                                if (value.isBefore(DateTime.now())) {
                                  showSnackBar(
                                      context: context,
                                      message: "Can't Select the date",
                                      bgColor: Colors.red);
                                } else {
                                  setState(() {
                                    startTime = TimeOfDay.fromDateTime(value);
                                  });
                                }
                              }
                            } else {
                              setState(() {
                                startTime = TimeOfDay.fromDateTime(value);
                              });
                            }
                          }, startdate ?? DateTime.now());
                        },
                        child: Center(
                          child: Text(
                            startTime != null
                                ? AppHelpers.formatTime(startTime!)
                                : 'Select Start Time',
                            style: AppTheme.hintTextStyle,
                          ),
                        ),
                      ),
                    ),
                    Container(
                      height: 27.h,
                      width: 157.w,
                      margin: EdgeInsets.symmetric(vertical: 4.5.h),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: InkWell(
                        onTap: () {
                          AppHelpers.showCupertinoTimePicker(context, (value) {
                            ScaffoldMessenger.of(context).hideCurrentSnackBar();
                            ScaffoldMessenger.of(context).clearSnackBars();
                            if (startTime == null) return;

                            DateTime starttTime = DateTime(
                              value.year,
                              value.month,
                              value.day,
                              startTime!.hour,
                              startTime!.minute,
                            );

                            DateTime enddTime = DateTime(
                              value.year,
                              value.month,
                              value.day,
                              value.hour,
                              value.minute,
                            );

                            if (enddTime.isBefore(starttTime)) {
                              showSnackBar(
                                  context: context,
                                  message: "Can't Select the date");
                            } else {
                              setState(() {
                                if (value == null) return;
                                setState(() {
                                  // _formattedEndTime = AppHelpers.formatTime(
                                  //     TimeOfDay.fromDateTime(value));

                                  endTime = TimeOfDay.fromDateTime(value);
                                });
                              });
                            }

                            if (value.hour <= startTime!.hour &&
                                value.minute <= startTime!.minute) {
                              showSnackBar(
                                  context: context,
                                  message: "Can't Select the date",
                                  bgColor: Colors.red);
                            } else {
                              setState(() {
                                if (value == null) return;
                                setState(() {
                                  endTime = TimeOfDay.fromDateTime(value);
                                });
                              });
                            }
                          },
                              DateTime(
                                  startdate?.year ?? 0,
                                  startdate?.month ?? 0,
                                  startdate?.day ?? 0,
                                  startTime?.hour ?? 0,
                                  startTime?.minute ?? 0),
                              isEnddate: true);

                          // showTimePicker(
                          //   context: context,
                          //   initialTime: startTime!,
                          //   initialEntryMode: TimePickerEntryMode.input,
                          // ).then((value) {
                          //   if (value == null) return;
                          //   setState(() {
                          //     endTime = value;
                          //   });
                          // });
                        },
                        child: Center(
                          child: Text(
                            endTime != null
                                ? AppHelpers.formatTime(endTime!)
                                : 'Select End Time',
                            style: AppTheme.hintTextStyle,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          SizedBox(
            height: 20.h,
          ),
          Center(
            child: InkWell(
              onTap: () async {
                if (widget.tableNo == null || widget.seatNo == null) {
                  return;
                }
                if (startdate != null &&
                    endDate != null &&
                    startTime != null &&
                    endTime != null) {
                  TableBookingDataSource()
                      .createBooking(
                    tableNo: widget.tableNo,
                    seatNo: widget.seatNo,
                    startDate: startdate != null
                        ? AppHelpers.formatDate(startdate!)
                        : AppHelpers.formatDate(DateTime.now()),
                    endDate: endDate != null
                        ? AppHelpers.formatDate(endDate!)
                        : AppHelpers.formatDate(DateTime.now()),
                    floor: widget.floor,
                    fromTime: AppHelpers.formatTime(startTime!),
                    toTime: AppHelpers.formatTime(endTime!),
                  )
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
                              filter:
                                  ImageFilter.blur(sigmaX: 2.5, sigmaY: 2.5),
                              child: Dialog(
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(20.0)),
                                child: BookingConfirmedWidget(
                                    AppHelpers.formatTime(startTime!),
                                    AppHelpers.formatTime(endTime!),
                                    widget.tableNo,
                                    widget.seatNo,
                                    AppHelpers.formatDate(startdate != null
                                        ? startdate!
                                        : DateTime.now()),
                                    widget.floor),
                              ),
                            );
                          }).then((value) {
                        TableBookingDataSource().viewAllBooking();
                        eventBus.fire(HotDeskingInitialEvent());
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
              child: confirmButton(),
            ),
          ),
        ],
      ),
    );
  }
}
