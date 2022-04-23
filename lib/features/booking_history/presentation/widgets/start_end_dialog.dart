import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hot_desking/core/app_theme.dart';
import 'package:hot_desking/core/widgets/text_widget.dart';
import 'package:hot_desking/features/booking/widgets/confirm_button.dart';

class StartEndDialog extends StatefulWidget {
  final String type;
  const StartEndDialog({Key? key, required this.type}) : super(key: key);

  @override
  State<StartEndDialog> createState() => _StartEndDialogState();
}

class _StartEndDialogState extends State<StartEndDialog> {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 326.w,
      padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 15.h),
      decoration: AppTheme.boxDecoration,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: Text(
              widget.type == 'Table' ? 'Table 1' : 'Room 1',
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
                    // if (widget.type == 'Room')
                    //   SizedBox(
                    //       height: 100,
                    //       child: Align(
                    //           alignment: Alignment.topLeft,
                    //           child: textWidget('Members'))),
                  ],
                ),
              ),
              Expanded(
                flex: 2,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      height: 32.h,
                      width: 170.w,
                      margin: EdgeInsets.symmetric(vertical: 4.5.h),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: TextField(
                        readOnly: true,
                        // controller: dateController,
                        decoration:
                            AppTheme.textFieldDecoration('Date').copyWith(
                          suffixIcon: Icon(Icons.calendar_month),
                        ),
                      ),
                    ),
                    Container(
                      height: 32.h,
                      width: 170.w,
                      margin: EdgeInsets.symmetric(vertical: 4.5.h),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: InkWell(
                        // onTap: () {
                        //   showTimePicker(
                        //     context: context,
                        //     initialTime: startTime!,
                        //   ).then((value) {
                        //     if (value == null) return;
                        //     setState(() {
                        //       startTime = value;
                        //     });
                        //   });
                        // },
                        child: TextField(
                          readOnly: true,
                          // controller: timeController,
                          decoration:
                              AppTheme.textFieldDecoration('Time').copyWith(
                            suffixIcon: Icon(Icons.calendar_month),
                          ),
                        ),
                      ),
                    ),
                    // if (widget.type == 'Room')
                    //   Container(
                    //     height: 100.h,
                    //     width: 170.w,
                    //     padding: EdgeInsets.all(8.0),
                    //     margin: EdgeInsets.symmetric(vertical: 4.5.h),
                    //     decoration: BoxDecoration(
                    //       color: Colors.white,
                    //       borderRadius: BorderRadius.circular(10),
                    //     ),
                    //     child: Text(members.join(', ')),
                    //   ),
                  ],
                ),
              ),
            ],
          ),
          SizedBox(
            height: 20.h,
          ),
          InkWell(
            onTap: () async {
              Navigator.pop(context);
            },
            child: Center(child: confirmButton('Start')),
          ),
        ],
      ),
    );
  }
}
