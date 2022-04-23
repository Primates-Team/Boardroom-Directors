import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:date_picker_timeline/date_picker_timeline.dart';
import 'package:hot_desking/features/booking_history/presentation/widgets/room_card.dart';
import 'package:hot_desking/features/booking_history/presentation/widgets/table_card.dart';

import '../../../../core/app_colors.dart';
import '../../../../core/app_theme.dart';

class CalenderScreen extends StatefulWidget {
  const CalenderScreen({Key? key}) : super(key: key);

  @override
  State<CalenderScreen> createState() => _CalenderScreenState();
}

class _CalenderScreenState extends State<CalenderScreen> {
  DateTime? _selectedValue;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.kGreyBackground,
      appBar: AppTheme.appBar('Calendar', context),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 20.w),
          child: Column(
            children: [
              Padding(
                padding: EdgeInsets.symmetric(vertical: 20.h),
                child: DatePicker(
                  DateTime.now(),
                  initialSelectedDate: DateTime.now(),
                  selectionColor: Colors.black,
                  selectedTextColor: Colors.white,
                  onDateChange: (date) {
                    // New date selected
                    setState(() {
                      _selectedValue = date;
                      print(_selectedValue);
                    });
                  },
                ),
              ),
              TableCard(
                  showWarning: false,fromCurrentBooking: false,
                allowEdit: true,onRefresh: (){}
              ),
              RoomCard(
                showWarning: false,fromCurrentBooking: false,
                allowEdit: false,onRefresh: (){},
              ),
            ],
          ),
        ),
      ),
    );
  }
}
