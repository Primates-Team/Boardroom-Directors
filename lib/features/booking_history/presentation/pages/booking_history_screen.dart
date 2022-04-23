import 'package:date_picker_timeline/date_picker_timeline.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:hot_desking/core/widgets/rc.dart';
import 'package:hot_desking/features/current_booking/data/datasource/booked_ds.dart';

import '../../../../core/app_colors.dart';
import '../../../../core/app_theme.dart';
import '../widgets/room_card.dart';

class BookingHistoryScreen extends StatefulWidget {
  const BookingHistoryScreen({Key? key}) : super(key: key);

  @override
  State<BookingHistoryScreen> createState() => _BookingHistoryScreenState();
}

class _BookingHistoryScreenState extends State<BookingHistoryScreen> {
  DateTime? _selectedValue;
  DatePickerController dateController = DatePickerController();
  List _all = [];
  List _filter = [];
  bool _error = false;
  bool _processing = true;

  void initState() {
    WidgetsBinding.instance?.addPostFrameCallback((_) => loadData());
  }

  void loadData() async {
    print("in load data");
    Map bd = await BookedDataSource.getBookingHistory();
    Map tt = await BookedDataSource.getBookingMeetingHistory();

    if (bd.containsKey('flag') && bd['flag'] == false) {
      _error = true;
      _processing = false;
    }

    if (bd.containsKey('flag') && bd['flag'] == true) {
      _all = bd['data'];
      _error = false;
    }


    if (tt.containsKey('flag') && tt['flag'] == true) {
      _all.addAll(tt['data']);
      _error = false;
    }

    _processing = false;
    setState(() {});
    filter();
  }

  void filter() {
    if (_selectedValue == null) {
      _selectedValue = DateTime.now();
    }

    Future.delayed(Duration(milliseconds: 100),()=>dateController.animateToDate(_selectedValue!));


    String dt2 = _selectedValue.toString();
    var y = dt2.substring(0, 4);
    var mth = dt2.substring(5, 7);

    var dt = dt2.substring(8, 10);
    if (int.parse(mth) < 10) mth = mth.substring(1);
    if (int.parse(dt) < 10) dt = dt.substring(1);
//date format incompatibility

    String fin = dt + '-' + mth + '-' + y;
    print(fin);
    _filter = [];
    _all.forEach((element) {
      // print(element['selecteddate']);
      if (element['selecteddate'] == fin.toString()) {
        _filter.add(element);
      }
    });
    setState(() {});
  }

  Widget _drawList() {
    if (_error) return Center(child: Text("Error Occured"));
    return ListView.builder(
        physics: NeverScrollableScrollPhysics(),
        shrinkWrap: true,
        itemCount: _filter.length,
        itemBuilder: (BuildContext context, int index) {
          var node = _filter[index];
          if(node['tableid'] != null){
            return Rc(node);
          }else{
            return RoomCard(
              showWarning: false,
              allowEdit: false,fromCurrentBooking: false,node: node,onRefresh: (){}
            );
          }

        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.kGreyBackground,
      appBar: AppTheme.appBar('Booking History', context, false),
      body: _processing == true
          ? Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 20.w),
                child: Column(
                  children: [
                    Padding(
                      padding: EdgeInsets.symmetric(vertical: 20.h),
                      child: DatePicker(
                        DateTime(DateTime.now().year - 1, DateTime.now().month, DateTime.now().day),
                        controller: dateController,
                        initialSelectedDate: DateTime.now(),
                        selectionColor: Colors.black,
                        daysCount: 366,
                        selectedTextColor: Colors.white,
                        onDateChange: (date) {
                          setState(() {
                            _selectedValue = date;
                            print(_selectedValue);
                          });
                          filter();
                        },
                      ),
                    ),
                    Container(height: Get.height * 0.8, child: _drawList()),
                  ],
                ),
              ),
            ),
            
    );
  }
}
