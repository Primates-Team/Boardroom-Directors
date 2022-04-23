import 'dart:math';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hot_desking/core/app_helpers.dart';
import 'package:hot_desking/core/app_theme.dart';
import 'package:hot_desking/core/widgets/cancel_button.dart';
import 'package:hot_desking/core/widgets/text_widget.dart';
import 'package:hot_desking/features/booking/widgets/confirm_button.dart';

class EditBookingDialog extends StatefulWidget {
  final String type;
  final dynamic node;
  final Function onDelete;
  final Function onEdit;

  const EditBookingDialog(
      {Key? key, required this.type, required this.node, required this.onDelete, required this.onEdit})
      : super(key: key);

  @override
  State<EditBookingDialog> createState() => _EditBookingDialogState();
}

class _EditBookingDialogState extends State<EditBookingDialog> {
  String selectdDate = '04-01-2022';

  List<String> members = ['Rajesh', 'Suresh', 'Kamal', 'Manikandan'];

  String startTime = "11", endTime = "4";

  @override
  void initState() {
    // startTime = widget.startTime;
    if (widget.node != null && widget.node['selecteddate'] != null) {
      selectdDate = widget.node['selecteddate'];
    }
    if (widget.node != null && widget.node['fromtime'] != null && widget.node['totime'] != null) {
      startTime = widget.node['fromtime'];
      endTime = widget.node['totime'];
    }

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      // height: 227.h,
      width: 326.w,
      padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 15.h),
      decoration: AppTheme.boxDecoration,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: Text(
              widget.type == 'Table'
                  ? 'Table ${widget.node != null ? widget.node["tableid"] != null ? widget.node['tableid'] : widget.node['id'] != null ? widget.node['id'] : 1 : 1}'
                  : 'Room ${widget.node['id'] != null ? widget.node['id'] : 1}',
              style: const TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 18,
              ),
            ),
          ),
          SizedBox(
            height: 19.h,
          ),
          Row(
            children: [
              Expanded(
                flex: 1,
                child: Column(
                  children: [
                    textWidget('Date'),
                    textWidget('Timing'),
                    if (widget.type == 'Room')
                      SizedBox(height: 100, child: Align(alignment: Alignment.topLeft, child: textWidget('Members'))),
                  ],
                ),
              ),
              Expanded(
                flex: 2,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    InkWell(
                      onTap: () {
                        showDatePicker(
                                context: context,
                                initialDate: DateTime.now(),
                                firstDate: DateTime.now(),
                                lastDate: DateTime.now().add(const Duration(days: 180)))
                            .then((value) {
                          if (value == null) return;
                          setState(() {
                            selectdDate = AppHelpers.formatDate(value);
                          });
                        });
                      },
                      child: Container(
                          height: 32.h,
                          width: 170.w,
                          margin: EdgeInsets.symmetric(vertical: 4.5.h),
                          padding: EdgeInsets.symmetric(horizontal: 20),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Row(children: [Text(selectdDate), Spacer(), Icon(Icons.calendar_month)])),
                    ),
                    Container(
                      height: 32.h,
                      width: 170.w,
                      padding: EdgeInsets.symmetric(horizontal: 20),
                      margin: EdgeInsets.symmetric(vertical: 4.5.h),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Row(
                        children: [
                          InkWell(
                            onTap: () {
                              showTimePicker(
                                context: context,
                                initialTime: TimeOfDay(
                                    hour: startTime.contains(":")
                                        ? int.parse(startTime.split(":").first)
                                        : int.parse(startTime),
                                    minute: startTime.contains(":")
                                        ? int.parse(startTime.split(":").last)
                                        :00),
                              ).then((value) {
                                if (value == null) return;
                                setState(() {
                                  startTime = AppHelpers.formatTime(value);
                                });
                              });
                            },
                            child: Text(startTime ),
                          ),
                          Text("-"),
                          InkWell(
                            onTap: () {
                              showTimePicker(
                                context: context,
                                initialTime: TimeOfDay(
                                    hour: endTime.contains(":")
                                        ? int.parse(endTime.split(":").first)
                                        : int.parse(endTime),
                                    minute: endTime.contains(":")
                                        ? int.parse(endTime.split(":").last)
                                        :00),
                              ).then((value) {
                                if (value == null) return;
                                setState(() {
                                  endTime = AppHelpers.formatTime(value);
                                });
                              });
                            },
                            child: Text(endTime),
                          ),
                          Spacer(), Icon(Icons.calendar_month)
                        ],
                      ),
                    ),
                    if (widget.type == 'Room')
                      Container(
                        height: 100.h,
                        width: 170.w,
                        padding: EdgeInsets.all(8.0),
                        margin: EdgeInsets.symmetric(vertical: 4.5.h),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Text(members.join(', ')),
                      ),
                  ],
                ),
              ),
            ],
          ),
          SizedBox(
            height: 20.h,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              InkWell(
                onTap: () async {
                  Navigator.pop(context);
                  widget.onEdit(selectdDate,startTime,endTime);
                },
                child: confirmButton(),
              ),
              InkWell(
                onTap: () {
                  Navigator.pop(context);
                  widget.onDelete();
                },
                child: cancelButton(),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
